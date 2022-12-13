


protocol MovieDetailViewModelDelegate: ErrorReceivableDelegate {
    func didFetchGenres(_ genresString: String)
    func didFetchReviews(_ reviewsString: String)
}

class MovieDetailViewModel {
    
    private let service: MovieDetailServiceProtocol
    private weak var delegate: MovieDetailViewModelDelegate?
    
    var movie: Movie!
    
    init(service: MovieDetailServiceProtocol = MovieDetailService()) {
        self.service = service
    }
    
    func bind(to delegate: MovieDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    func serviceFetchGenresAndReviews() {
        service.fetchGenres(for: movie.id) { [weak self] (result) in
            switch result {
            case .success(let genresResponseObject):
                let genresString = genresResponseObject.genres.map { $0.name }.joined(separator: ", ")
                self?.delegate?.didFetchGenres(genresString)
            case .failure:
                self?.delegate?.didReceiveError("Failed to get genres")
            }
        }
        
        service.fetchReviews(for: movie.id) { [weak self] (result) in
            switch result {
            case .success(let reviewsResponseObject):
                let reviewString = reviewsResponseObject.results.map {
                    "\n🎬\nReview by \($0.author)\n(last updated: \($0.updatedAt))\n\n\($0.content)"
                }.joined(separator: ",\n")
                self?.delegate?.didFetchReviews(reviewString)
            case .failure:
                self?.delegate?.didReceiveError("Failed to get reviews")
            }
        }
    }
}

