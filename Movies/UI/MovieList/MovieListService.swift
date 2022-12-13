import Foundation


struct MoviesResponseObject: Decodable {
    let results: [Movie]
}

protocol MovieListServiceProtocol {
    func fetchMovies(withMovieTypeString: String, completion: @escaping (Result<MoviesResponseObject>) -> Void)
}


class MovieListService: APIClient {
    var session: URLSession
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
}

extension MovieListService: MovieListServiceProtocol {
    func fetchMovies(withMovieTypeString str: String, completion: @escaping (Result<MoviesResponseObject>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "movie/\(str)") else {
            completion(.failure)
            return
        }
        let request = URLRequest(url: url)  //; print("\nfetching movies from url:\n\(url)")
        fetch(with: request, decode: { $0 as? MoviesResponseObject ?? nil }, completion: completion)
    }
}

