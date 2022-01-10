extension Collection {
    @inlinable @inline(__always)
    public var nonEmpty: Self? {
        if self.isEmpty { return nil } else { return self }
    }
}
