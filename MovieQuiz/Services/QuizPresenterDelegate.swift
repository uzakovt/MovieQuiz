import Foundation

protocol QuizPresenterDelegate: AnyObject{
    func controlBorder(reset: Bool, isCorrect: Bool)
    func showAnswerResult(isCorrect: Bool, nextStep: @escaping () -> Void)
    func showQuizStep(quiz step: QuizStepViewModel)
    func isLoading(_ isOn: Bool)
}
