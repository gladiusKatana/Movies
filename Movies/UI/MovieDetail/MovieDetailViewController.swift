import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    let viewModel = MovieDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(withTitle: viewModel.movie.title)
        setupMovieDetailUI()
        viewModel.bind(to: self)
        viewModel.serviceFetchGenresAndReviews()
    }
    
    private func setupMovieDetailUI() {
        let backdropImageURL = URL(string: Constants.imageBaseURL + viewModel.movie.backdropPath)
        backdropImageView.kf.setImage(with: backdropImageURL)
        titleLabel.text = viewModel.movie.title
        ratingView.settings.fillMode = .precise
        ratingView.rating = viewModel.movie.voteAverage / 2
        releaseDateLabel.text = viewModel.movie.releaseDate
        overviewLabel.text = viewModel.movie.overview != "" ? viewModel.movie.overview : "\nNo summary (yet)\n"
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didFetchGenres(_ genresString: String) {
        genresLabel.text = genresString
    }
    func didFetchReviews(_ reviewsString: String) {         //print("fetched reviews: \n\(reviewsString)")
        reviewsLabel.text = "Reviews\n\(reviewsString != "" ? reviewsString : "\nNo reviews yet. Maybe you should write one!")"
    }
}

