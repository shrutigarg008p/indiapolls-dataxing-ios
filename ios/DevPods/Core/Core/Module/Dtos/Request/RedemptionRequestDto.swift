struct RedemptionRequestDto: Codable {
    let pointsRequested: Int
    let redemptionModeTitle, redemptionModeId, userId, redemptionRequestStatus: String
    let notes: String
    let pointsRedeemed: Int
}
