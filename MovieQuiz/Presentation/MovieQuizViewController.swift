import UIKit

final class MovieQuizViewController: UIViewController {
    private var alertPresenter: AlertPresenterProtocol?
    private var quizLogic: QuizLogicProtocol?

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initDelegates()
        quizLogic?.requestFirstQuestion()
    }

    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        let userAnswer = sender.tag != 0
        quizLogic?.showAnswerResult(userAnswer: userAnswer)
        noButton.isHidden = true
        yesButton.isHidden = true
    }

    private func initDelegates() {
        //AlertpresenterDelegate initialization
        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

        //QuizLogicDelegate initialization
        quizLogic = QuizLogic(delegate: self)
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuizLogicDelegate
extension MovieQuizViewController: QuizLogicDelegate {
    func showQuizStep(quiz step: QuizStepViewModel) {
        DispatchQueue.main.async {
            self.imageView.image = step.image
            self.counterLabel.text = step.questionNumber
            self.textLabel.text = step.question
        }
    }

    func showAnswerResult(isCorrect: Bool, nextStep: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            nextStep()
            self.noButton.isHidden = false
            self.yesButton.isHidden = false
        }
    }

    func controlBorder(reset: Bool, isCorrect: Bool = false) {
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
}
