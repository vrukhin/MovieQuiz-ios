//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 17.04.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: () -> Void
}
