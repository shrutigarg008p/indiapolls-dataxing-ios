import SwiftUI
import Core

struct CompletionView: View {
    var viewModel: BaseViewModel
    let onCompletion: () -> Void

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 70) {
                Image("ic_completion")
                    .aspectRatio(contentMode: .fit)
                
                Text(Strings.thankYouForCompletion)
                    .font(Font.custom(Fonts.Medium, size: FontSize.size16))
                    .foregroundColor(Color(Colors.PrimaryTextColor))
            }
            
            Spacer()

            Button(action: {
                onCompletion()
            }) {
                Text(Strings.complete)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyleWithoutPadding())
                .padding([.horizontal, .bottom], Dimen.dimen24)
        }
    }
}
