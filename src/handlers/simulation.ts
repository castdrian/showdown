import { Dex, Teams, RandomPlayerAI, BattleStreams, PokemonSet } from '@pkmn/sim';
import { Protocol, Handler, ArgName, ArgType, BattleArgsKWArgType } from '@pkmn/protocol';
import { Battle } from '@pkmn/client';
import { TeamGenerators } from '@pkmn/randoms';
import { LogFormatter } from '@pkmn/view';
import { Generations } from '@pkmn/data';
import { PreHandler } from '#handlers/prehandler';
import { PostHandler } from '#handlers/posthandler';
import type { CommandInteraction } from 'discord.js';
import { moveChoice, updateBattleEmbed } from '#handlers/battlescreen';
import { default as removeMD } from 'remove-markdown';
import { waitFor } from '#util/functions';

export async function initiateBattle(interaction: CommandInteraction, formatid: string, team: PokemonSet[] | null) {
	Teams.setGeneratorFactory(TeamGenerators);
	const gens = new Generations(Dex as any);
	const custom_team = Teams.pack(team);

	const spec = { formatid };
	const p1spec = { name: interaction.user.username, team: custom_team ?? Teams.pack(Teams.generate('gen8randombattle')) };
	const p2spec = { name: 'Showdown! AI', team: Teams.pack(Teams.generate('gen8randombattle')) };

	const streams = BattleStreams.getPlayerStreams(new BattleStreams.BattleStream());

	const p2 = new RandomPlayerAI(streams.p2);
	void p2.start();

	const battle = new Battle(gens);
	const formatter = new LogFormatter('p1', battle);

	const pre = new PreHandler(battle);
	const post = new PostHandler(battle);

	const add = <T>(h: Handler<T>, k: ArgName | undefined, a: ArgType, kw: BattleArgsKWArgType) => {
		if (k && k in h) (h as any)[k](a, kw);
	};

	process.battlelog = [];
	process.fainted = null;

	await Promise.all([omnicientStream(), playerStream(), startBattle()]);

	async function omnicientStream() {
		for await (const chunk of streams.omniscient) {
			for (const line of chunk.split('\n')) {
				const { args, kwArgs } = Protocol.parseBattleLine(line);
				const text = formatter.formatText(args, kwArgs);
				const key = Protocol.key(args);

				add(pre, key, args, kwArgs);
				battle.add(args, kwArgs);
				add(post, key, args, kwArgs);

				if (text !== '') process.battlelog.push(removeMD(text));
				console.log(removeMD(text));
			}
			battle.update();
		}
	}

	async function playerStream() {
		for await (const chunk of streams.p1) {
			for (const line of chunk.split('\n')) {
				const { args, kwArgs } = Protocol.parseBattleLine(line);
				battle.add(args, kwArgs);
			}
			battle.update();

			if (battle.request?.requestType === 'move') {
				await waitFor(() => process.battlelog.length !== 0);
				/* 	if (battle.p1.lastPokemon?.name) {
					process.battlelog = [];
					await switchChoice(streams, battle, interaction);
					await waitFor(() => process.battlelog.length !== 0);
					await updateBattleEmbed(battle, interaction);
				} else { */
				await updateBattleEmbed(battle, interaction);
				await moveChoice(streams, battle, interaction);
				process.battlelog = [];
				// }
			}
		}
	}

	async function startBattle() {
		await streams.omniscient.write(`>start ${JSON.stringify(spec)}
>player p1 ${JSON.stringify(p1spec)}
>player p2 ${JSON.stringify(p2spec)}`);
	}
}
