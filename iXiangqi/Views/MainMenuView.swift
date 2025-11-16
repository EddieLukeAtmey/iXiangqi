//
//  MainMenuView.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

struct MainMenuView: View {

    @State private var isGameViewPresented = false

    var body: some View {
        ZStack {
            Color(red: 240/255, green: 208/255, blue: 160/255).ignoresSafeArea()

            VStack {
                Text("Welcome to my game!")
                    .font(.title)

                Spacer()

                Button(action: {
//                    UIView.setAnimationsEnabled(false)
                    isGameViewPresented = true

                }, label: {
                    Text("Play")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })

                Spacer()
            }
        }
#if targetEnvironment(simulator)
        .fullScreenCover(isPresented: $isGameViewPresented) {
            GameView()
        }
#else
        .fullScreenCover(isPresented: $isGameViewPresented) {
            GameView(gameManager: gameManager)
                .environmentObject(gameManager)
        }
#endif
        .transaction { t in
            t.disablesAnimations = true
            t.animation = .linear(duration: 1)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
