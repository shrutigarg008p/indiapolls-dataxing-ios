public struct RedemptionDto: Codable {
    public let id, name, description: String
    public let minimumPoints: Int
    public let createdAt, updatedAt: String
    public let deletedAt: String?
    public let useName, usePhone, useAddress: Bool
}
