//
//  EmojiMemoryView.swift
//  SwiftUILecture3
//
//  Created by Sebastian Tleye on 05/12/2022.
//

import Foundation

class EmojiMemoryGame {
    
    static let emojis = ["⛸", "🧗‍♀️", "🎗", "🚆", "🚌", "📺", "🎀", "✳️", "🔫", "🥊", "🔪", "🥳", "🥶", "🧠"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }

    private(set) var model = createMemoryGame()

}
