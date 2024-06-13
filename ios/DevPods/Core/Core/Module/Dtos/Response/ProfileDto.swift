public struct ProfileDto: Codable {
    let userID, firstName, lastName, gender: String?
    let mobile, dateOfBirth, referralSource, addressLine1: String?
    let addressLine2, country, state, city: String?
    let pinCode: String?
    let acceptTerms: Bool
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let registrationIP, imagePath: String?

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, gender, mobile, dateOfBirth, referralSource, addressLine1, addressLine2, country, state, city, pinCode, acceptTerms, createdAt, updatedAt, deletedAt
        case registrationIP = "registrationIp"
        case imagePath
    }
}

public extension ProfileDto {
    var fullName: String {
        firstName.orEmpty.withSpace + lastName.orEmpty
    }
}
