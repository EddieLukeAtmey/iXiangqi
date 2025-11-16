//
//  GameManager.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import Foundation
import Combine

enum GameState {
    case initialized
    case isPlaying(_ movingTurn: GameSide)
    case ended(_ losingSide: GameSide?)
}

final class GameManager: ObservableObject {
    private(set) var pieces: [GamePiece]
    private var capturedPieces: [GamePiece] { redCapturedPieces + blackCapturedPieces }

    private func piecesCaptured(by side: GameSide) -> [GamePiece] {
        capturedPieces.filter({ $0.side != side })
    }

    /// This array is black's side game pieces, those captured by red.
    @Published var redCapturedPieces = [GamePiece]()

    /// This array is red's side game pieces, those captured by red.
    @Published var blackCapturedPieces = [GamePiece]()

    // moves and their original position
    private(set) var moves = [(Move, Position)]()
    @Published private(set) var state = GameState.initialized
    private(set) var currentPlayer: GameSide = .red {
        didSet { state = .isPlaying(currentPlayer) }
    }

    @Published var p1Timer: Int = DefaultPlayTimeSeconds
    @Published var p2Timer: Int = DefaultPlayTimeSeconds

    private(set) var timer: AnyCancellable?

    // MARK: - Setup
    init() {
        pieces = []
        resetBoard()
    }

    static let allStartingPositions: [Position] = {
        var p = [Position]()
        for i in BoardMarkerH.left...BoardMarkerH.right {
            p.append(.init(x: i, y: BoardMarkerV.blackBot))
            p.append(.init(x: i, y: BoardMarkerV.redBot))

            // Pawn
            if i & 1 == 0 {
                p.append(.init(x: i, y: BoardMarkerV.blackRiver - 1))
                p.append(.init(x: i, y: BoardMarkerV.redRiver + 1))
            }

            if i == BoardMarkerH.leftCanon || i == BoardMarkerH.rightCanon {
                // Cannon
                p.append(.init(x: i, y: BoardMarkerV.blackMid))
                p.append(.init(x: i, y: BoardMarkerV.redMid))
            }
        }

        return p
    }()

    func resetBoard() {

        // setup pieces and poisition
        pieces.removeAll()
        redCapturedPieces.removeAll()
        blackCapturedPieces.removeAll()
        moves.removeAll()

        Self.allStartingPositions.forEach { pos in

            let side: GameSide = pos.y > BoardMarkerV.redRiver ? .red : .black

            switch (pos.x, pos.y) {

            case (_, BoardMarkerV.blackRiver - 1): fallthrough
            case (_, BoardMarkerV.redRiver + 1):
                pieces.append(Pawn(position: pos, side: side, gameManager: self))

            case (_, BoardMarkerV.blackMid): fallthrough
            case (_, BoardMarkerV.redMid):
                pieces.append(Cannon(position: pos, side: side, gameManager: self))

            case (let x, _):
                let piece: GamePiece
                switch x {
                case BoardMarkerH.left, BoardMarkerH.right: piece = Rook(position: pos, side: side, gameManager: self)
                case BoardMarkerH.leftCanon, BoardMarkerH.rightCanon: piece = Knight(position: pos, side: side, gameManager: self)
                case BoardMarkerH.midLeft, BoardMarkerH.midRight: piece = Bishop(position: pos, side: side, gameManager: self)
                case BoardMarkerH.castleL, BoardMarkerH.castleR: piece = Advisor(position: pos, side: side, gameManager: self)
                case BoardMarkerH.center: piece = General(position: pos, side: side, gameManager: self)
                default: fatalError("Uknown Position")
                }

                pieces.append(piece)
            }
        }

        state = .initialized
        p1Timer = DefaultPlayTimeSeconds
        p2Timer = DefaultPlayTimeSeconds
    }

    func getGeneral(of side: GameSide) -> General {
        pieces.first(where: { $0.side == side && $0 is General }) as! General
    }

    func getPiece(at position: Position) -> GamePiece? {
        pieces.first { $0.position == position }
    }

    func start() {
        state = .isPlaying(.red)
        startTimer()
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.currentPlayer == .red {
                    self.p1Timer -= 1
                } else {
                    self.p2Timer -= 1
                }

                if self.p1Timer > 0, self.p2Timer > 0 { return }
                self.endGame(loser: self.currentPlayer)
            }
    }
}

// MARK: - Actions
extension GameManager {
    func performMove(_ move: Move) throws {
        // Check if the move is valid and update the game state accordingly
        try validateMove(move)
        if let captured = move.captured, let idx = pieces.firstIndex(of: captured) {
            if captured.side == .red {
                blackCapturedPieces.append(captured)
            } else {
                redCapturedPieces.append(captured)
            }
            pieces.remove(at: idx)
        }

        let org = move.perform()
        moves.append((move, org))

        updateGameStatusAfterMove()
    }

    func endGame(loser: GameSide? = nil) {
        timer?.cancel()
        state = .ended(loser)

        print("Game ended: \(loser != nil ? loser.debugDescription : "Draw")")
    }
    
    /// move validation
    private func validateMove(_ move: Move) throws {
        let myKing = getGeneral(of: move.piece.side)

        // simulate the move
        var otherSidePieces = Set(pieces.filter({ $0.side != move.piece.side }))

        if let captured = move.captured {
            otherSidePieces.remove(captured)
        }

        let originalPosition = move.perform()
        defer { move.piece.position = originalPosition }

        // check if move is valid
        if otherSidePieces.contains(where: { $0.canCheck(myKing) }) {
            throw MoveError.loseKing
        }
    }

    private func updateGameStatusAfterMove() {

        // Update turn
        currentPlayer.toggle()

        // Check if the current player's king is in check or checkmate
        let myKing = getGeneral(of: currentPlayer)

        let opponentPieces = pieces.filter { $0.side != currentPlayer }
        let isInCheck = opponentPieces.contains { $0.canCheck(myKing) }

        if isInCheck {
            do {
                // Validate state: Validate all possible moves. If none (no error thrown) then end game.
                try pieces.filter { $0.side == currentPlayer }.forEach { samePiece in
                    try samePiece.availableMoves.forEach { move in
                        try self.validateMove(move)
                    }
                }

                endGame(loser: currentPlayer)
            } catch {}
        }
    }
}

