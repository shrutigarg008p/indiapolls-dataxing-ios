public extension Int {
    var toString: String {
        "\(self)"
    }
    
    var asMin: String {
        self.toString.withSpace + Strings.minInCaps
    }
}
