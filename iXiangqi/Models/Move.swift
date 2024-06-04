//
//  Move.swift
//  Xiangqi
//
//  Created by Eddie on 19/07/2023.
//

import Foundation

// A single move a game piece can do at a turn
struct Move {
    let piece: GamePiece
    let to: Position
    let captured: GamePiece?

    /**
     Initializes a potential move for a game piece to a specified position.

     - Parameters:
        - piece: The `GamePiece` to be moved.
        - to: The `Position` to which the piece is to be moved.

     - Returns: An optional instance of the move if the move is valid, otherwise `nil`.

     - Initialization Logic:
         - Assigns the `piece` to be moved and the target `to` position to the corresponding properties.
         - Attempts to get the piece at the target position using the `gameManager` of the piece.
             - If no piece is found at the target position, it sets `captured` to `nil`, allowing the move to an empty spot.
         - Checks if the piece at the target position belongs to the opponent.
             - If the piece at the target position is an ally, the initializer returns `nil` as moving to an ally's position is invalid.
         - If the piece at the target position is an opponent, it assigns the opponent piece to `captured`.

     - Example:
     ```
     if let move = Move(piece, to: targetPosition) {
     // The move is valid and can be executed
     } else {
     // The move is invalid
     }
     ```
     */
    init?(_ piece: GamePiece, to: Position) {
        self.piece = piece
        self.to = to

        guard let capturingPiece = piece.gameManager?.getPiece(at: to) else { captured = nil; return } // ok to move to empty spot
        guard capturingPiece.side != piece.side else { return nil } // move to ally

        captured = capturingPiece
    }

    /// - returns: original position
    func perform() -> Position {
        let org = piece.position
        piece.position = to
        return org
    }
}

extension Move: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.piece == rhs.piece && lhs.to == rhs.to && lhs.captured == rhs.captured
    }
}
