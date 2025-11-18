//
//  MoveView.swift
//  ChessGames
//
//  Created by Eddie on 21/07/2023.
//

import SwiftUI

struct MoveView: View {
    let move: Move
    let spacing: CGFloat

    var body: some View {
        Circle()
            .fill(getFillColor())
            .frame(width: spacing / 5, height: spacing / 5)
            .position(x: CGFloat(move.to.x) * spacing, y: CGFloat(move.to.y) * spacing)
    }

    private func getFillColor() -> Color {
        if let captured = move.captured {
            return captured.side == .white ? Color.black : Color.red
        } else {
            return Color.green
        }
    }
}
