import Foundation

struct GameResult{
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterTham(_ another: GameResult) -> Bool{
        return correct > another.correct
    }
}
