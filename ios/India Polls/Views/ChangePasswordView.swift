import SwiftUI
import Core

struct ChangePasswordView: View {
    var viewModel: ChangePasswordViewModel

    private var currentPassword: Binding<String> {
        Binding<String>(
            get: { self.viewModel.currentPassword },
            set: { self.viewModel.currentPassword = $0 }
        )
    }
    
    @State private var currentPasswordError: String?
    
    private var newPassword: Binding<String> {
        Binding<String>(
            get: { self.viewModel.newPassword },
            set: { self.viewModel.newPassword = $0 }
        )
    }
    
    @State private var newPasswordError: String?
    
    private var confirmNewPassword: Binding<String> {
        Binding<String>(
            get: { self.viewModel.confirmNewPassword },
            set: { self.viewModel.confirmNewPassword = $0 }
        )
    }
    
    @State private var confirmNewPasswordError: String?
    
    let onBackPress: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper(onBackPress: {
                onBackPress()
            })

            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text(Strings.changePassword)
                            .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                            .foregroundColor(Color(Colors.PrimaryTextColor))

                        Text(Strings.pleaseProvideFollowingInformationToContinue)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.PrimaryTextColor))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 22)

                    VStack(spacing: 14) {
                        MDCOutlinedTextFieldWrapper(text: self.currentPassword,
                                                    error: $currentPasswordError,
                                                    placeholder:  Strings.currentPasswordPlaceholder,
                                                    label:  Strings.currentPasswordPlaceholder,
                                                    secure: true)
                        .onReceive(viewModel.$currentPasswordError, perform: { newError in
                            currentPasswordError = newError
                        })
                        
                        MDCOutlinedTextFieldWrapper(text: self.newPassword,
                                                    error: $newPasswordError,
                                                    placeholder:  Strings.newPasswordPlaceholder,
                                                    label:  Strings.newPasswordPlaceholder,
                                                    secure: true)
                        .onReceive(viewModel.$newPasswordError, perform: { newError in
                            newPasswordError = newError
                        })
                        
                        MDCOutlinedTextFieldWrapper(text: self.confirmNewPassword,
                                                    error: $confirmNewPasswordError,
                                                    placeholder:  Strings.confirmNewPasswordPlaceholder,
                                                    label:  Strings.confirmNewPasswordPlaceholder,
                                                    secure: true)
                        .onReceive(viewModel.$confirmNewPasswordError, perform: { newError in
                            confirmNewPasswordError = newError
                        })
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
            }

            Button(action: {
                onSubmit()
            }) {
                Text(Strings.submit)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}
