import Core
import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel
    @State private var list: [SurveysDto] = []
    @State private var message: String? = nil
    @State private var color: UIColor = .black
    
    var body: some View {
        VStack {
            
            Image(.icBarGradient)
                .frame(height: Dimen.dimen1)
                .padding(.vertical, 16)
            
            Image(.icLogoBlack)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 210, height: 44)
            
            ScrollView(.vertical) {
                VStack {
                    Spacer()
                        .frame(height: Dimen.dimen40)
                    
                    if message.hasValue {
                        Text(message.orEmpty)
                            .font(Font.custom(Fonts.Medium, size: FontSize.size16))
                            .foregroundColor(Color(color))
                            .padding(.bottom, 12)
                            .onTapGesture {
                                viewModel.dashboardMessageWasTapped()
                            }
                    }
                    
                    Spacer()
                        .frame(height: Dimen.dimen12)
                    
                    SurveyView(time: viewModel.timeForFirstSurvey.orEmpty) {
                        viewModel.navigateToFirstSurvey()
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                }.padding(.horizontal, Dimen.dimen24)
                    .onReceive(viewModel.$dashboardMessage, perform: { dm in
                        message = dm?.message
                        color = message.hasValue ? UIColor(hex: (dm?.color)!) : UIColor.black
                    })
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(list, id: \.id) { item in
                            SurveyCardView(data: item.survey) {
                                if let url = URL(string: item.temporarySurveyLink) {
                                    UIApplication.shared.open(url)
                                }
                            }.overlay(
                                RoundedRectangle(cornerRadius: Dimen.dimen6)
                                    .stroke(Color(Colors.PrimaryInlineButtonTextColor), lineWidth: Dimen.dimen1)
                            )
                        }.onReceive(viewModel.$surveys, perform: { newList in
                            list = newList
                        })
                        
                    }.padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

struct SurveyCardView: View {
    let data: SurveyDto
    let onTakeSurveyTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Spacer()
                        .frame(height: 12)
                    
                    Text(Strings.newText)
                        .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                        .foregroundColor(Color(Colors.PrimaryTextColor))
                        .frame(height: 30)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                        .background(Color(Colors.whiteColor))
                        .cornerRadius(Dimen.dimen6)
                        .overlay(
                            RoundedRectangle(cornerRadius: Dimen.dimen6)
                                .stroke(Color(Colors.PrimaryInlineButtonTextColor), lineWidth: Dimen.dimen1)
                            
                        )
                }.padding(.leading, 1)
                
                Spacer()
                    .frame(height: 14)
                
                Text(data.surveyLength?.asMin ?? "")
                    .font(Font.custom(Fonts.Medium, size: FontSize.size14))
                    .foregroundColor(Color(Colors.whiteColor))
                    .padding(.top, 16)
                    .padding(.trailing, 14)
                
            }
            
            Spacer()
            
            Text(data.name)
                .font(Font.custom(Fonts.Medium, size: FontSize.size18))
                .foregroundColor(Color(Colors.whiteColor))
                .padding(.horizontal, 14)
            
            
            Spacer().frame(height: 10)
            
            VStack(spacing: 12) {
                if data.descriptionOne.hasValue {
                    HStack {
                        Image(.icCheckCircle)
                        Text(data.descriptionOne.orEmpty)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.whiteColor))
                    }
                }
                
                if data.descriptionTwo.hasValue {
                    HStack {
                        Image(.icCheckCircle)
                        Text(data.descriptionTwo.orEmpty)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.whiteColor))
                    }
                }
                
                if data.descriptionThree.hasValue {
                    HStack {
                        Image(.icCheckCircle)
                        Text(data.descriptionThree.orEmpty)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.whiteColor))
                    }
                }
                
                if data.descriptionFour.hasValue {
                    HStack {
                        Image(.icCheckCircle)
                        Text(data.descriptionFour.orEmpty)
                            .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                            .foregroundColor(Color(Colors.whiteColor))
                    }
                }
            }.padding(.horizontal, 14)
            
            Spacer()
                .frame(minHeight: 36)
            
            Text(Strings.takeSurveyInCaps)
                .frame(maxWidth: .infinity)
                .font(Font.custom(Fonts.Regular, size: FontSize.size14))
                .foregroundColor(Color(Colors.PrimaryTextColor))
                .frame(height: 36)
            
                .background(Color(Colors.whiteColor))
                .cornerRadius(Dimen.dimen6)
                .overlay(
                    RoundedRectangle(cornerRadius: Dimen.dimen6)
                        .stroke(Color(Colors.PrimaryInlineButtonTextColor), lineWidth: Dimen.dimen1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .onTapGesture {
                    onTakeSurveyTap()
                }
        }
        .background(Color(data.colorCode.toColor))
        .cornerRadius(Dimen.dimen6)
        .frame(width: 250, height: 295)
    }
}

struct SurveyView: View {
    let time: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(Strings.liveSurvey)
                    .font(Font.custom(Fonts.Medium, size: FontSize.size16))
                    .foregroundColor(Color(Colors.PrimaryTextColor))
                Spacer()
                    .frame(width: Dimen.dimen6)
                Circle()
                    .fill(Color(Colors.ErrorColor))
                    .frame(width: 6, height: 6)
            }
            
            HStack {
                Spacer()
                    .frame(width: 14)
                
                Text(Strings.takeASurvey)
                    .font(Font.custom(Fonts.Medium, size: FontSize.size14))
                    .foregroundColor(Color(Colors.whiteColor))
                    .padding(.vertical, 19)
                
                Spacer()
                    .frame(minWidth: 12)
                
                Text(time)
                    .foregroundColor(.white)
                    .font(Font.custom(Fonts.Medium, size: FontSize.size12))
                    .foregroundColor(Color(Colors.whiteColor))
                
                Spacer()
                    .frame(width: 4)
                
                Image(.icChevronRight)
                    .frame(width: 21, height: 21)
                
                Spacer()
                    .frame(width: Dimen.dimen6)
            }
            .onTapGesture {
                onTap()
            }
            .background(Color.outline)
            .cornerRadius(Dimen.dimen6)
        }
    }
}
