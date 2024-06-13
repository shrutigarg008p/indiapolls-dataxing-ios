import UIKit
import Core

class NavigationService: NavigationProtocol {
    var navigationController: UINavigationController? {
        UIApplication.shared.navigationController
    }
    
    func navigate(to page: PageType, data: NavigationData?, animated: Bool = true) {
        var vc: UIViewController
        
        switch page {
        case .enterReferalCode:
            vc = getViewController(from: ReferViewController.self, data: data, page: page)
        case .enterAddress:
            vc = getViewController(from: EnterAddressViewController.self, data: data, page: page)
        case .completion:
            vc = getViewController(from: CompletionViewController.self, data: data, page: page)
        case .profile:
            vc = getViewController(from: ProfileViewController.self, data: data, page: page)
        case .dashboard:
            vc = getViewController(from: MyDashboardViewController.self, data: data, page: page)
        case .profiles:
            vc = getViewController(from: ProfilesViewController.self, data: data, page: page)
        case .rewards:
            vc = getViewController(from: RewardsViewController.self, data: data, page: page)
        case .contactUs:
            vc = getViewController(from: ContactUsViewController.self, data: data, page: page)
        case .home:
            vc = getViewController(from: HomeViewController.self, data: data, page: page)
            switchRoot(viewController: vc)
            return
        case .login:
            vc = getViewController(from: LoginViewController.self, data: data, page: page)
            switchRoot(viewController: vc)
            return
       case .enterPersonalDetails:
            vc = getViewController(from: EnterPersonalDetailsViewController.self, data: data, page: page)
            switchRoot(viewController: vc)
            return
        case .otpVerification:
            vc = getViewController(from: OTPVerificationViewController.self, data: data, page: page)
        case .register:
            vc = getViewController(from: RegisterViewController.self, data: data, page: page)
        case .changePassword:
            vc = getViewController(from: ChangePasswordViewController.self, data: data, page: page)
        case .startSurvey:
            vc = getViewController(from: SurveyQuestionPageViewController.self, data: data, page: page)
        case .question:
            vc = getViewController(from: QuestionViewController.self, data: data, page: page)
        case .drawerMenu:
            vc = getViewController(from: DrawerMenuViewController.self, data: data, page: page)
        case .forgotPassword:
            vc = getViewController(from: ForgotPasswordViewController.self, data: data, page: page)
        case .redeemPoints:
            vc = getViewController(from: RedeemPointsViewController.self, data: data, page: page)
        case .loginWithOtp:
            vc = getViewController(from: LoginWithOtpViewController.self, data: data, page: page)
        case .faq:
            openUrlInExternalWeb(url: Urls.faqUrl)
            return
        }
        
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    private func switchRoot(viewController: UIViewController) {
        navigationController?.popToRootViewController(animated: false)
        let nvc = UINavigationController(rootViewController: viewController)
        AppDelegate.shared.window?.switchRootViewController(nvc)
    }
    
    func goBackOnePage(data: NavigationData?, animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
        if let vc = navigationController?.topViewController as? BaseViewController {
            vc.viewModel.receive(data: data)
        }
    }
    
    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func openUrlInExternalWeb(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func getViewController<T, U>(from type: T.Type, data: NavigationData?, page: PageType) -> T where T: BaseViewController<U>, U: BaseViewModel {
        
        let vc: T = ViewControllerFactory.create(from: page, data: data)
        let viewModel = U.init()
        viewModel.initialize(with: data)
        vc.viewModel = viewModel
        
        return vc
    }
}
