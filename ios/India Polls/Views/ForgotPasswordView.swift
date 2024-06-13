import Core
import SwiftUI

struct ForgotPasswordView: View {
    var viewModel: ForgotPasswordViewModel
    
    private var email: Binding<String> {
        Binding<String>(
            get: { self.viewModel.email },
            set: { self.viewModel.email = $0 }
        )
    }
    
    @State private var emailError: String?
    
    let onBackPress: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper(onBackPress: {
                onBackPress()
            })
            
            ScrollView() {
                VStack() {
                    
                    Text(Strings.forgotPassword)
                        .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                        .foregroundColor(Color(Colors.PrimaryTextColor))
                    
                    Spacer()
                        .frame(height: 8)
                    
                    Text(Strings.pleaseProvideFollowingInformationToContinue)
                        .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                        .foregroundColor(Color(Colors.PrimaryTextColor))
                    
                    Spacer()
                        .frame(height: 30)
                    
                    MDCOutlinedTextFieldWrapper(text: self.email,
                                                error: $emailError,
                                                placeholder: Strings.emailPlaceholder,
                                                label: Strings.emailPlaceholder)
                    .onReceive(viewModel.$emailError, perform: { newError in
                        emailError = newError
                    })
                }
            }.padding(EdgeInsets(top: 22, leading: Dimen.dimen24, bottom: 0, trailing: Dimen.dimen24))
            
            Button(action: {
                onSubmit()
            }) {
                Text(Strings.submit)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}
