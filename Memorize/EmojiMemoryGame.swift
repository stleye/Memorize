//
//  EmojiMemoryView.swift
//  SwiftUILecture4
//
//  Created by Sebastian Tleye on 05/12/2022.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["⛸", "🧗‍♀️", "🎗", "🚆", "🚌", "📺", "🎀", "✳️", "🔫", "🥊", "🔪", "🥳", "🥶", "🧠"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 3) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGame()
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

}
