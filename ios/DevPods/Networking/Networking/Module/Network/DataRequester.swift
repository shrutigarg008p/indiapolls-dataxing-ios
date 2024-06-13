import Alamofire

public class DataRequester {
    private let authenticator: Authenticator
    private let globalHeader: GlobalHeader
    
    public init(accessTokenStorage: AccessTokenStorage, langauageStorage: LanguageStorage) {
         authenticator = Authenticator(storage: accessTokenStorage)
         globalHeader = GlobalHeader(storage: langauageStorage)
     }
    
    public func createRequest(_ router: Router, isAuthenticated: Bool = false) -> DataRequest {
        var interceptors : Interceptor!
        if (isAuthenticated) {
            interceptors = Interceptor(adapters: [authenticator, globalHeader], retriers: [authenticator, globalHeader])
        } else {
            interceptors = Interceptor(adapters: [globalHeader], retriers: [globalHeader])
        }
        let convertible: URLConvertible = router.baseUrl.appendingPathComponent(router.endPoint)
        let request = AF.request(convertible, method: router.method, parameters: router.params, headers: router.headers, interceptor: interceptors)
        return request
    }
    
    public func createUploadRequest(imageData: Data,_ router: Router, isAuthenticated: Bool = false) -> DataRequest {
        let params = router.params ?? [String : Any]()
        let convertible: URLConvertible = router.baseUrl.appendingPathComponent(router.endPoint)
        let request = AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
            }
            
            multipartFormData.append(imageData, withName: "image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
        },
                                to: convertible,
                                method: router.method,
                                headers: router.headers,
                                interceptor: isAuthenticated ? authenticator : nil)
        
        return request
    }
}
