import SwiftUI
import Core

struct RedeemPointsView: View {
    let viewModel: RedeemPointsViewModel
    
    private var points: Binding<String> {
        Binding<String>(
            get: { self.viewModel.points },
            set: { self.viewModel.points = $0 }
        )
    }
    
    @State private var pointsError: String?
    
    private var description: Binding<String> {
        Binding<String>(
            get: { self.viewModel.description },
            set: { self.viewModel.description = $0 }
        )
    }
    
    @State private var emailError: String?
    
    @State private var modes: [String] = []

    private var mode: Binding<String> {
        Binding<String>(
            get: { self.viewModel.mode },
            set: { self.viewModel.mode = $0 }
        )
    }
    
    @State private var modeError: String?
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper(onBackPress: {
                viewModel.navigateBack()
            })
            
            ScrollView {
                VStack(spacing: 26) {
                    MDCOutlinedTextFieldWrapper(text: self.points,
                                                error: $pointsError,
                                                placeholder:  Strings.pointsPlaceholder,
                                                label:  Strings.pointsPlaceholder,
                                                kb: .numberPad)
                    .onReceive(viewModel.$pointsError, perform: { newError in
                        pointsError = newError
                    })
                    
                    MDCTextAreaWrapper(text: self.description,
                                       placeholder:  Strings.descriptionPlaceholder,
                                       label:  Strings.descriptionPlaceholder)
                    
                    PickerTextFieldViewWrapper(pickerData: $modes,
                                               text:  self.mode,
                                               error: $modeError,
                                               placeholder: Strings.selectMode,
                                               label: Strings.selectMode,
                                               onPickerItemChange: { item in
                        viewModel.redemptionModeWasChanged(item.index)
                    })
                    .onReceive(viewModel.$modeError, perform: { newError in
                        modeError = newError
                    })
                    .onReceive(viewModel.$modes, perform: { newModes in
                        modes = newModes.map { $0.name }
                    })
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                viewModel.submitWasTapped()
            }) {
                Text(Strings.redeemPoints)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}
