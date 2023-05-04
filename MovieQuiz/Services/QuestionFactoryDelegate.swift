//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 16.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
