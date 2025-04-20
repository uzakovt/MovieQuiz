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
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let loadedMovies):
                    if loadedMovies.error != ""{
                        self.delegate?.didFailToLoadData(with: loadedMovies.error){
                            self.loadData()
                        }
                        return
                    }
                    self.movies = loadedMovies.movies
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error.localizedDescription){
                        self.loadData()
                    }
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.delegate?.isLoading(true)
            }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.imageUrl)
            } catch {
                self.delegate?.didFailToLoadData(with: error.localizedDescription){
                    self.requestNextQuestion()
                }
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


