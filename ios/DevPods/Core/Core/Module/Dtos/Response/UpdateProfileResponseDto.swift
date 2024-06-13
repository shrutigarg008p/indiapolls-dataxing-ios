struct UpdateProfileResponseDto: Codable {
    let basicProfile: ProfileDto

    private enum CodingKeys: String, CodingKey {
        case basicProfile = "basic_profile"
    }
}
