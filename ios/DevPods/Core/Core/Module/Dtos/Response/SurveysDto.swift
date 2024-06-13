public struct SurveysDto: Codable {
    public let id, surveyId, userId: String
    let status: String?
    let isStarted, isCompleted, isDisqualified, isOverQuota: Bool
    let isClosedSurvey, isOutlier, isRejected: Bool
    let pointsRewarded, temporarySurveyLinkId: Int
    public let temporarySurveyLink, originalSurveyLink: String
    let expiryDate, createdAt, updatedAt: String
    let deletedAt: String?
    let partnerid: String?
    public let survey: SurveyDto
}


