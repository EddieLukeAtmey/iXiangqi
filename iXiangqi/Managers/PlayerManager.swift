//
//  PlayerManager.swift
//  iXiangqi
//
//  Created by Ngoc Dang on 18/11/25.
//

import Foundation

enum PlayerAction {
    case touch
    case move(from: Position, to: Position)
}

final class PlayerManager: ObservableObject {
    @Published var currentPlayer: UUID = .init()
}
