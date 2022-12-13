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
    
    func addApiKey(to request: inout URLRequest) {
        guard let url = request.url,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        let accessKeyQueryItem = URLQueryItem(name: "api_key", value: Constants.apiKey)
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + [accessKeyQueryItem]
        request.url = urlComponents.url
        
        //; print("\n\n\nREQUEST URL: \n\(request.url)")  // with API key ... watch out
    }
}

