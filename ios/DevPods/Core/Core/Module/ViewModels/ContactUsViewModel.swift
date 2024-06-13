import Combine

public class ContactUsViewModel: LoadableViewModelBase<ServerResponseDto<MessageDto>> {
    public let queryTypes = Strings.queries
    public let queryType = CurrentValueSubject<String, Never>(.empty)
    public let subject = CurrentValueSubject<String, Never>(.empty)
    public let body = CurrentValueSubject<String, Never>(.empty)
    
    public let queryTypeError = CurrentValueSubject<String?, Never>(nil)
    public let subjectError = CurrentValueSubject<String?, Never>(nil)
    
    public override func initialize(with data: NavigationData?) {
        super.initialize(work: { [unowned self] in
            try await self.api.contactUs(requestDto: self.createRequest())
        })
    }
    
    override func resultWasFound(result: ServerResponseDto<MessageDto>?) {
        self.navigateBackWithDialog(result?.message)
    }
    
    override func isValidRequest() -> Bool {
        queryTypeError.send(queryType.value.isValid ? nil : Strings.invalidQuery)
        subjectError.send(subject.value.isValid ? nil : Strings.invalidSubject)

        return queryTypeError.value.isEmpty && subjectError.value.isEmpty
    }
    
    public func submitWasTapped() {
        execute()
    }
    
    private func createRequest() -> MessageRequestDto {
        let userId = (environment.appState?.auth?.basicProfile?.userID).orEmpty
        let queryType = queryType.value
        let subject = subject.value
        let body = body.value
        let queryStatus = "Pending"

        let request = MessageRequestDto(userID: userId, queryType: queryType, subject: subject, body: body, queryStatus: queryStatus)
        
        return request
    }
}
