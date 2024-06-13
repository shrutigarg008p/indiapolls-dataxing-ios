struct RegisterRequestDto: Codable {
    let email: String
    let password: String
    let phoneNumber: String
    let role: String
    let registerType: String
}
