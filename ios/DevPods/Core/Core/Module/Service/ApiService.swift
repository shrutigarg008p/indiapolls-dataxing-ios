import Networking
import Alamofire

public class ApiService {
    private let apiCaller = ApiCaller()
    private let dataRequester: DataRequester
    
    public init(accessTokenStorage: AccessTokenStorage, langauageStorage: LanguageStorage) {
        dataRequester = DataRequester(accessTokenStorage: accessTokenStorage, langauageStorage: langauageStorage)
    }
    
    func signUp(requestDto: RegisterRequestDto) async throws -> ServerResponseDto<RegisterResponseDto> {
        return try await apiCaller.execute(createRequest(.signUp(requestDto.dictionary)))
    }
    
    func login(requestDto: LoginRequestDto) async throws -> ServerResponseDto<AuthDto> {
        return try await apiCaller.execute(createRequest(.login(requestDto.dictionary)))
    }
    
    func loginWithOtp(requestDto: LoginWithOtpRequestDto) async throws -> ServerResponseDto<LoginWithOtpResponseDto> {
        return try await apiCaller.execute(createRequest(.loginWithOtp(requestDto.dictionary)))
    }
    
    func loginWithFacebook(requestDto: FacebookLoginRequestDto) async throws -> ServerResponseDto<AuthDto> {
        return try await apiCaller.execute(createRequest(.loginWithFacebook(requestDto.dictionary)))
    }
    
    func updateDeviceToken(requestDto: DeviceTokenRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.updateDeviceToken(requestDto.dictionary)))
    }
    
    func contactUs(requestDto: MessageRequestDto) async throws -> ServerResponseDto<MessageDto> {
        return try await apiCaller.execute(createRequest(.contactUs(requestDto.dictionary)))
    }
    
    func getCountries() async throws -> ServerResponseDto<[CountryDto]> {
        return try await apiCaller.execute(createRequest(.getCountries))
    }
    
    func getStates(request: AddresRequestDto) async throws -> ServerResponseDto<[StateDto]> {
        return try await apiCaller.execute(createRequest(.getStates(request.id, request.limit)))
    }
    
    func getCities(request: AddresRequestDto) async throws -> ServerResponseDto<[CityDto]> {
        return try await apiCaller.execute(createRequest(.getCities(request.id, request.limit)))
    }
    
    func getSurveys(requestId: String) async throws -> ServerResponseDto<[SurveysDto]> {
        return try await apiCaller.execute(createRequest(.getSurveys(requestId)))
    }
    
    func updateProfile(requestId: String, request: ProfileUpdateRequestDto) async throws -> ServerResponseDto<UpdateProfileResponseDto> {
        return try await apiCaller.execute(createRequest(.updateProfile(requestId, request.dictionary)))
    }
    
    func getRewards(requestId: String) async throws -> ServerResponseDto<RewardsDto> {
        return try await apiCaller.execute(createRequest(.getRewards(requestId)))
    }
    
    func getDashboard(requestId: String) async throws -> ServerResponseDto<[DashboardDto]> {
        return try await apiCaller.execute(createRequest(.getDashboard(requestId)))
    }
    
    func getReferrals(requestId: String) async throws -> ServerResponseDto<[ReferDto]> {
        return try await apiCaller.execute(createRequest(.getReferrals(requestId)))
    }
    
    func getProfiles(requestId: String) async throws -> ServerResponseDto<ProfilesDto> {
        return try await apiCaller.execute(createRequest(.getProfiles(requestId)))
    }
    
    func createReferral(request: ReferRequestDto) async throws -> ServerResponseDto<ReferDto> {
        return try await apiCaller.execute(createRequest(.createReferral(request.dictionary)))
    }
    
    func getAllStatesAndCitiesByZipCode(request: AddresRequestDto) async throws -> ServerResponseDto<RegioDto> {
        return try await apiCaller.execute(createRequest(.getAllStatesAndCitiesByZipCode(request.id, request.limit)))
    }
    
    func unsubscribeEmail(requestId: String) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.unsubscribeEmail(requestId)))
    }
    
    func changePassword(request: ChangePasswordRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.changePassword(request.dictionary)))
    }
    
    func deleteAccount(requestId: String) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.deleteAccount(requestId)))
    }
    
    func getQuestions(profileId: String, userId: String) async throws -> ServerResponseDto<SurveyQuestionsDto> {
        return try await apiCaller.execute(createRequest(.getQuestions(profileId, userId)))
    }
    
    func sendForgotPasswordLink(request: ForgotPasswordRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.sendForgotPasswordLink(request.dictionary)))
    }
    
    func uploadPicture(request: UploadImageRequestDto) async throws -> ServerResponseDto<String> {
        return try await apiCaller.execute(createUploadRequest(imageData: request.image,
                                                               .uploadPicture(request.dictionary)))
    }
    
    func getLoggedInUserProfile(requestId: String) async throws -> ServerResponseDto<ProfileDetailsDto> {
        return try await apiCaller.execute(createRequest(.getLoggedInUserProfile(requestId)))
    }
    
    func submitAnswers(request: QuestionResponseDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.submitAnswers(request.dictionary)))
    }
    
    func getAllRedemption() async throws -> ServerResponseDto<[RedemptionDto]> {
        return try await apiCaller.execute(createRequest(.getAllRedemption))
    }
    
    func sendRedemptionRequest(request: RedemptionRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.sendRedemptionRequest(request.dictionary)))
    }
    
    func resendOTP(request: ResendOTPRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.resendOTP(request.dictionary)))
    }
    
    func verifyOTP(request: VerifyOTPRequestDto) async throws -> BaseServerResponseDto {
        return try await apiCaller.execute(createRequest(.verifyMobile(request.dictionary)))
    }
    
    func createUploadRequest(imageData: Data,_ router: Router, isAuthenticated: Bool = false) -> DataRequest {
        dataRequester.createUploadRequest(imageData: imageData, router, isAuthenticated: isAuthenticated)
    }
    
    func createRequest(_ router: Router, isAuthenticated: Bool = false) -> DataRequest {
        dataRequester.createRequest(router, isAuthenticated: isAuthenticated)
    }
}
