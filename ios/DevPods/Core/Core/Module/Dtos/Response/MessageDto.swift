public struct MessageDto: Codable {
    let createdAt: String
    let updatedAt: String
    let id: String
    let userID: String
    let queryType: String
    let subject: String
    let body: String
    let queryStatus: String
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, id
        case userID = "userId"
        case queryType, subject, body, queryStatus, deletedAt
    }
}
