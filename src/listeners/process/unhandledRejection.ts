/* eslint-disable consistent-return */
import { DiscordAPIError, Constants } from 'discord.js';
import { Listener } from '@sapphire/framework';

export class RejectionListener extends Listener {
	public run(err: DiscordAPIError) {
		const ignore: number[] = [
			Constants.APIErrors.MISSING_PERMISSIONS,
			Constants.APIErrors.UNKNOWN_MESSAGE,
			Constants.APIErrors.MISSING_ACCESS,
			Constants.APIErrors.CANNOT_MESSAGE_USER,
			Constants.APIErrors.UNKNOWN_CHANNEL,
			Constants.APIErrors.INVALID_FORM_BODY
		];

		if (ignore.includes(err.code)) return;

		this.container.logger.error(`Unhandled Rejection: ${err.stack}`);
	}
}
