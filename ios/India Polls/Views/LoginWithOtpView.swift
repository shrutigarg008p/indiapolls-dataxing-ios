import Core
import SwiftUI

struct LoginWithOtpView: View {
    var viewModel: LoginWithOtpViewModel
    
    private var phoneNumber: Binding<String> {
        Binding<String>(
            get: { self.viewModel.phoneNumber },
            set: { self.viewModel.phoneNumber = $0 }
        )
    }
    
    @State private var phoneNumberError: String?
    
    let onBackPress: () -> Void
    let onLogin: () -> Void
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper(onBackPress: {
                onBackPress()
            })
            
            ScrollView() {
                VStack() {
                    
                    Text(Strings.signInToGetInTouch)
                        .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                        .foregroundColor(Color(Colors.PrimaryTextColor))
                    
                    Spacer()
                        .frame(height: 40)
                    
                    MDCOutlinedTextFieldWrapper(text: self.phoneNumber,
                                                error: $phoneNumberError,
                                                placeholder: Strings.mobilePlaceholder,
                                                label: Strings.mobilePlaceholder,
                                                kb: .phonePad)
                    .onReceive(viewModel.$phoneNumberError, perform: { newError in
                        phoneNumberError = newError
                    })
                    
                    Spacer()
                        .frame(height: 56)
                    
                    Button(action: {
                        onLogin()
                    }) {
                        Text(Strings.login)
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(DefaultButtonStyleWithoutPadding())
                    
                    Spacer()
                        .frame(height: 24)
                }
            }.padding(EdgeInsets(top: 40, leading: Dimen.dimen24, bottom: 40, trailing: Dimen.dimen24))
        }
    }
}
