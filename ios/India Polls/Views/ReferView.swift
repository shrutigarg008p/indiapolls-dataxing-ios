import SwiftUI
import Core

struct ReferView: View {
    let viewModel: ReferViewModel
    
    let onBackPress: () -> Void
    let onRefer: () -> Void
    
    private var name: Binding<String> {
        Binding<String>(
            get: { self.viewModel.name },
            set: { self.viewModel.name = $0 }
        )
    }
    
    @State private var nameError: String?
    
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
                        MDCOutlinedTextFieldWrapper(text: self.name,
                                                    error: $nameError,
                                                    placeholder:  Strings.namePlaceholder,
                                                    label:  Strings.namePlaceholder)
                        .onReceive(viewModel.$nameError, perform: { newError in
                            nameError = newError
                        })
                        
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
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                onRefer()
            }) {
                Text(Strings.refer)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}
