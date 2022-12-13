import Foundation

extension APIClient {
    
    func decodingTask<T: Decodable>(with request: URLRequest,
                                    decodingType: T.Type,
                                    completionHandler completion: @escaping (Decodable?) -> Void) -> URLSessionDataTask {
        var mutableRequest = request    //; print("\n\n\nREQUEST URL: \n\(request.url)") // without API key
        
        addApiKey(to: &mutableRequest)
        
        let task = session.dataTask(with: mutableRequest) { data, response, _ in
            //print("\n\n\nREQUEST URL: \n\(request.url)")  // with(out) API key ... watch out in general (though it won't show it from here)
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            } //; print("API Response Status Code: \(httpResponse.statusCode)")
            
            if (httpResponse.statusCode == 200) {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion(genericModel)
                    } catch {
                        print("error decoding json ... \(error)")
                        completion(nil)
                    }
                } else {completion(nil)}
            } else {completion(nil)}
        }
        
        return task
    }
}

