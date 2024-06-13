import SwiftUI
import Core

struct RewardsView: View {
    var viewModel: RewardsViewModel
    
    @State private var list: [RewardItemView] = []

    var body: some View {
        VStack {
            NavigationBarViewWrapper {
                viewModel.navigateBack()
            }
            
            Spacer()
                .frame(height: 32)
            
            Text(Strings.myRewards)
                .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                .foregroundColor(Color(Colors.PrimaryTextColor))
            
            ScrollView {
                ForEach(list, id: \.name) { item in
                    DashboardRow(title: item.name, count: item.points.toString)
                }
                .onReceive(viewModel.$items, perform: { newList in
                    list = newList
                })
                .padding(.bottom, Dimen.dimen40)
            }
            
            Button(action: {
                viewModel.redeemWasTapped()
            }) {
                Text(Strings.redeemPoints)
                    .frame(maxWidth: .infinity)
            }.buttonStyle(DefaultButtonStyle())
        }
    }
}
