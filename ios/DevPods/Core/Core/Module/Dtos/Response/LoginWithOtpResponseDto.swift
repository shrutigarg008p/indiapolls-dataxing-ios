public struct LoginWithOtpResponseDto: Codable {
    let userId, email, phoneNumber, token: String
}
