public enum KeyType: String {
    case termsAccepted
    case personalDetails
    case surveyProfileId
    case userId
    case completionNavigation
    case loginWithOtp
    case facebookUser
}

public typealias NavigationData = [KeyType: Any]
