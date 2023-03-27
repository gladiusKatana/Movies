import UIKit; import MultipeerConnectivity

class MovieListViewController: UIViewController, ActivityIndicatorContainer, MCSessionDelegate, MCBrowserViewControllerDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private lazy var dataSource = MovieListDataSource(delegate: self)
    private let viewModel = MovieListViewModel()
    
    var peerID: MCPeerID! /// The peer ID is simply the name of the current device, which is useful for identifying who is joining a session.
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activityIndicator.startAnimating()
        setupNavigationBar(withTitle: Constants.uiTitleString)
        setupTableView()
        viewModel.bind(to: self)
        viewModel.serviceFetchMovies()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
        
//        let hostAction = UIAlertAction(title: "hosting session", style: .default)
//        startHosting(action: hostAction) // stopHosting(action: action)
        
        let joinAction = UIAlertAction(title: "joining session", style: .default)
        joinSession(action: joinAction)
    }
    
    private func setupTableView() {
        tableView.rowHeight = 200
        tableView.register(UINib(nibName: "MovieListCell", bundle: nil),
                           forCellReuseIdentifier: "MovieListCell") /// use a protocol rather than hardcoding
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    func startHosting(action: UIAlertAction!) { print("starting hosting")
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)    // _hws-kb._tcp
        mcAdvertiserAssistant.start()
    }

    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("\nConnected: \(peerID.displayName)\n")

        case MCSessionState.connecting:
            print("\nConnecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("\nNot Connected: \(peerID.displayName)")
        @unknown default:
            //fatalError()
            print("\nUNKNOWN ERROR: \(peerID.displayName)")
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = String(decoding: data, as: UTF8.self)
        let message = "\nSomeone close to you suggested this movie:\n\n---------------------\n\(str)\n---------------------\n"
        print(message)
        
        let alert = UIAlertController(title: "Movie Suggestion!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            switch action.style {
            case .default: print("\n\nalert-tapped-OK--default\n\n")
            case .cancel: print("\n\nalert-tapped-OK--cancel\n\n")
            case .destructive: print("\n\nalert-tapped-OK--destructive")
            @unknown default:
                fatalError()
            }
        }))
        DispatchQueue.main.async { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        dismiss(animated: true)
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

