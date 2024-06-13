struct ReferRequestDto: Codable {
    let name, email, userId, referralStatus: String
    let referralMethod, phoneNumber: String
}
