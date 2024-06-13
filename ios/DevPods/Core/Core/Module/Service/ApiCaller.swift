import Alamofire
import Combine

public class ApiCaller {
    func execute<T: Codable>(_ request: DataRequest) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            request.validate(statusCode: 200..<400).response { response in
                debugPrint(response)
                
                switch(response.result) {
                case let .success(data):
                    guard let data, let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                        AppEnvironment.current.dialog.showMessage(title: Strings.error, message: Strings.somethingWentWrongPleaseTryAgainLater)
                        return continuation.resume(throwing: AppError.decodingFailed)
                    }
                    
                    continuation.resume(returning: decodedData)
                case let .failure(error):
                    if let data = response.data, let decodedData = try? JSONDecoder().decode(BaseServerResponseDto.self, from: data) {
                        AppEnvironment.current.dialog.showMessage(title: Strings.error, message: decodedData.message)
                        continuation.resume(throwing: AppError.requestError(decodedData.message))
                       return
                    }
                    
                    AppEnvironment.current.dialog.showMessage(title: Strings.error, message: error.failureReason ?? Strings.somethingWentWrongPleaseTryAgainLater)
                    continuation.resume(throwing: error)
                }
            }
            
            request.resume()
        }
    }
    
    private func handleError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
}
