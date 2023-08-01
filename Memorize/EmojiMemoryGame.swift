//
//  EmojiMemoryView.swift
//  SwiftUILecture5
//
//  Created by Sebastian Tleye on 05/12/2022.
//

import Foundation

class EmojiMemoryGame: ObservableObject {

    typealias Card = MemoryGame<String>.Card

    private static let emojis = ["😀", "😄", "😊", "😎", "🤔", "🤗", "😍", "😂", "🥰", "😇", "🥳", "😋", "🥺", "🤩", "😏", "😢", "😱", "🥴", "😷", "🤯", "🤭", "😴", "🥱", "🤓"]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: 6) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGame()

    var cards: [Card] {
        model.cards
    }
    
    // MARK: - Intent(s)

    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }

}
