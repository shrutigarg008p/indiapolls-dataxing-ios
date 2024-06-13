struct VerifyOTPRequestDto: Codable {
    let userId: String
    let otp: String
}
