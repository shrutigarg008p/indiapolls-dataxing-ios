import Alamofire

public enum Router {
    case signUp(_ param: Parameters?)
    case login(_ param: Parameters?)
    case loginWithOtp(_ param: Parameters?)
    case loginWithFacebook(_ param: Parameters?)
    case updateDeviceToken(_ param: Parameters?)
    case contactUs(_ param: Parameters?)
    case getCountries
    case getStates(_ countryId: String, _ limit: Int)
    case getCities(_ stateId: String, _ limit: Int)
    case getSurveys(_ userId: String)
    case updateProfile(_ userId: String, _ param: Parameters?)
    case getRewards(_ userId: String)
    case getDashboard(_ userId: String)
    case getReferrals(_ userId: String)
    case getProfiles(_ userId: String)
    case createReferral(_ param: Parameters?)
    case getAllStatesAndCitiesByZipCode(_ zipCode: String, _ limit: Int)
    case unsubscribeEmail(_ userId: String)
    case changePassword(_ param: Parameters?)
    case deleteAccount(_ userId: String)
    case getQuestions(_ profileId: String, _ userId: String)
    case sendForgotPasswordLink(_ param: Parameters?)
    case uploadPicture(_ param: Parameters?)
    case getLoggedInUserProfile(_ userId: String)
    case submitAnswers(_ param: Parameters?)
    case getAllRedemption
    case sendRedemptionRequest(_ param: Parameters?)
    case verifyMobile(_ param: Parameters?)
    case resendOTP(_ param: Parameters?)

    public var endPoint: String {
        switch self {
        case .signUp:
            return "/api/v1/auth/user/signup"
        case .login:
            return "/api/v1/auth/user/login"
        case .loginWithOtp:
            return "/api/v1/auth/user/continueWithMobile"
        case .loginWithFacebook:
            return "/api/v1/auth/user/login"
        case .updateDeviceToken:
            return "/api/v1/auth/user/updateDeviceToken"
        case .contactUs:
            return "api/v1/messages/create"
        case .getCountries:
            return "api/v1/country/getAll/1000"
        case .getStates(let countryId, let limit):
            return "/api/v1/country/getAllStatesByCountryId/\(countryId)/\(limit)"
        case .getCities(let stateId, let limit):
            return "/api/v1/country/getAllCitiesByStateId/\(stateId)/\(limit)"
        case .getSurveys(let userId):
            return "/api/v1/surveys/panelist-surveys/\(userId)"
        case .updateProfile(let userId, _):
            return "/api/v1/auth/user/update-basic-profile/\(userId)"
        case .getRewards(let userId):
            return "/api/v1/rewards/getAllByUserId/\(userId)/1000"
        case .getDashboard(let userId):
            return "/api/v1/surveys/userRespondentDashboard/\(userId)"
        case .getReferrals(let userId):
            return "/api/v1/referrals/getAllUserReferrals/\(userId)/1000"
        case .getProfiles(let userId):
            return "/api/v1/auth/user/respondentProfileOverview/\(userId)"
        case .createReferral:
            return "/api/v1/referrals/create"
        case .getAllStatesAndCitiesByZipCode(let zipCode, let limit):
            return "/api/v1/country/getAllStatesAndCitiesByZipCode/\(zipCode)/\(limit)"
        case .unsubscribeEmail(let userId):
            return "/api/v1/auth/user/unSubscribeUser/\(userId)"
        case .changePassword:
            return "/api/v1/auth/user/change-password"
        case .deleteAccount(let userId):
            return "/api/v1/auth/user/permanentlyDelete/\(userId)/user"
        case .getQuestions(let profileId, let userId):
            return "/api/v1/profileManagement/getOneDetails/\(profileId)/\(userId)"
        case .sendForgotPasswordLink:
            return "/api/v1/auth/user/reset-password"
        case .uploadPicture:
            return "/api/v1/auth/user/uploadProfile"
        case .getLoggedInUserProfile(let userId):
            return "/api/v1/auth/user/get-user/\(userId)"
        case .submitAnswers:
            return "/api/v1/profileManagement/createUserProfiles"
        case .getAllRedemption:
            return "/api/v1/redemption/getAll/1000"
        case .sendRedemptionRequest:
            return "/api/v1/redemptionRequest/create"
        case .verifyMobile:
            return "/api/v1/auth/user/verify-mobile"
        case .resendOTP:
            return "/api/v1/auth/user/resendOtp"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .login:
            return.post
        case .loginWithOtp:
            return.post
        case .loginWithFacebook:
            return .post
        case .updateDeviceToken:
            return.post
        case .contactUs:
            return .post
        case .getCountries:
            return .get
        case .getStates:
            return .get
        case .getCities:
            return .get
        case .getSurveys:
            return .get
        case .updateProfile:
            return .put
        case .getRewards:
            return .get
        case .getDashboard:
            return .get
        case .getReferrals:
            return .get
        case .getProfiles:
            return .get
        case .createReferral:
            return .post
        case .getAllStatesAndCitiesByZipCode:
            return .get
        case .unsubscribeEmail:
            return .post
        case .changePassword:
            return .post
        case .deleteAccount:
            return .post
        case .getQuestions:
            return .get
        case .sendForgotPasswordLink:
            return .post
        case .uploadPicture:
            return .post
        case .getLoggedInUserProfile:
            return .get
        case .submitAnswers:
            return .post
        case .getAllRedemption:
            return .get
        case .sendRedemptionRequest:
            return .post
        case .verifyMobile:
            return .post
        case .resendOTP:
            return .post
        }
    }
    
