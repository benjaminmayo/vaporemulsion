extension String {
    var nonEmpty: String? {
        if self.isEmpty { return nil } else { return self }
    }
}
