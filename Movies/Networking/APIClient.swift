import Foundation

protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T>) -> Void)
}

extension APIClient {
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T>) -> Void) {
        
        let task = decodingTask(with: request, decodingType: T.self) { json in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(.failure)
                    return
                }
                
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure)
                }
            }
        }
        task.resume()
    }
}

