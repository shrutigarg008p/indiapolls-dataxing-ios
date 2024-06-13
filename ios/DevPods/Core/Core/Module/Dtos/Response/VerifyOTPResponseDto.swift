struct VerifyOTPResponseDto: Codable {
    let id: String?
    let emailConfirmed: Bool?
    let basicProfile: String?
    let role: String?
    let phoneNumberConfirmed: Bool?
    let phoneNumber, language: String?
}
