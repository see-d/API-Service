import Foundation

public struct API_Service {
    public init() {}
    
    public static func make<T:Decodable>(request: any API, completion:@escaping(T?,Error?) -> Void) {
        do {
            let urlRequest = try request.urlRequest()
            let task = URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in

                if let error{
                    completion(nil, error)
                    return
                }
                
                guard let data else {
                    completion(nil, error)
                    return
                }
                
                let code = (response as? HTTPURLResponse)?.statusCode ?? 400
                
                switch code {
                case 0...201:
                    do {
                        let wrapper = try JSONDecoder().decode(T.self, from: data)
                        completion(wrapper, nil)
                    } catch {
                        completion(nil, error)
                    }
                default:
                    completion(nil, NSError())
                }
            }

            task.resume()
        } catch {
            completion(nil, error)
        }
    }
}
