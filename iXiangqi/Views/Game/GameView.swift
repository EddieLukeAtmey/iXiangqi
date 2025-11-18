//
//  GameView.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

struct GameView: View {

    // TODO: Can be refactor
    @StateObject var gameManager: GameManager = GameManager()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                TopMenuView()

                PlayerInfoView(name: "Black",
                               side: .black,
                               timer: $gameManager.p2Timer,
                               capturedPieces: $gameManager.blackCapturedPieces)

                Spacer(minLength: 10)
                BoardView()
                    .frame(width: min(geometry.size.width, geometry.size.height),
                           height: min(geometry.size.width, geometry.size.height))

                Spacer(minLength: 30)

                PlayerInfoView(name: "Red",
                               side: .white,
                               timer: $gameManager.p1Timer,
                               capturedPieces: $gameManager.redCapturedPieces)
            }
            .environmentObject(gameManager)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
    }
}
