//
//  Rook.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation

/// 俥 or 車
final class Rook: GamePiece {
    override var title: String { "車" }

    override var availableMoves: [Move] {
        var moves = [Move]()

        for direction in Position.MoveDirection.allCases {
            var step = 1
            while let pos = position.move(direction, step), let m = Move(self, to: pos) {
                moves.append(m)
                step += 1

                if m.captured != nil { break } // End of process
            }
        }

        return moves
    }
}
