public extension String {
    static var empty: String {
        ""
    }
    
    var hasValue: Bool {
        !self.isEmpty
    }
    
    var withSpace: String {
        self + " "
    }
    
    func toURL() -> URL? {
        var urlString = self
        if !urlString.contains("http") {
            urlString = Urls.appUrl + self
        }
        
        guard let url = URL(string: urlString) else { return nil }

        return url
    }
    
    var toInt: Int {
        Int(self) ?? 0
    }
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    var isValid: Bool {
        hasValue
    }
    
    var isPhoneNumberValid: Bool {
        hasValue && self.count == 10
    }
    
    var isDateOfBirthValid: Bool {
        var format = DateFormatter()
        format.dateFormat = "dd/mm/yyyy"
        let date = format.date(from: self)
        return date.hasValue
    }
}

public extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? String.empty
    }
    
    var hasValue: Bool {
        guard let self else {
            return false
        }
        
        return self.hasValue
    }
    
    var isEmpty: Bool {
        !hasValue
    }
}

extension Optional {
    var hasValue: Bool {
        self != nil
    }
}

