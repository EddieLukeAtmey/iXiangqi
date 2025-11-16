//
//  iXiangqiApp.swift
//  iXiangqi
//
//  Created by Eddie on 17/07/2023.
//

import SwiftUI

@main
struct iXiangqiApp: App {

    var body: some Scene {
#if os(iOS)
        WindowGroup {
            //            MainMenuView()
            GameView(gameManager: GameManager()).environmentObject(GameManager())
        }
#elseif os(macOS)
        WindowGroup {
            MainMenuView()
        }
#endif
    }
}
