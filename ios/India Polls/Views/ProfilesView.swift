import SwiftUI
import Core

struct ProfilesView: View {
    var viewModel: MyProfilesViewModel
        
    @State private var items: [SurveyProfileDto] = []
    
    var body: some View {
        VStack {
            NavigationBarViewWrapper {
                viewModel.navigateBack()
            }
            
            Spacer()
                .frame(height: 32)
            
            Text(Strings.myProfiles)
                .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                .foregroundColor(Color(Colors.PrimaryTextColor))
            
            ScrollView {
                VStack(spacing: Dimen.dimen28) {
                    ForEach(items, id: \.id) { item in
                        SurveyRow(item: item) {
                            viewModel.startSurveyWasTapped(item)
                        }
                    }.onReceive(viewModel.$items, perform: { newList in
                        items = newList
                    })
                }
                .padding(.horizontal, Dimen.dimen24)
                .padding(.top, Dimen.dimen20)
                .padding(.bottom, Dimen.dimen40)
            }
        }
    }
}

struct SurveyRow: View {
    @State var item: SurveyProfileDto
    
    let onStatusTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Text(item.name)
                    .font(Font.custom(Fonts.Medium, size: FontSize.size18))
                    .foregroundColor(Color(Colors.PrimaryTextColor))
                    .lineLimit(1)
                
                Spacer()
                
                if item.attemptedQuestions == 0 {
                    Text(Strings.notStarted)
                        .font(Font.custom(Fonts.Medium, size: FontSize.size14))
                        .foregroundColor(Color(Colors.PrimaryButtonTextColor))
                        .frame(width: 115, height: 32)
                        .background(Color(Colors.AccentColor))
                        .cornerRadius(6)
                        .onTapGesture {
                            onStatusTap()
                        }
                } else {
                    Text(Strings.update)
                        .font(Font.custom(Fonts.Medium, size: FontSize.size14))
                        .foregroundColor(Color(Colors.PrimaryButtonTextColor))
                        .frame(width: 90, height: 32)
                        .background(Color(Colors.PrimaryInlineButtonTextColor))
                        .cornerRadius(6)
                        .onTapGesture {
                            onStatusTap()
                        }
                }
            }
            
            UIImageViewWrapper(imageUrl: item.image)
                .frame(width: UIScreen.main.bounds.width - 48, height: 170)
                .cornerRadius(6)
            
        }
    }
}

struct UIImageViewWrapper: UIViewRepresentable {
    var imageUrl: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.load(url: imageUrl.toURL())
    }
}
