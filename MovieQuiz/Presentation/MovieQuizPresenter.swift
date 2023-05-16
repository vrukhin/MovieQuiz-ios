//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 15.05.2023.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            //TODO: вынести инициализацию statisticService в presenter из ViewController
            viewController?.statisticService!.store(correct: correctAnswers, total: self.questionsAmount)
            let totalAccuracy = String(format: "%.2f", (viewController?.statisticService!.totalAccuracy)!)
            let alertPresenter = AlertPresenter(delegate: viewController!)
            //TODO: вынести message для alertModel в отдельное свойство
            let alertModel = AlertModel(title: "Этот раунд окончен",
                                        message: "Ваш результат \(correctAnswers)/\(self.questionsAmount)\nКоличество сыгранных квизов: \(viewController?.statisticService!.gamesCount)\nРекорд: \(viewController?.statisticService!.bestGame.correct)/\(viewController?.statisticService!.bestGame.total) (\(viewController?.statisticService!.bestGame.date.dateTimeString))\nСредняя точность: \(totalAccuracy)%",
                                        buttonText: "Сыграть еще раз?",
                                        id: "GameResults",
                                        completion: {
                self.restartGame()
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
            )
            alertPresenter.show(alertModel: alertModel)
        } else {
            self.switchToNextQuestion()

            self.questionFactory?.requestNextQuestion()
        }
    }
}
