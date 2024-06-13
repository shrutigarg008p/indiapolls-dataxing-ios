import SwiftUI

struct NavigationBarViewWrapper: View {
    let onBackPress: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            
            HStack() {
                Button(action: {
                    onBackPress()
                })  {
                    Image(uiImage: .icBack)
                        .padding(.leading, 14)
                }.frame(width: 54, height: 48)
                
                Spacer()
                
                Image(uiImage: .icLogoBlack)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                Spacer()
                
                Spacer()
                    .frame(width: 54, height: 48)
            }
            
            Image(uiImage: .icBarGradient)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 1)
        }
    }
}
