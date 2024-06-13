struct ChangePasswordRequestDto: Codable {
    let currentPassword, newPassword, userId: String
}
