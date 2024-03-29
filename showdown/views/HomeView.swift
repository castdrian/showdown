//
//  HomeView.swift
//  showdown
//
//  Created by Adrian Castro on 24.02.24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.openURL) var openURL
    @State private var disallowSpectators = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Connected as user")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
            }.padding(.bottom, 25)
            
            Group {
                Text("Format:")
                    .padding(.horizontal, 20)
                Menu {
                    Button("Option 1", action: {})
                    Button("Option 2", action: {})
                } label: {
                    Text("[Gen 9] Random Battle")
                        .foregroundColor(.white)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Team:")
                    .padding(.horizontal, 20)
                
                Menu {
                    Button("Option 1", action: {})
                    Button("Option 2", action: {})
                } label: {
                    VStack {
                        Text("Random Team")
                            .foregroundColor(.white)
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 4)
                        HStack {
                            ForEach(0..<6) { _ in
                                Image(systemName: "questionmark.app")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5)
                }
                .padding(.horizontal, 20)
            }
            
            HStack {
                Toggle("Don't allow spectators", isOn: $disallowSpectators)
                Spacer()
            }
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                disallowSpectators.toggle()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Button(action: {}) {
                HStack {
                    Spacer()
                    Text("Battle!")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .foregroundColor(.white)
            .font(.headline)
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green.opacity(0.5))
            .cornerRadius(5)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            HStack {
                Spacer()
                Button(action: {
                    openURL(URL(string: "https://play.pokemonshowdown.com/teambuilder")!)
                }) {
                    HStack {
                        Spacer()
                        Text("Teambuilder")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(5)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                Spacer()
                Button(action: {
                    openURL(URL(string: "https://play.pokemonshowdown.com/ladder")!)
                }) {
                    HStack {
                        Spacer()
                        Text("Ladder")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }                .foregroundColor(.white)
                    .font(.headline)
                    .bold()
                    .frame(width: 200)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(5)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                Spacer()
                Button(action: {}) {
                    HStack {
                        Spacer()
                        Text("Find a user")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }                .foregroundColor(.white)
                    .font(.headline)
                    .bold()
                    .frame(width: 200)
                    .padding(.vertical, 10)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(5)
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
