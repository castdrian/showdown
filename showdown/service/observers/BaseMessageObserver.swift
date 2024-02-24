//
//  BaseMessageObserver.swift
//  showdown
//
//  Created by Adrian Castro on 24.02.24.
//

import Foundation

protocol UiCallbacks {
    // Define methods that UI elements need to implement
}

class BaseMessageObserver<C: UiCallbacks> {
    weak var service: ShowdownService?
    var uiCallbacks: C? {
        didSet {
            if uiCallbacks != nil {
                onUiCallbacksAttached()
            }
        }
    }

    init(service: ShowdownService) {
        self.service = service
    }

    var observedRoomId: String?
    var interceptCommandBefore: Set<String> {
        return []
    }

    var interceptCommandAfter: Set<String> {
        return []
    }

    func postMessage(_ message: ServerMessage, forcePost: Bool = false) {
        if forcePost || observedRoomId == message.roomId {
            onMessage(message)
        }
    }

    func onUiCallbacksAttached() {
        // Override in subclasses to perform actions when UI callbacks are attached
    }

    func onMessage(_ message: ServerMessage) {
        // Override in subclasses to handle the incoming messages
    }
}
