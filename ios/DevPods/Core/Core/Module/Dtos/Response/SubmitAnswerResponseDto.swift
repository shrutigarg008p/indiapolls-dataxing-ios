struct SubmitAnswerResponseDto: Codable {
    let createdAt, updatedAt, id, userID: String
    let profileID: String
    let response: Response
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, id
        case userID = "userId"
        case profileID = "profileId"
        case response, deletedAt
    }
}
