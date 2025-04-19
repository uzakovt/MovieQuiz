import Foundation

protocol QuizLogicProtocol{
    var questionNumber: Int { get }
    var correctAnswers: Int { get }
    var questionsAmount: Int { get }
    
    func showAnswerResult(userAnswer: Bool)
    func loadData()
    func convert(model: QuizQuestion) -> QuizStepViewModel?
}
