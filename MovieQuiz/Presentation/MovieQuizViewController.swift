import UIKit

final class MovieQuizViewController: UIViewController{
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
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
    }
    

    @IBAction private func answerButtonPressed(_ sender: UIButton) {
        guard let currentQuestion else { return }
        let userAnswer: Bool = sender.tag != 0
        let isCorrect: Bool = currentQuestion.correctAnswer == userAnswer
        quizLogic?.showAnswerResult(isCorrect: isCorrect)
        noButton.isHidden = true
        yesButton.isHidden = true
    }
    
    private func initDelegates(){
        //QuestionFactoryDelegate initialization
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        //AlertpresenterDelegate initialization
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        //QuizLogicDelegate initialization
        let quizLogic = QuizLogic()
        quizLogic.delegate = self
        quizLogic.intialize()
        self.quizLogic = quizLogic
        
        questionFactory.requestNextQuestion()
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel? {
        guard let quizLogic else { return nil }
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(quizLogic.questionNumber + 1)/\(quizLogic.questionsAmount)")
    }

    private func showQuizStep(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate{
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate{
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        if let viewModel {
            DispatchQueue.main.async{ [weak self] in
                self?.showQuizStep(quiz: viewModel)
            }}
        
    }}

// MARK: - QuizLogicDelegate
extension MovieQuizViewController: QuizLogicDelegate{
    func showAnswerResult(isCorrect: Bool, nextStep: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            guard let self else { return }
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
