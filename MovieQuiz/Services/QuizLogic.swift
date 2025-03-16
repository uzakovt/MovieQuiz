import Foundation
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
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory

        let alertPresenter = ResultAlertPresenter()
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
                [weak self] in
                guard let self else { return }
                self.questionNumber = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.showAlert(alertData: quizResult)
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

    private func convert(model: QuizQuestion) -> QuizStepViewModel? {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber:
                "\(questionNumber + 1)/\(questionsAmount)")
    }

    func requestFirstQuestion() {
        questionFactory?.requestNextQuestion()
    }

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        if let viewModel {
            delegate?.showQuizStep(quiz: viewModel)
        }
    }
}
