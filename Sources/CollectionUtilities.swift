extension Collection {
    public var nonEmpty: Self? {
        if self.isEmpty { return nil } else { return self }
    }
}
