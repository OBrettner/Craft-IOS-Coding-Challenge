extension String {
    var initials: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { word in
                word.prefix(1)
            }
            .joined()
            .prefix(2)
            .uppercased()
    }
}
