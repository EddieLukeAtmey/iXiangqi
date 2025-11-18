//
//  Position.swift
//  Xiangqi
//
//  Created by Eddie on 19/07/2023.
//

import Foundation

/// In an axis with origin located in top-left
struct Position: Equatable {

    let x: Int
    let y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// Return nil if out of board (invalid position)
    init?(_ x: Int, _ y: Int) {

        if x < 0 || x >= BoardSize.h { return nil }
        if y < 0 || y >= BoardSize.v { return nil }

        self.x = x
        self.y = y
    }
}

// MARK: - actions
extension Position {

    // https://medium.com/sahibinden-technology/bitwise-enum-values-with-the-optionset-in-swift-c5547003478f
    struct MoveDirection: OptionSet {
        let rawValue: Int
        static let left = MoveDirection(rawValue: 1 << 0)
        static let right = MoveDirection(rawValue: 1 << 1)
        static let up = MoveDirection(rawValue: 1 << 2)
        static let down = MoveDirection(rawValue: 1 << 3)
        static let all: MoveDirection = [.left, .right, .up, .down]
        static let allCases: [MoveDirection] = [.left, .right, .up, .down]
    }

    func move(_ d: MoveDirection, _ step: Int) -> Position? {
        var p: Position? = self
        if d.contains(.left) { p = p?.moveLeft(step) }
        if d.contains(.right) { p = p?.moveRight(step) }
        if d.contains(.up) { p = p?.moveUp(step) }
        if d.contains(.down) { p = p?.moveDown(step) }

        return p
    }

    func moveLeft(_ step: Int) -> Position? {
        return .init(x - step, y)
    }

    func moveRight(_ step: Int) -> Position? {
        return .init(x + step, y)
    }

    func moveUp(_ step: Int) -> Position? {
        return .init(x, y - step)
    }

    func moveDown(_ step: Int) -> Position? {
        return .init(x, y + step)
    }

    func isInCastle(_ side: GameSide? = nil) -> Bool {
        guard x.isIn(CastleHorizontalRange) else { return false }

        let black = BlackCastle.v
        let red = RedCastle.v

        guard let side else { return y.isIn(red) || y.isIn(black) }
        if side == .white { return y.isIn(red) }
        return y.isIn(black)
    }
}

extension Position: Hashable {
    
}
