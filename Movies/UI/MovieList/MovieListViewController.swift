import UIKit

class MovieListViewController: UIViewController, ActivityIndicatorContainer {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private lazy var dataSource = MovieListDataSource(delegate: self)
    private let viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activityIndicator.startAnimating()
        setupNavigationBar(withTitle: Constants.uiTitleString)
        setupTableView()
        viewModel.bind(to: self)
        viewModel.serviceFetchMovies()
    }
    
    private func setupTableView() {
        tableView.rowHeight = 200
        tableView.register(UINib(nibName: "MovieListCell", bundle: nil),
                           forCellReuseIdentifier: "MovieListCell") /// use a protocol rather than hardcoding
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func didFetchMovies(_ movies: [Movie]) {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        dataSource.movies = movies
        tableView.reloadData()
    }
}

