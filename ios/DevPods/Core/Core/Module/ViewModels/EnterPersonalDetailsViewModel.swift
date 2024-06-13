import Combine

public class EnterPersonalDetailsViewModel: BaseViewModel {
    public let genders = Strings.genders
    
    public let firstName = CurrentValueSubject<String, Never>(.empty)
    public let lastName = CurrentValueSubject<String, Never>(.empty)
    public let mobile = CurrentValueSubject<String, Never>(.empty)
    public let dob = CurrentValueSubject<String, Never>(.empty)
    
    public let firstNameError = CurrentValueSubject<String?, Never>(nil)
    public let lastNameError = CurrentValueSubject<String?, Never>(nil)
    public let mobileError = CurrentValueSubject<String?, Never>(nil)
    public let dobError = CurrentValueSubject<String?, Never>(nil)
    public let genderError = CurrentValueSubject<String?, Never>(nil)

    private var termsAccepted = false
    private var selectedGender: String!
    
    public override func initialize(with data: NavigationData?) {
        termsAccepted = data?[.termsAccepted] as? Bool ?? false
        
        let phoneNumber = (environment.appState?.auth?.phoneNumber).orEmpty
        self.mobile.send(phoneNumber)

        if let data, let user = data[.facebookUser] as? FacebookUser {
            self.mobile.send(user.phoneNumber.orEmpty)
        }
    }
    
    public func nextWasTapped() {
        if isValidRequest() {
            let personalDetails = PersonalDetails(firstName: firstName.value, lastName: lastName.value, gender: selectedGender.lowercased(), dateOfBirth: dob.value, mobile: mobile.value, acceptTerms: termsAccepted, imagePath: nil)
            navigate(to: .enterAddress, data: [.personalDetails: personalDetails])
        }
    }
    
    public func genderWasChanged(gender: String) {
        selectedGender = gender
    }
    
    private func isValidRequest() -> Bool {
        firstNameError.send(firstName.value.isValid ? nil : Strings.invalidFirstName)
        lastNameError.send(lastName.value.isValid ? nil : Strings.invalidLastName)
        mobileError.send(mobile.value.isPhoneNumberValid ? nil : Strings.invalidMobileNumber)
        dobError.send(dob.value.isValid ? nil : Strings.invalidDateofBirth)
        genderError.send(selectedGender.hasValue ? nil : Strings.invalidGender)
        
        return firstNameError.value.isEmpty && lastNameError.value.isEmpty && mobileError.value.isEmpty && dobError.value.isEmpty && genderError.value.isEmpty
    }
}
