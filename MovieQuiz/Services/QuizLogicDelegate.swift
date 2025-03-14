import Foundation

protocol QuizLogicDelegate: AnyObject{
    func controlBorder(reset: Bool, isCorrect: Bool)
    func showAnswerResult(isCorrect: Bool, nextStep: @escaping () -> Void)
}
