import SwiftUI
import Core

struct RegisterView: View {
    let viewModel: RegisterViewModel
    
    let onBackPress: () -> Void
    let onNext: () -> Void
    
    private var email: Binding<String> {
        Binding<String>(
            get: { self.viewModel.email },
            set: { self.viewModel.email = $0 }
        )
    }
    
    @State private var emailError: String?
    
    private var mobile: Binding<String> {
        Binding<String>(
            get: { self.viewModel.mobile },
            set: { self.viewModel.mobile = $0 }
        )
    }
    
    @State private var mobileError: String?
    
    private var password: Binding<String> {
        Binding<String>(
            get: { self.viewModel.password },
            set: { self.viewModel.password = $0 }
        )
    }
    
    @State private var passwordError: String?
    
    private var confirmPassword: Binding<String> {
        Binding<String>(
            get: { self.viewModel.confirmPassword },
            set: { self.viewModel.confirmPassword = $0 }
        )
    }
    
    @State private var confirmPasswordError: String?
    
    private var isTermsAccepted: Binding<Bool> {
        Binding<Bool>(
            get: { self.viewModel.isTermsAccepted },
            set: { self.viewModel.isTermsAccepted = $0 }
        )
    }
    
    @State private var termsAcceptedError: String?
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper(onBackPress: {
                onBackPress()
            })
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text(Strings.referAFriend)
                            .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                            .foregroundColor(Color(Colors.PrimaryTextColor))
                        
                        Text(Strings.pleaseProvideFollowingInformationToContinue)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.PrimaryTextColor))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 22)
                    
                    VStack(spacing: 14) {
                        
                        MDCOutlinedTextFieldWrapper(text: self.email,
                                                    error: $emailError,
                                                    placeholder:  Strings.emailPlaceholder,
                                                    label:  Strings.emailPlaceholder,
                                                    kb: .emailAddress)
                        .onReceive(viewModel.$emailError, perform: { newError in
                            emailError = newError
                        })
                        
                        MDCOutlinedTextFieldWrapper(text: self.mobile,
                                                    error: $mobileError,
                                                    placeholder:  Strings.mobilePlaceholder,
                                                    label:  Strings.mobilePlaceholder,
                                                    kb: .phonePad)
                        .onReceive(viewModel.$mobileError, perform: { newError in
                            mobileError = newError
                        })
                        
                        MDCOutlinedTextFieldWrapper(text: self.password,
                                                    error: $passwordError,
                                                    placeholder:  Strings.passwordPlaceholder,
                                                    label:  Strings.passwordPlaceholder,
                                                    secure: true)
                        .onReceive(viewModel.$passwordError, perform: { newError in
                            passwordError = newError
                        })
                        
                        MDCOutlinedTextFieldWrapper(text: self.confirmPassword,
                                                    error: $confirmPasswordError,
                                                    placeholder:  Strings.confirmPasswordPlaceholder,
                                                    label:  Strings.confirmPasswordPlaceholder,
                                                    secure: true)
                        .onReceive(viewModel.$confirmPasswordError, perform: { newError in
                            confirmPasswordError = newError
                        })
                        
                        
                        CustomViewWrapper(termsError: $termsAcceptedError) {
                            viewModel.toggleTerms()
                        }.frame(minHeight: 120)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            
            Button(action: {
                onNext()
                termsAcceptedError = viewModel.termsAcceptedError
            }) {
                Text(Strings.next)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
            
        }
    }
}

struct CustomViewWrapper: UIViewRepresentable {
    @Binding var termsError: String?
    
    let onCheckboxTap: () -> Void

    func makeUIView(context: Context) -> TextView {
        let customView = TextView(frame: .zero)
        customView.onCheckboxClick = onCheckboxTap
        return customView
    }
    
    func updateUIView(_ uiView: TextView, context: Context) {
        uiView.termsErrorLabel.error(termsError)
    }
}
