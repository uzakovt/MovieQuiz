import Foundation

struct MostPopularMovies: Codable {
    let error: String
    let movies: [MostPopularMovie]
    
    enum CodingKeys: String, CodingKey {
        case error = "errorMessage"
        case movies = "items"
    }
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageUrl = "image"
    }
}
```