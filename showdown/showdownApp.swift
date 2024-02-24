//
//  showdownApp.swift
//  showdown
//
//  Created by Adrian Castro on 23.02.24.
//

import SwiftUI

@main
struct showdownApp: App {
    let showdownService = ShowdownService.shared
    
    init() {
        showdownService.connectToServer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
