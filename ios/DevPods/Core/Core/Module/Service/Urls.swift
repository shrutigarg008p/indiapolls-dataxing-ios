public struct Urls {
    public static let appUrl = "https://indiapolls.com:9000"
    public static let termsUrl = "https://test.indiapolls.com/#/terms"
    
    public static var faqUrl: String {
        let language = AppEnvironment.current.preferredLanugage.language
        return language.elementsEqual("en") ? "https://panel.indiapolls.com/#/faq" : "https://panel.indiapolls.com/#/faq-hi"
    }
}
