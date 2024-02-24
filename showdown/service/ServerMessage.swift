//
//  ServerMessage.swift
//  showdown
//
//  Created by Adrian Castro on 24.02.24.
//

import Foundation

struct ServerMessage {
    let roomId: String
    let command: String
    let args: [String]
    let kwargs: [String: String]
    
    private let separator: Character = "|"
    private var argsIterator: IndexingIterator<[String]>
    
    init(roomId: String, data: String) {
        self.roomId = roomId
        
        if data == String(separator) {
            self.command = "break"
            self.args = []
            self.kwargs = [:]
        } else if data.first != separator || data.dropFirst().first == separator {
            self.command = "raw"
            let (arguments, kwArguments) = ServerMessage.parseArguments(data, escapeKwargs: true)
            self.args = arguments
            self.kwargs = kwArguments
        } else {
            let components = data.split(separator: separator, maxSplits: 1, omittingEmptySubsequences: false)
            if components.count < 2 {
                self.command = String(components[0].dropFirst())
                self.args = []
                self.kwargs = [:]
            } else {
                self.command = String(components[0].dropFirst())
                let (arguments, kwArguments) = ServerMessage.parseArguments(String(components[1]), escapeKwargs: ["formats", "c", "c:", "tier", "error"].contains(self.command))
                self.args = arguments
                self.kwargs = kwArguments
            }
        }
        
        self.argsIterator = self.args.makeIterator()
    }
    
    private static func parseArguments(_ rawArgs: String, escapeKwargs: Bool) -> ([String], [String: String]) {
        let args = rawArgs.split(separator: "|").filter { !$0.isEmpty && (escapeKwargs || !($0.hasPrefix("[") && $0.contains("]"))) }
        let kwargs = rawArgs.split(separator: "|").filter { !$0.isEmpty && !escapeKwargs }
            .reduce(into: [String: String]()) { dict, part in
                let key = part.dropFirst().split(separator: "]")[0]
                let value = part.split(separator: "]").dropFirst().joined().trimmingCharacters(in: .whitespaces)
                dict[String(key)] = value
            }
        
        return (args.map(String.init), kwargs)
    }
    
    mutating func newArgsIteration() {
        argsIterator = args.makeIterator()
    }
    
    mutating func nextArg() -> String? {
        argsIterator.next()
    }
    
    mutating func nextArgSafe() -> String? {
        hasNextArg() ? argsIterator.next() : nil
    }
    
    mutating func hasNextArg() -> Bool {
        var tempIterator = argsIterator
        return tempIterator.next() != nil
    }
    
    func remainingArgsRaw() -> String {
        args[argsIterator.underestimatedCount...].joined(separator: String(separator))
    }
}
