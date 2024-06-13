import SwiftUI
import Core

struct MyDashboardView: View {
    var viewModel: MyDashboardViewModel
    
    @State private var list: [DashboardDto] = []
    
    var body: some View {
        VStack {
            
            NavigationBarViewWrapper {
                viewModel.navigateBack()
            }
            
            Spacer()
                .frame(height: 32)
            
            Text(Strings.mydashboard)
                .font(Font.custom(Fonts.Medium, size: FontSize.size24))
                .foregroundColor(Color(Colors.PrimaryTextColor))
            
            ScrollView {
                ForEach(list, id: \.name) { item in
                    DashboardRow(title: item.name, count: item.displayValue)
                }
                .onReceive(viewModel.$elements, perform: { newList in
                    list = newList
                })
                .padding(.bottom, Dimen.dimen40)
            }
        }
    }
}

struct DashboardRow: View {
    var title: String
    var count: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.custom(Fonts.Medium, size: FontSize.size16))
                .foregroundColor(Color(Colors.whiteColor))
                .padding(EdgeInsets(top: Dimen.dimen24, leading: Dimen.dimen14, bottom: Dimen.dimen24, trailing: Dimen.dimen14))
            
            Spacer()
            
            Text(count)
                .font(Font.custom(Fonts.SemiBold, size: FontSize.size14))
                .foregroundColor(Color(Colors.whiteColor))
                .padding(EdgeInsets(top: Dimen.dimen6, leading: Dimen.dimen14, bottom: Dimen.dimen6, trailing: Dimen.dimen14))
                .background(Color(Colors.AccentColor))
                .cornerRadius(Dimen.dimen12, corners: .allCorners)
            
            Spacer()
                .frame(width: Dimen.dimen14)
            
        }
        .background(Color(Colors.OutlineColor))
        .cornerRadius(Dimen.dimen6)
        .padding(.horizontal, Dimen.dimen24)
        .padding(.top, Dimen.dimen6)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
