import UIKit


extension UIViewController {
    
    
    func setupNavigationBar(withTitle title: String) {
        self.title = title
        
        print("setting up navigation bar with title \(title)")
        
        navigationItem.largeTitleDisplayMode = .never // .always
    }
    
}

