import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameResult) -> Bool {
        if correct == another.correct {
            return total < another.total
        }
        return correct > another.correct
    }
}