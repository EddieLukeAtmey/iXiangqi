//
//  PlayerInfoView.swift
//  iXiangqi
//
//  Created by Eddie Luke Atmey on 1/6/24.
//

import SwiftUI

struct PlayerInfoView: View {

    let name: String
    let side: GameSide
    @Binding var timer: Int
    @Binding var capturedPieces: [GamePiece]

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.title)
                .foregroundColor(side == .red ? .red : .black)
            Text(formattedTime(from: timer))
                .font(.title)

            LazyVGrid(columns: [GridItem(.adaptive(minimum:25))]) {
                ForEach(Array(capturedPieces.enumerated()), id: \.offset) { _, piece in
                    GamePieceView(piece: piece)
                }
            }
        }
    }

    private func formattedTime(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let gm = GameManager()
    let pieces = gm.pieces.dropLast(15)

    return PlayerInfoView(name: "Hhihi", side: .red, timer: .constant(100), capturedPieces: .constant([]))
}
