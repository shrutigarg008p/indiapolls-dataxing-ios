public struct AuthDto: Codable {
    let id, email: String
    let phoneNumber: String?
    let registerType: String
    let role: String
    let emailConfirmed: Bool
    let phoneNumberConfirmed: Bool
    let token: String
    let language: String?
    var basicProfile: ProfileDto?
}
