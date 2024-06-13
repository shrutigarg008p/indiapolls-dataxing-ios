public struct CityDto: Codable {
    public let id: String
    public let stateId: String
    public let zipCode: String
    public let segment: String
    public let name: String
    public let createdAt: String
    public let updatedAt: String
    public let deletedAt: String?
    public let tier: Int
}
