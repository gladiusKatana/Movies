import UIKit

class MovieListViewController: UIViewController, ActivityIndicatorContainer {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private let viewModel = MovieListViewModel()
    lazy var dataSource = MovieListDataSource(delegate: self)
    var arbitraryExtraParameterToMakeConvenienceInitWork = ""   /// * why needed? ... also ... try uncommenting the below required init?(coder: ) , and see what happens!
    
    convenience init?(coder: NSCoder, para: String = "") {
        self.init(coder: coder)
        self.arbitraryExtraParameterToMakeConvenienceInitWork = para
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(withTitle: Constants.uiTitleString)
        setupMovieListUI()
        viewModel.bind(to: self)
        updateMoviesListUIAndFetch(withMovieTypeString: Constants.apiString)
    }
    
    func updateMoviesListUIAndFetch(withMovieTypeString movieTypeString: String) {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        viewModel.serviceFetchMovies(withMovieTypeString: movieTypeString)
    }
    
    func setupMovieListUI() {
        tableView.rowHeight = 200
        tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell") /// use a protocol rather than hardcoding
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func didFetchMovies(_ movies: [Movie]) {
        activityIndicator.stopAnimating()
        dataSource.movies = movies
        tableView.isHidden = false
        tableView.reloadData()
    }
}

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
