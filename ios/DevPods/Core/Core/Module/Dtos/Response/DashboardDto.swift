public struct DashboardDto: Codable {
    public let name: String
    public let points: Int
}

public extension DashboardDto {
    var displayValue: String {
        points.toString
    }
}
