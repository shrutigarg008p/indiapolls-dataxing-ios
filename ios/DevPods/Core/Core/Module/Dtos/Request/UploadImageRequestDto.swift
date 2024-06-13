import Foundation

struct UploadImageRequestDto: Codable {
    let userId: String
    let image: Data
}
