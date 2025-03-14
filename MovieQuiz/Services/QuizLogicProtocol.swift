import Foundation

protocol QuizLogicProtocol{
    var questionNumber: Int { get }
    var correctAnswers: Int { get }
    var questionsAmount: Int { get }
    
    func showAnswerResult(isCorrect: Bool)
}
