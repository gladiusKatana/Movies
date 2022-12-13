


protocol MovieListViewModelDelegate: ErrorReceivableDelegate {
    func didFetchMovies(_ movies: [Movie])
}


class MovieListViewModel {
    private weak var delegate: MovieListViewModelDelegate?
    private let service: MovieListServiceProtocol
    
    init(service: MovieListServiceProtocol = MovieListService()) {
        self.service = service
    }
    
    func bind(to delegate: MovieListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func serviceFetchMovies() {
        service.fetchMovies() { [weak self] (result) in
            switch result {
            case .success(let movieList):
                let movies = movieList.results
                self?.delegate?.didFetchMovies(movies)
            case .failure:
                self?.delegate?.didReceiveError("Failed to get movies")
            }
        }
    }
}

