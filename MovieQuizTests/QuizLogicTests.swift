import XCTest

@testable import MovieQuiz

final class QuizLogicTests: XCTestCase {

    func testConvertModel() throws {
        let viewControllerMock: QuizLogicDelegate =
            MovieQuizViewControllerMock()
        let quizLogic: QuizLogicProtocol = QuizLogic(
            delegate: viewControllerMock)

        let mockData = UIImage(named: "The Green Knight")?.pngData()
        guard let mockData else { throw UnwrappingError.unwrappingFailure }
        let question = QuizQuestion(image: mockData, text: "Question Text", correctAnswer: true)
        let viewModel = quizLogic.convert(model: question)
        guard let viewModel else { throw UnwrappingError.unwrappingFailure }

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

final class MovieQuizViewControllerMock: QuizLogicDelegate {
    func controlBorder(reset: Bool, isCorrect: Bool) {}
    func showAnswerResult(isCorrect: Bool, nextStep: @escaping () -> Void) {}
    func showQuizStep(quiz step: MovieQuiz.QuizStepViewModel) {}
    func isLoading(_ isOn: Bool) {}
}

enum UnwrappingError: Error {
    case unwrappingFailure
}
