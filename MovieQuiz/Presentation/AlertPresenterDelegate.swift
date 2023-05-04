//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 18.04.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didReceiveAlert(alert: UIAlertController?)
}
