import Foundation

final class QuizLogic: QuizLogicProtocol {
    var questionNumber: Int = 0
    var correctAnswers: Int = 0
    var questionsAmount: Int = 10

    weak var delegate: QuizLogicDelegate?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticService()

    init(delegate: QuizLogicDelegate){
        self.delegate = delegate
        let questionFactory = QuestionFactory()
        questionFactory.delegate = delegate.self as? QuestionFactoryDelegate
        self.questionFactory = questionFactory

        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = delegate.self as? AlertPresenterDelegate
        self.alertPresenter = alertPresenter
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
                self.questionNumber = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })

        alertPresenter?.showAlert(alertData: quizResult)
    }

    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        delegate?.controlBorder(reset: false, isCorrect: isCorrect)
        delegate?.showAnswerResult(
            isCorrect: isCorrect, nextStep: showNextQuestionOrResults)
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
        delegate?.controlBorder(reset: true, isCorrect: false)  // optimise
    }
}
