import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date =
                storage.object(forKey: Keys.bestGameDate.rawValue) as? Date
                ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    var totalAccuracy: Double {
        let count = gamesCount != 0 ? gamesCount : 1
        return Double(correctAnswers) / (Double(count) * 10) * 100
    }

    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }

    func store(gameResult: GameResult) {
        correctAnswers += gameResult.correct
        gamesCount += 1

        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}

private enum Keys: String {
    case correct
    case gamesCount
    case bestGame
    case bestGameTotal
    case bestGameCorrect
    case bestGameDate
    case correctAnswers
}
