//
//  BoardView.swift
//  xingqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

struct BoardView: View {

    @EnvironmentObject var gameManager: GameManager
    @State var selectedPiece: GamePiece? { didSet {
        moves = selectedPiece?.availableMoves
    }}
    @State var moves: [Move]?
    @State private var message: String?

    var body: some View { GeometryReader { proxy in

        // Use the minimum of available width/height to keep board square-ish
        let available = min(proxy.size.width, proxy.size.height)
        let width = available * 8/9
        let spacing = width / 8 // horizontal

        // vertical
        let fullHeight = spacing * 9
        let halfHeigth = spacing * 4

        ZStack {
            Color(red: 240/255, green: 208/255, blue: 160/255) // board's background color

            LinesView(width: width, height: fullHeight, halfHeight: halfHeigth, spacing: spacing)

            // Add the game pieces
            ForEach(gameManager.pieces, id: \.self) { piece in
                GamePieceView(piece: piece, selected: piece == selectedPiece)
                    .position(x: CGFloat(piece.position.x) * spacing, y: CGFloat(piece.position.y) * spacing)
                    .animation(.easeInOut, value: piece.position)
                    .onTapGesture {
                        guard case .isPlaying(let currentSide) = gameManager.state else { return }

                        if selectedPiece == piece { selectedPiece = nil } // Deselect
                        else if piece.side == currentSide { // Change selection
                            selectedPiece = piece
                        } else if let sp = selectedPiece, let move = Move(sp, to: piece.position), moves?.contains(where: { $0 == move }) == true { // Capture
                            do {
                                try gameManager.performMove(move)
                                selectedPiece = nil
                            } catch {
                                // Display toast error
                                toastMessage(error.localizedDescription)
                            }
                        }
                    }
                    .animation(.easeIn(duration: 0.1), value: selectedPiece)
            }

            // Add available moves
            if let moves {
                ForEach(moves, id: \.to) { move in
                    MoveView(move: move, spacing: spacing)
                        .onTapGesture {
                            performMove(move)
                        }
                }
            }

            if let message {
                ToastView(message: message)
                    .position(x: width / 2, y: fullHeight / 2)
                    .zIndex(1)
            }
        }
        .frame(width:  width, height: fullHeight)
        // Center the board within the available space
        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
    }}

    private func performMove(_ move: Move) {
        // Perform the piece movement here
        do {
            try gameManager.performMove(move)
            selectedPiece = nil
        } catch {
            // Display toast error
            print(error)
            toastMessage(error.localizedDescription)
        }
    }

    private func toastMessage(_ message: String) {
        withAnimation {
            self.message = message
        }

        print(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.message = nil
            }
        }
    }
}

#Preview {
    let gm = GameManager()
    gm.start()
    return BoardView().environmentObject(gm)
}
