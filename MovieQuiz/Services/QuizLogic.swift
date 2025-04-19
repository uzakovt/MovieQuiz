import UIKit

final class QuizLogic: QuizLogicProtocol, QuestionFactoryDelegate {
    var questionNumber: Int = 0
    var correctAnswers: Int = 0
    var questionsAmount: Int = 10

    weak var delegate: QuizLogicDelegate?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol =
        StatisticServiceImplementation()

    init(delegate: QuizLogicDelegate) {
        self.delegate = delegate
        questionFactory = QuestionFactory(
            delegate: self, moviesLoader: MoviesLoader())
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = delegate.self as? AlertPresenterDelegate
        self.alertPresenter = alertPresenter
    }

    private func showNextQuestionOrResults() {
        if questionNumber == questionsAmount - 1 {
            statisticService.store(
                gameResult: GameResult(
                    correct: correctAnswers, total: questionsAmount,
                    date: Date()))
            showQuizResult()
        } else {
            questionNumber += 1
            questionFactory?.requestNextQuestion()
        }
        delegate?.controlBorder(reset: true, isCorrect: false)
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel? {
        var resultQuestionViewModel: QuizStepViewModel?
        do {
            let imageFromData = try UIImage.loadFromData(data: model.image)
            resultQuestionViewModel = QuizStepViewModel(
                image: imageFromData,
                question: model.text,
                questionNumber:
                    "\(questionNumber + 1)/\(questionsAmount)")
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showNetworkError(message: "Cannot load Image") {
                    resultQuestionViewModel = self.convert(model: model)
                }
            }
        }
        return resultQuestionViewModel
    }

    func showAnswerResult(userAnswer: Bool) {
        guard let currentQuestion else { return }

        let isCorrect = currentQuestion.correctAnswer == userAnswer
        if isCorrect {
            correctAnswers += 1
        }
        delegate?.controlBorder(reset: false, isCorrect: isCorrect)
        delegate?.showAnswerResult(
            isCorrect: isCorrect, nextStep: showNextQuestionOrResults)
    }
    
    func isLoading(_ isLoading: Bool) {
        delegate?.isLoading(isLoading)
    }
    
    // MARK: - AlertPeresenterDElegate
    private func showNetworkError(message: String, buttonAction: @escaping () -> Void) {
        let model = AlertModel(
            title: "Ошибка",
            text: message,
            buttonText: "Попробовать еще раз", completion: buttonAction
        )
        alertPresenter?.showAlert(alertData: model, id: "networkErrorAlert")
    }

    func showQuizResult() {
        let quizResult = AlertModel(
            title: "Раунд окончен!",
            text: """
                Ваш результат: \(correctAnswers)/\(questionsAmount)\n
                Количество сыграных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                """,
            buttonText: "Сыграть еще раз",
            completion: {
                [weak self] in
                guard let self else { return }
                self.questionNumber = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.showAlert(alertData: quizResult, id: "resultAlert")
    }

    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        delegate?.isLoading(true)
        currentQuestion = question
        let viewModel = convert(model: question)
        if let viewModel {
            delegate?.showQuizStep(quiz: viewModel)
        }
    }

    func didLoadDataFromServer() {
        delegate?.isLoading(false)
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: String, handler: @escaping () -> Void) {
        showNetworkError(message: error, buttonAction: handler)
    }
    
    func loadData() {
        questionFactory?.loadData()
    }
}
