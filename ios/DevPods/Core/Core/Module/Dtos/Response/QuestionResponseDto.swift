struct QuestionResponseDto: Codable {
    let userID, profileID: String
    let response: [String: ResponseType]?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileID = "profileId"
        case response
    }
}
