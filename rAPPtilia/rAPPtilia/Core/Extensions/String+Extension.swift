extension String {
    func splitText(maxSentences: Int) -> [String] {
        let sentences = self.components(separatedBy: ". ")
        return stride(from: 0, to: sentences.count, by: maxSentences).map {
            sentences[$0..<min($0 + maxSentences, sentences.count)]
                .joined(separator: ". ")
        }
    }
}
