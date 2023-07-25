//
//  MemoryGame.swift
//  SwiftUILecture3
//
//  Created by Sebastian Tleye on 05/12/2022.
//

import Foundation

struct MemoryGame<CardContent> {
    
    private var cards: [Card]
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }

    func choose(_ card: Card) {
        
    }

    struct Card {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
    }
    
}
