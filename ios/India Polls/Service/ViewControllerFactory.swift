import UIKit
import Core

class ViewControllerFactory<T> {
    static func create<U>(from page: PageType, data: NavigationData? = nil) -> T where T: BaseViewController<U>, U: BaseViewModel {
        var vc: T!
        
        switch page {
        case  .enterPersonalDetails, .enterAddress:
            vc = T.viewController(from: "Register")
        case .register:
            vc = T()
        case .completion:
            vc = T()
        case .home:
            vc = T()
        case .profile:
            vc = T.viewController(from: "Profile")
        case .otpVerification:
            vc = T.viewController(from: "OtpVerification")
        case .dashboard:
            vc = T()
        case .profiles:
            vc = T()
        case .rewards:
            vc = T()
        case .contactUs:
            vc = T.viewController(from: "ContactUs")
        case .login:
            vc = T.viewController(from: "Login")
        case  .enterReferalCode:
            vc = T()
        case  .changePassword:
            vc = T()
        case .startSurvey:
            vc = T.viewController(from: "Question")
        case .question:
            vc = T.viewController(from: "Question")
        case .drawerMenu:
            vc = T.viewController(from: "DrawerMenu")
        case .forgotPassword:
            vc = T()
        case .redeemPoints:
            vc = T()
        case .loginWithOtp:
            vc = T()
        default:
            break
        }
        
        let viewModel = U.init()
        viewModel.initialize(with: data)
        vc.viewModel = viewModel
        
        return vc
    }
}
