//
//  Knight.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation

/// 馬 or 傌
final class Knight: GamePiece {
    override var title: String {
        side == .white ? "傌" : "馬"
    }

    /// Knights moves one straight (horizontal || vertical) then one diagonal (up-left, up-right, down-left, down-right)
    override var availableMoves: [Move] {
        var moves = [Move]()

        for direction in Position.MoveDirection.allCases {
            guard let straightMovePosition = position.move(direction, 1), gameManager?.getPiece(at: straightMovePosition) == nil else { continue }

            let diagonalDirections: [Position.MoveDirection]
            switch direction {
            case .up, .down:
                diagonalDirections = [.left, .right]
            case .left, .right:
                diagonalDirections = [.up, .down]
            default: fatalError("Invalid case!")
            }
            
            for diagonalDirection in diagonalDirections {
                if let pos = straightMovePosition.move(direction, 1)?.move(diagonalDirection, 1), let move = Move(self, to: pos) {
                    moves.append(move)
                }
            }
        }

        return moves
    }
}
