public struct RewardsDto: Codable {
    let data: [RewardDto]
    let totalPointsInfo: [TotalPointInfo]
}

public struct RewardDto: Codable {
    let id, userID, rewardDate: String
    let points: Int
    let rewardType: String
    let surveyID: String?
    let referralID: String?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let rewardStatus: String
    let revokeDate, revokedByID, grantedByID, sweepstakeID: String?
    let survey: SurveyDto?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case rewardDate, points, rewardType
        case surveyID = "surveyId"
        case referralID = "referralId"
        case createdAt, updatedAt, deletedAt, rewardStatus, revokeDate
        case revokedByID = "revokedById"
        case grantedByID = "grantedById"
        case sweepstakeID = "sweepstakeId"
        case survey, user
    }
}

public struct User: Codable {
    let email: String
}

public struct TotalPointInfo: Codable {
    let name: String
    let value: Int
}
