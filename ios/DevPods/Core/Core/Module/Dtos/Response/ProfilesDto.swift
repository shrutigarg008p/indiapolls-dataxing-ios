public struct ProfilesDto: Codable {
    let result: [SurveyProfileDto]
    let overallAttemptedPercentage: Int
    let basicProfile: ProfileDto?
    let users: Users?
}

public struct SurveyProfileDto: Codable {
    public let id, name, image, description: String
    let displayOrder: Int
    let createdAt, updatedAt: String
    let deletedAt: String?
    let questionCount: String
    let profileuserresponsesID, profileuserresponsesResponse: String?
    public let totalQuestions, attemptedQuestions, remainingQuestions, attemptedPercentage: Int
    let hindi: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, image, description, displayOrder, createdAt, updatedAt, deletedAt, questionCount, hindi
        case profileuserresponsesID = "profileuserresponses.id"
        case profileuserresponsesResponse = "profileuserresponses.response"
        case totalQuestions, attemptedQuestions, remainingQuestions, attemptedPercentage
    }
}

public struct Users: Codable {
    let emailConfirmed: Bool
    let unsubscribeDate: String?
    let id: String
    let deleteRequestDate, phoneNumber: String?
    let email: String
    let phoneNumberConfirmed: Bool
}
