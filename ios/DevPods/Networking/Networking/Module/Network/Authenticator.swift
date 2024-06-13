import Alamofire

public final class Authenticator: RequestInterceptor {
    private let storage: AccessTokenStorage
    private let retryLimit = 3
    private let retryDelay: TimeInterval = 10
    
    public init(storage: AccessTokenStorage) {
        self.storage = storage
    }

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: storage.accessToken))
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        if let statusCode = response?.statusCode,
           (500...599).contains(statusCode),
           request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
