//
//  EmojiMemoryView.swift
//  SwiftUILecture5
//
//  Created by Sebastian Tleye on 05/12/2022.
//

import Foundation

class EmojiMemoryGame: ObservableObject {

    typealias Card = MemoryGame<String>.Card

    private static let emojis = ["⛸", "🧗‍♀️", "🎗", "🚆", "🚌", "📺", "🎀", "✳️", "🔫", "🥊", "🔪", "🥳", "🥶", "🧠"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 10) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGame()

    func choose(_ card: Card) {
        model.choose(card)
    }

    var cards: [Card] {
        model.cards
    }

}
