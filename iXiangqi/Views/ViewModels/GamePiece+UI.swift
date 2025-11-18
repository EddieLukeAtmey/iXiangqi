//
//  GamePiece+UI.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

extension GamePiece {
    var color: Color { side == .white ? .red : .black }
}

extension GamePiece: Hashable {

    static func == (lhs: GamePiece, rhs: GamePiece) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
