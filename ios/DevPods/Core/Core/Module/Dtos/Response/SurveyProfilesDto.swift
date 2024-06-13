public struct SurveyProfilesDto: Codable {
    let id, name, description: String
    let displayOrder: Int
    let createdAt, updatedAt: String
    let deletedAt: String?
    let hindi: String?
}

public struct SurveyQuestionsDto: Codable {
    let data: SurveyProfilesDto
    let questions: [Question]
    let response: Response
}

public struct Question: Codable {
    let id, profileID, text, hint: String
    let questionID: Int?
    let displayOrder: Int
    let isActive: Bool
    let displayType, dataType: Int
    let createdAt, updatedAt: String
    let deletedAt: String?
    let options: [Option]
    let hindi: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profileId"
        case text, hint
        case questionID = "questionId"
        case displayOrder, isActive, displayType, dataType, createdAt, updatedAt, deletedAt, options, hindi
    }
}

public struct Option: Codable {
    let id, questionID, value: String
    let hint: String
    let displayOrder: Int
    let isActive: Bool
    let createdAt, updatedAt: String
    let deletedAt: String?
    let hindi: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case questionID = "questionId"
        case value, hint, displayOrder, isActive, createdAt, updatedAt, deletedAt, hindi
    }
}

public struct Response: Codable {
    let id: String?
    let profileId: String?
    let userId: String?
    let response: [String: ResponseType]?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
}
//TODO: Sandy check

public enum ResponseType: Codable {
    case anythingString(String)
    case array([String])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .anythingString(x)
            return
        }
        if let x = try? container.decode([String].self) {
            self = .array(x)
            return
        }
        
        throw DecodingError.typeMismatch(ResponseType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ResponseType"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anythingString(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        }
    }
}
