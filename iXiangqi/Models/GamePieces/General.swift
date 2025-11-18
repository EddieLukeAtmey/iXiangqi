//
//  General.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation

/// 帥 or 將
final class General: GamePiece {
    override var title: String {
        side == .white ? "帥" : "將"
    }

    override var availableMoves: [Move] {
        var moves = [Move]()
        
        MoveDirection.allCases.forEach {
            guard let pos = position.move($0, 1), pos.isInCastle(side) else { return }
            guard let move = Move(self, to: pos) else { return }
            moves.append(move)
        }

        // special move: flying general
        let offSet = side == .black ? 1 : -1
        var i = position.y + offSet

        while let p = Position(position.x, i) {
            guard let piece = gameManager?.getPiece(at: p) else { // No blocking piece
                i += offSet
                continue
            }

            // is blocked by a general
            if piece is General, let m = Move(self, to: p) {
                moves.append(m)
            }// else
            break
        }

        return moves
    }
}
