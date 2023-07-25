//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Sebastian Tleye on 25/07/2023.
//

import SwiftUI

@main
struct MemorizeApp: App {

    private let game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
