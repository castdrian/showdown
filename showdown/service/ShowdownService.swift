//
//  ShowdownService.swift
//  showdown
//
//  Created by Adrian Castro on 24.02.24.
//

import Foundation
import NWWebSocket
import Network

class ShowdownService {
    static let shared = ShowdownService()
    
    private var webSocket: NWWebSocket?
    private var isConnected: Bool = false
    
    private init() {}
    
    func connectToServer() {
        guard !isConnected else { return }
        let socketURL = URL(string: "wss://sim3.psim.us/showdown/websocket")!
        webSocket = NWWebSocket(url: socketURL, connectAutomatically: true)
        webSocket?.delegate = self
    }
    
    func reconnectToServer() {
        if (isConnected) { return }
        connectToServer()
    }
    
    func disconnectFromServer() {
        webSocket?.disconnect()
        isConnected = false
    }
}

extension ShowdownService: WebSocketConnectionDelegate {
    func webSocketDidConnect(connection: WebSocketConnection) {
        isConnected = true
    }
    
    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        isConnected = false
        if closeCode == .protocolCode(.abnormalClosure) || closeCode == .protocolCode(.noStatusReceived) {
            connectToServer()
        }
    }
    
    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
    }
    
    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
    }
    
    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
    }
    
    func webSocketDidReceivePong(connection: WebSocketConnection) {
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
    }
    
    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
    }
}
