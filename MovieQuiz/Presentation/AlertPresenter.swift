//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 17.04.2023.
//

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                              message: alertModel.message,
                                              preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }

        alert.addAction(action)
        delegate?.didReceiveAlert(alert: alert)
    }
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
}
