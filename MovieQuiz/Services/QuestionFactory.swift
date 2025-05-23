import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []

    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }

    func loadData() {
        print("loading")
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let loadedMovies):
                    self.movies = loadedMovies.movies
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global().async {
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.imageUrl)
            } catch {
                print("Cant load Image")
            }

            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            let question = QuizQuestion(
                image: imageData, text: text, correctAnswer: correctAnswer)

            DispatchQueue.main.async {
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}

//private let questions: [QuizQuestion] = [
//    QuizQuestion(
//        image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Dark Knight",
//        text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//    QuizQuestion(
//        image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Green Knight",
//        text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//    QuizQuestion(
//        image: "Old", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//    QuizQuestion(
//        image: "The Ice Age Adventures of Buck Wild",
//        text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//    QuizQuestion(
//        image: "Tesla", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//    QuizQuestion(
//        image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//]