    public var params: Parameters? {
        switch self {
        case .signUp(let param):
            return param
        case .login(let param):
            return param
        case .loginWithOtp(let param):
            return param
        case .loginWithFacebook(let param):
            return param
        case .updateDeviceToken(let param):
            return param
        case .contactUs(let param):
            return param
        case .getCountries:
            return nil
        case .getStates:
            return nil
        case .getCities:
            return nil
        case .getSurveys:
            return nil
        case .updateProfile(_, let param):
            return param
        case .getRewards:
            return nil
        case .getDashboard:
            return nil
        case .getReferrals:
            return nil
        case .getProfiles:
            return nil
        case .createReferral(let param):
            return param
        case .getAllStatesAndCitiesByZipCode:
            return nil
        case .unsubscribeEmail:
            return nil
        case .changePassword(let param):
            return param
        case .deleteAccount:
            return nil
        case .getQuestions:
            return nil
        case .sendForgotPasswordLink(let param):
            return param
        case .uploadPicture(let param):
            return param
        case .getLoggedInUserProfile:
            return nil
        case .submitAnswers(let param):
            return param
        case .getAllRedemption:
            return nil
        case .sendRedemptionRequest(let param):
            return param
        case .verifyMobile(let param):
            return param
        case .resendOTP(let param):
            return param
        }
    }
    
    public var headers: HTTPHeaders {
        switch self {
        case .signUp, .login, .loginWithOtp, .loginWithFacebook, .updateDeviceToken, .contactUs, .getCountries, .getStates, .getCities, .getSurveys, .updateProfile, .getRewards, .getDashboard, .getReferrals, .getProfiles, .createReferral, .getAllStatesAndCitiesByZipCode, .unsubscribeEmail, .changePassword, .deleteAccount, .getQuestions, .sendForgotPasswordLink, .getLoggedInUserProfile, .submitAnswers, .getAllRedemption, .sendRedemptionRequest, .verifyMobile, .resendOTP:
            return createHeaders()
        case .uploadPicture:
            var headers = createHeaders()
            headers.add(.contentType("multipart/form-data"))
            return headers
        }
    }
    
    private func createHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(.contentType("application/x-www-form-urlencoded"))
        return headers
    }
    
    public var baseUrl: URL {
        guard let url = URL(string: Urls.appUrl) else {
            fatalError("Url can not be formed ")
        }
        
        return url
    }
}
