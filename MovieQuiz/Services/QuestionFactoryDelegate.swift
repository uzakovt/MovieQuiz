import Foundation

protocol QuestionFactoryDelegate: AnyObject{
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: String, handler: @escaping () -> Void)
    func isLoading(_ isLoading: Bool)
}
