public struct FacebookUser {
    public let udid: String
    public let email: String?
    public let name: String?
    public let phoneNumber: String?
    
   public init(udid: String, email: String?, name: String?, phoneNumber: String?) {
        self.udid = udid
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
