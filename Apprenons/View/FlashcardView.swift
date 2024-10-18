//
//  Flashcard.swift
//  Apprenons
//
//  Created by Alexander Black on 10/17/24.
//

import SwiftUI


struct Constants {
    static var cornerRadius: CGFloat = 10
}

struct FlashcardView: View {
    let flashcard: Flashcard
    var topic: Topic
    let viewModel: ApprenonsViewModel
    
    var body: some View {
        ZStack {
            if flashcard.isFaceUp {
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke()
                Text(flashcard.front)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke()
                Text(flashcard.back)
                    .font(.largeTitle)
            }
       
        }
        .foregroundStyle(.blue)
        .onTapGesture {
            viewModel.flip(flashcard, in: topic)
        }
    }
}
