import Foundation

extension String {

    /// 数字のみかどうか
    func onlyNumbers() -> Bool {
        return patternMatches(pattern: #"^[\d]+$"#)
    }

    /// 半角英数字のみかどうか
    func onlyHalfWidthAlphanumerics() -> Bool {
        return patternMatches(pattern: #"^[\w]+$"#)
    }

    /// URLかどうか
    func isUrl() -> Bool {
        return patternMatches(pattern: #"http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?"#)
    }

    private func patternMatches(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
}

var str = "123"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()

str = "abc"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()

str = "1234567890abcdef"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()

str = "123abc,./_"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()

str = "https://www.google.com/?hl=ja"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()

str = "http://www.google.com/?hl=ja"
str.onlyNumbers()
str.onlyHalfWidthAlphanumerics()
str.isUrl()
