//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 15.05.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresenterDelegate {
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }
    
    private var resultMessage: String {
        let result = "Ваш результат \(correctAnswers)/\(questionsAmount)\n"
        let games = "Количество сыгранных квизов: \(statisticService!.gamesCount)\n"
        let record = "Рекорд: \(statisticService!.bestGame.correct)/\(statisticService!.bestGame.total) "
        let recordDate = "(\(statisticService!.bestGame.date.dateTimeString))\n"
        let totalAccuracy = String(format: "%.2f", statisticService!.totalAccuracy)
        let accuracy = "Средняя точность: \(totalAccuracy)%"
        let message = result + games + record + recordDate + accuracy
        return message
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let alertPresenter = AlertPresenter(delegate: self)
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               id: "NetworkErrorAlert") { [weak self] in
            guard let self = self else { return }
            
            self.restartGame()
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(alertModel: model)
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        viewController?.showImageBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            showNextQuestionOrResult()
            viewController?.hideImageBorder()
            viewController?.enableButtons()
        }
    }
    
    private func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            statisticService!.store(correct: correctAnswers, total: self.questionsAmount)
            let alertPresenter = AlertPresenter(delegate: self)
            let alertModel = AlertModel(title: "Этот раунд окончен",
                                        message: resultMessage,
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
    
    func initGame() {
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        viewController?.present(alert, animated: true)
    }
}
