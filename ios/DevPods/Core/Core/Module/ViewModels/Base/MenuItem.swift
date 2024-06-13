public enum MenuItem: CaseIterable {
    case header
    case surveys
    case dashboard
    case profiles
    case rewards
    case contact
    case refer
    case faq
}

public extension MenuItem {
    var icon: String {
        switch self {
        case .header:
            return "ic_header"
        case .surveys:
            return "ic_surveys"
        case .dashboard:
            return "ic_dashboard"
        case .profiles:
            return "ic_profile"
        case .rewards:
            return "ic_rewards"
        case .contact:
            return "ic_contact"
        case .refer:
            return "ic_refer"
        case .faq:
            return "ic_faq"
        }
    }
    
    var title: String {
        switch self {
        case .header:
            return Strings.header
        case .surveys:
            return Strings.mySurveys
        case .dashboard:
            return Strings.mydashboard
        case .profiles:
            return Strings.myProfiles
        case .rewards:
            return Strings.myRewards
        case .contact:
            return Strings.contactUs
        case .refer:
            return Strings.referAFriend
        case .faq:
            return Strings.faq
        }
    }
    
    var page: PageType {
        switch self {
        case .header:
            return .profile
        case .surveys:
            return .home
        case .dashboard:
            return .dashboard
        case .profiles:
            return .profiles
        case .rewards:
            return .rewards
        case .contact:
            return .contactUs
        case .refer:
            return .enterReferalCode
        case .faq:
            return .faq
        }
    }
}
