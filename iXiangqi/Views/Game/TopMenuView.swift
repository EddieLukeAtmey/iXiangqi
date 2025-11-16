//
//  TopMenuView.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

struct TopMenuView: View {

    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        switch gameManager.state {
        case .initialized:
            Button(action: {
                gameManager.start()
            }, label: {
                Text("Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })

        case .ended(let losingSide):
            VStack {
                if let losingSide {
                    Text("\(String(describing: losingSide)) loses")
                        .font(.title)
                        .textCase(.uppercase)
                } else {
                    Text("Draw")
                        .font(.subheadline)
                        .textCase(.uppercase)
                }

                Button(action: {
                    gameManager.resetBoard()
                }, label: {
                    Text("Restart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }

        case .isPlaying(let movingSide):
            Text("\(String(describing: movingSide))'s turn")
                .font(.title)
                .textCase(.uppercase)
        }
    }

}

struct TopMenuView_Previews: PreviewProvider {

    static var previews: some View {
        TopMenuView()
    }
}
