import Foundation


struct GenresResponseObject: Decodable {
    let genres: [Genre]
}

struct ReviewsResponseObject: Decodable {
    let results: [Review]
}

protocol MovieDetailServiceProtocol {
    func fetchGenres(for movieId: Int, completion: @escaping (Result<GenresResponseObject>) -> Void)
    func fetchReviews(for movieId: Int, completion: @escaping (Result<ReviewsResponseObject>) -> Void)
}

class MovieDetailService: APIClient {
    var session: URLSession
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
}

extension MovieDetailService: MovieDetailServiceProtocol {
    func fetchGenres(for movieId: Int, completion: @escaping (Result<GenresResponseObject>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "movie/\(movieId)") else {
            completion(.failure)
            return
        }
        let request = URLRequest(url: url)
        fetch(with: request, decode: { $0 as? GenresResponseObject ?? nil }, completion: completion)
    }
    func fetchReviews(for movieId: Int, completion: @escaping (Result<ReviewsResponseObject>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "movie/\(movieId)/reviews") else { //  /reviews
            completion(.failure)
            return
        }
        let request = URLRequest(url: url)
        fetch(with: request, decode: { $0 as? ReviewsResponseObject ?? nil }, completion: completion)
    }
}

