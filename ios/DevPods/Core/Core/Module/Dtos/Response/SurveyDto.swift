public struct SurveyDto: Codable {
    public let name: String
    public let description: String
    public let descriptionOne: String?
    public let descriptionTwo: String?
    public let descriptionThree: String?
    public let descriptionFour: String?
    public let ceggPoints: Int
    public let surveyLength: Int?
    public let expiryDate: String?
    public let disclaimer: String?
    public let createdAt: String?
    public let colorCode: String?

    private enum CodingKeys: String, CodingKey {
        case name, description, ceggPoints, expiryDate, disclaimer, createdAt, surveyLength
        case descriptionOne = "description_one"
        case descriptionTwo = "description_two"
        case descriptionThree = "description_three"
        case descriptionFour = "description_four"
        case colorCode = "colorcode"
    }
}
