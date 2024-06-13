import Combine

public class SurveyQuestionsViewModel: LoadableViewModelBase<ServerResponseDto<SurveyQuestionsDto>> {
    public let questions = CurrentValueSubject<[SurveyQuestionItemView], Never>([])
    
    private var submitAnswerLoadable: LoadableViewModelBase<BaseServerResponseDto>!
    
    public override func initialize(with data: NavigationData?) {
        guard let data, let profileId = data[.surveyProfileId] as? String else { return }
        
        let userId = (environment.appState?.auth?.id).orEmpty
        
        submitAnswerLoadable = LoadableViewModelBase()
        submitAnswerLoadable.initialize { [unowned self] in
            try await self.api.submitAnswers(request: createSubmitAnswerRequestDto(userID: userId, profileId: profileId))
        }
        
        submitAnswerLoadable.resultWasFound = { [weak self] result in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
        
        super.initialize { [unowned self] in
            try await self.api.getQuestions(profileId: profileId, userId: userId)
        }
    }
    
    override func setBindings() {
        super.setBindings()
        
        Publishers.CombineLatest(submitAnswerLoadable.isExecuting, isExecuting)
            .map { $0 || $1 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    override func resultWasFound(result: ServerResponseDto<SurveyQuestionsDto>) {
        if let data = result.data {
            let quesitons = data.questions.sorted(by: { $0.displayOrder < $1.displayOrder })
                .map { it in
                    SurveyQuestionItemView(id: it.id, profileId: it.profileID, text: it.text, hint: it.hint, questionId: it.questionID, displayOrder: it.displayOrder, isActive: it.isActive, displayType: it.displayType, dataType: it.dataType, options: createOptions(question: it, existingResponse: data.response.response))
                }
            
            self.questions.send(quesitons)
        }
    }
    
    public func completeButtonWasTapped() {
        submitAnswerLoadable.execute()
    }
    
    private func createOptions(question: Question, existingResponse: [String : ResponseType]?) -> [OptionItemView] {
        let selectedAnswer = existingResponse?[question.id]
        var items = [OptionItemView]()
        switch(question.displayType) {
        case 4:
            var answers: [String]? = nil
            switch (selectedAnswer) {
            case .array(let x):
                answers = x
            default:
                answers = nil
            }
            
            items = question.options.map({ option in
                OptionItemView(
                    id: option.id,
                    questionId: option.questionID,
                    value: option.value,
                    hint: option.hint,
                    displayOrder: option.displayOrder,
                    isActive: option.isActive,
                    isSelected: answers?.contains(where: { $0 == option.id }) ?? false)
            })
        default:
            var answer: String? = nil
            switch (selectedAnswer) {
            case .anythingString(let x):
                answer = x
            default:
                answer = nil
            }
            items = question.options.map({ option in
                OptionItemView(
                    id: option.id,
                    questionId: option.questionID,
                    value: option.value,
                    hint: option.hint,
                    displayOrder: option.displayOrder,
                    isActive: option.isActive,
                    isSelected: answer == option.id)
            })
        }
        
        return items
    }
    
    private func createSubmitAnswerRequestDto(userID: String, profileId: String) -> QuestionResponseDto {
        var map: [String : ResponseType] = [:]
        questions.value.forEach { item in
            switch(item.displayType) {
            case 4:
                let answers = item.options.filter { $0.isSelected}.map { $0.id }
                if (!answers.isEmpty) {
                    map[item.id] = ResponseType.array(answers)
                }
            default:
                let answerId = item.options.first { $0.isSelected }?.id
                if (answerId != nil) {
                    map[item.id] = ResponseType.anythingString(answerId ?? "")
                }
            }
        }
        let requestDto = QuestionResponseDto(userID: userID, profileID: profileId, response: map)
        return requestDto
    }
}

public class SurveyQuestionItemView {
    internal init(id: String, profileId: String, text: String, hint: String, questionId: Int? = nil, displayOrder: Int, isActive: Bool, displayType: Int, dataType: Int, options: [OptionItemView]) {
        self.id = id
        self.profileId = profileId
        self.text = text
        self.hint = hint
        self.questionId = questionId
        self.displayOrder = displayOrder
        self.isActive = isActive
        self.displayType = displayType
        self.dataType = dataType
        self.options = options
    }
    
    let id: String
    let profileId: String
    public let text: String
    public let hint: String
    let questionId: Int?
    let displayOrder: Int
    let isActive: Bool
    public let displayType: Int
    let dataType: Int
    public var options: [OptionItemView]
}

public struct OptionItemView {
    let id: String
    let questionId: String
    public let value: String
    public let hint: String
    let displayOrder: Int
    let isActive: Bool
    public var isSelected: Bool
}
