import UIKit

protocol MovieListDataSourceDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

class MovieListDataSource: NSObject {
    var movies: [Movie] = []
    private weak var delegate: MovieListDataSourceDelegate?
    
    init(delegate: MovieListDataSourceDelegate) {
        self.delegate = delegate
    }
}

extension MovieListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell") as? MovieListCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.render(with: movie)
        return cell
    }
}

extension MovieListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        delegate?.didSelectMovie(movie)
    }
}

extension MovieListViewController: MovieListDataSourceDelegate {
    func didSelectMovie(_ movie: Movie) {
        
        if mcSession.connectedPeers.count > 0 {
            let data = Data(movie.title.utf8)
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        vc.viewModel.movie = movie                                          ; print("\n\(movie.title)\n")
        navigationController?.pushViewController(vc, animated: true)
    }
}
