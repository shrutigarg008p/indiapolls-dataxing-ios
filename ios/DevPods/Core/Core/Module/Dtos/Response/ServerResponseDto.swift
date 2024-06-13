public struct ServerResponseDto<T: Codable> : Codable {
    let status: Int
    let message: String
    let data: T?
}

public struct BaseServerResponseDto: Codable {
    let status: Int
    let message: String
}
