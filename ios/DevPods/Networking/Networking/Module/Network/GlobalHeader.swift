import Alamofire

public final class GlobalHeader : RequestInterceptor {
    private let storage: LanguageStorage
    private let retryLimit = 3
    private let retryDelay: TimeInterval = 10
    
    public init(storage: LanguageStorage) {
        self.storage = storage
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(HTTPHeader(name: "app_type", value: "mobile"))
        urlRequest.headers.add(HTTPHeader(name: "language", value: storage.language))
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
