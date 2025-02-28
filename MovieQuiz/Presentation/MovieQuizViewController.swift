import UIKit

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = MockData.mockQuestions
    private var questionNumber: Int = 0
    private var correctAnswers: Int = 0

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        showQuizStep(quiz: convert(model: questions[0]))
    }

    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        let userAnswer: Bool = sender.tag != 0
        let isCorrect: Bool =
            questions[questionNumber].correctAnswer == userAnswer
        showAnswerResult(isCorrect: isCorrect)
    }

    private func showNextQuestionOrResults() {
        if questionNumber == questions.count - 1 {
            let quizResult = QuizResultsViewModel(
                title: "Раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                buttonText: "Сыграть еще раз")
            showQuizResult(quiz: quizResult)
        } else {
            questionNumber += 1
            let nextQuestion: QuizStepViewModel = convert(
                model: questions[questionNumber])
            showQuizStep(quiz: nextQuestion)
        }
        controlBorder(reset: true)
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        controlBorder(reset: false, isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func controlBorder(reset: Bool, isCorrect: Bool = false) {
        if reset {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 0
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor =
                isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            imageView.layer.cornerRadius = 20
        }
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(questionNumber + 1)/\(questions.count)")
    }

    private func showQuizResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {
            _ in
            self.questionNumber = 0
            self.correctAnswers = 0
            let firstQuestion = self.convert(
                model: self.questions[self.questionNumber])
            self.showQuizStep(quiz: firstQuestion)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showQuizStep(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
}

private struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

private struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

private struct MockData {
    static let mockQuestions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(
            image: "Old", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(
            image: "Tesla", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
    ]
}
