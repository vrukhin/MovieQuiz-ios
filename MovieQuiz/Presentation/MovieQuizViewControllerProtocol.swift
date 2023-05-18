//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 19.05.2023.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func show(quiz step: QuizStepViewModel)
    func showResult(result: UIAlertController)
    
    func showImageBorder(isCorrect: Bool)
    func hideImageBorder()
    
    func disableButtons()
    func enableButtons()
}
