//
//  Canon.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation

/// 炮 or 砲
final class Cannon: GamePiece {
    override var title: String {
        side == .white ? "砲" : "炮"
    }

    override var availableMoves: [Move] {
        var moves = [Move]()

        for direction in Position.MoveDirection.allCases {
            var hasJumpOver = false
            var step = 1
        posLoop: while let pos = position.move(direction, step) {
                step += 1

                // empty space
                if gameManager?.getPiece(at: pos) == nil {
                    if !hasJumpOver { moves.append(Move(self, to: pos)!) }
                    continue posLoop
                }
                
                // has obstacle
                if hasJumpOver { // had one
                    if let m = (Move(self, to: pos)) { // Can capture
                        moves.append(m)
                    }
                    break posLoop
                }
                else { // blocked
                    hasJumpOver = true
                }
            }
        }
        return moves
    }
}
