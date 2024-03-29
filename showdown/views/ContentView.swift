//
//  ContentView.swift
//  showdown
//
//  Created by Adrian Castro on 23.02.24.
//

import SwiftUI

extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

struct ContentView: View {
    @State private var tabSelection: Int = 1
    @State var showingPopup = false
    
    func hapticFeedback(value: Int) {
        self.tabSelection = value
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    var body: some View {
        TabView (selection: $tabSelection.onUpdate {
            hapticFeedback(value: tabSelection)
        }) {
            HomeView()
                .tabItem {
                    Label("Home", image: "pkball")
                }
            Text("Account")
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
