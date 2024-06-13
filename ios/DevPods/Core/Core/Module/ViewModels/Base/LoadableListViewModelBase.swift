import Combine

public class LoadableListViewModelBase<T: Codable>: LoadableViewModelBase<ServerResponseDto<[T]>> {
    public let items = CurrentValueSubject<[T], Never>([])
    public let isEmpty = CurrentValueSubject<Bool, Never>(false)
    
    override func resultWasFound(result: ServerResponseDto<[T]>) {        
        if let data = result.data {
            items.send(data)
            isEmpty.send(items.value.isEmpty)
        }
    }
    
    public override func execute() {
        isEmpty.send(false)
        super.execute()
    }
    
    public func refresh() {
        execute()
    }
}
