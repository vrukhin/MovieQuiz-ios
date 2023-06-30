//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 14.04.2023.
//

import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
    init(imageData: Data, question: String, questionNumber: String) {
        self.image = UIImage(data: imageData) ?? UIImage()
        self.question = question
        self.questionNumber = questionNumber
    }
}
