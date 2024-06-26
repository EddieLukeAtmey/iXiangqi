//
//  GamePieceView.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

struct GamePieceView: View {

    let piece: GamePiece
    var selected = false

    var body: some View {

        Text(piece.title)
            .padding(5)
            .foregroundColor(piece.color)
            .fontWeight(.bold)
            .background (
                Circle()
                    .stroke(piece.color, lineWidth: 1)
                    .background(Circle().fill(Color(white: 0.8)))
                    .aspectRatio(1, contentMode: .fill)
            )
            .scaleEffect(selected ? 1.5 : 1.0)
//            .animation(.easeInOut(duration: 0.2), value: selected)
    }
}

#Preview {
    GamePieceView(piece: General(position: .init(x: 0, y: 0), side: .black, gameManager: .init()), selected: false)
}
