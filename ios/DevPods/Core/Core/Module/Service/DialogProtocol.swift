public protocol DialogProtocol {
    func showMessage(title: String, message: String)
    func showMessage(title: String, message: String, okAction: (() -> Void)?)
}
