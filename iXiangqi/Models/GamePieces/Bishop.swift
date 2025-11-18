//
//  Bishop.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation

/// 象 or 相
final class Bishop: GamePiece {
    override var title: String {
        side == .white ? "相" : "象"
    }

    override var availableMoves: [Move] {
        var moves = [Move]()

        for direction in [Position.MoveDirection.up, .down] {
            for side in [Position.MoveDirection.left, .right] {
                if let pos = position.move([direction, side], 2), canMoveByRule(to: pos) {
                    if let move = Move(self, to: pos) {
                        moves.append(move)
                    }
                }
            }
        }

        return moves
    }
    
    private func canMoveByRule(to: Position) -> Bool {
        // Can't cross the river
        if (side == .white && to.y < 5) || (side == .black && to.y > 4) {
            return false
        }
        
        // Check if there is a piece blocking the move
        let midX = (position.x + to.x) / 2
        let midY = (position.y + to.y) / 2
        let midPos = Position(x: midX, y: midY)
        
        return gameManager?.getPiece(at: midPos) == nil 
    }

    override func canCheck(_ king: General) -> Bool {
        return false
    }
}
