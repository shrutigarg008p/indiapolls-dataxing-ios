public enum AppError: Error {
    case decodingFailed
    case requestError(_ message: String)
}
