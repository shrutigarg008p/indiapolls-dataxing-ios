struct MessageRequestDto: Codable {
    let userID: String
    let queryType: String
    let subject: String
    let body: String
    let queryStatus: String
    
    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case queryType, subject, body, queryStatus
    }
}
