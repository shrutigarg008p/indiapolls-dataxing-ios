public struct ReferDto: Codable {
    let id, userID, name, email: String
    let phoneNumber, referralStatus, referralMethod, createdAt: String
    let updatedAt: String
    let deletedAt, referredUserID, approvalDate, cancellationDate: String?
    let approvedByID, cancelledByID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case name, email, phoneNumber, referralStatus, referralMethod, createdAt, updatedAt, deletedAt
        case referredUserID = "referredUserId"
        case approvalDate, cancellationDate
        case approvedByID = "approvedById"
        case cancelledByID = "cancelledById"
    }
}
