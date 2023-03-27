import UIKit


extension UIViewController {
    
    
    func setupNavigationBar(withTitle title: String) {
        self.title = title
        
        print("\nsetting up navigation bar with title \(title)\n")
        
        navigationItem.largeTitleDisplayMode = .never // .always
    }
    
}

