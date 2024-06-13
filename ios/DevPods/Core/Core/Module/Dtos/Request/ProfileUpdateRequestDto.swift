struct ProfileUpdateRequestDto: Codable {
    let firstName, lastName, gender, dateOfBirth: String
    let referralSource, addressLine1, addressLine2, country: String
    let state, city, mobile, pinCode: String
    let acceptTerms: Bool
    let imagePath: String?
}

struct PersonalDetails {
    let firstName, lastName, gender, dateOfBirth: String
    let mobile: String
    let acceptTerms: Bool
    let imagePath: String?
}
