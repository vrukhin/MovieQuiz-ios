//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Павел Врухин on 24.04.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int) {
        if count > self.bestGame.correct {
            self.bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        self.gamesCount += 1
        self.totalAccuracy = (self.totalAccuracy + Double(count)/Double(amount) * 100) / Double(self.gamesCount)
    }
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let total = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            
            return total
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let games = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return games
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
/*
    init(totalAccuracy: Double, gamesCount: Int) {
        self.totalAccuracy = totalAccuracy
        self.gamesCount = gamesCount
    }
*/
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compare(with newResult: GameRecord) -> Bool {
        return self.correct < newResult.correct
    }
}
