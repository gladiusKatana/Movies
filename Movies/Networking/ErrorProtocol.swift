import UIKit


protocol ErrorReceivableDelegate: AnyObject {
    func didReceiveError(_ errorMessage: String)
}

extension ErrorReceivableDelegate where Self: UIViewController & ActivityIndicatorContainer {
    func didReceiveError(_ errorMessage: String) {
        activityIndicator.stopAnimating()
        handleError(errorMessage)
    }
}

extension ErrorReceivableDelegate where Self: UIViewController {
    func didReceiveError(_ errorMessage: String) {
        handleError(errorMessage)
    }
}

extension UIViewController {
    func handleError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

