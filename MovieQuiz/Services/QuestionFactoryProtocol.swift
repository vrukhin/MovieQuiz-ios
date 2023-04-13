//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 14.04.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
