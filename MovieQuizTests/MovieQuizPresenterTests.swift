//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Павел Врухин on 19.05.2023.
//

import XCTest
@testable import MovieQuiz


final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showResult(result: UIAlertController) {
        
    }
    
    func showImageBorder(isCorrect: Bool) {
        
    }
    
    func hideImageBorder() {
        
    }
    
    func disableButtons() {
        
    }
    
    func enableButtons() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
