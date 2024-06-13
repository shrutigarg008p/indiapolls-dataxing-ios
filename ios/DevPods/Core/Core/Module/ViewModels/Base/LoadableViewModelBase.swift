import Combine

public class LoadableViewModelBase<T: Codable>: BaseViewModel {
    var work: (() async throws -> T)?
    var resultWasFound: ((T) -> Void)?
    var validate: (() -> Bool)?

    let isExecuting = CurrentValueSubject<Bool, Never>(false)
    let canExecute = CurrentValueSubject<Bool, Never>(false)
    
    
    func initialize(work: (() async throws -> T)?) {
        self.work = work
        
        setBindings()
    }
    
    func setBindings() {
        isExecuting
            .sink { [weak self] in
                self?.isBusy.send($0)
            }
            .store(in: &cancellables)
    }
    
    public func execute() {
        if isValidRequest() {
            Task.init {
                isExecuting.send(true)
                
                defer {
                    isExecuting.send(false)
                }
                
                do {
                    if let result = try await work?() {
                        onMainThread {
                            self.resultWasFound?(result)
                            self.resultWasFound(result: result)
                        }
                    }
                } catch {
                    isExecuting.send(false)
                    onError(error: error)
                }
            }
        }
    }
    
    func isValidRequest() -> Bool {
        if let validate {
            return validate()
        }
        
        return true
    }
    
    func resultWasFound(result: T) {
    }
    
    func onError(error: Error) {
    }
    
    func navigateBackWithDialog(_ message: String?) {
        if let message {
            self.environment.dialog.showMessage(title: Strings.info, message: message) { [weak self] in
                self?.navigateBack()
            }
        }
    }
}
