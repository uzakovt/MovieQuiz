import UIKit

final class MovieQuizViewController: UIViewController {
    private var quizLogic: QuizLogicProtocol?

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizLogic = QuizLogic(delegate: self)
        
        isLoading(true)
        quizLogic?.loadData()
    }

    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        let userAnswer = sender.tag != 0
        quizLogic?.showAnswerResult(userAnswer: userAnswer)
        noButton.isEnabled = false
        yesButton.isEnabled = false
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            nextStep()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
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
    
    func isLoading(_ isOn: Bool){
        if isOn{
            imageView.isHidden = true
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            imageView.isHidden = false
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
}
