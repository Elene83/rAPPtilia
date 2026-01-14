extension String {
    func splitText(maxSentences: Int) -> [String] {
        let paragraphs = self.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        var result: [String] = []
        
        for paragraph in paragraphs {
            var sentences: [String] = []
            var currentSentence = ""
            
            let words = paragraph.split(separator: " ", omittingEmptySubsequences: false)
            
            for (index, word) in words.enumerated() {
                currentSentence += (currentSentence.isEmpty ? "" : " ") + word
                
                if word.hasSuffix(".") || word.hasSuffix("!") || word.hasSuffix("?") {
                    let isEndOfSentence: Bool
                    if index + 1 < words.count {
                        let nextWord = words[index + 1]
                        isEndOfSentence = nextWord.first?.isUppercase == true
                    } else {
                        isEndOfSentence = true 
                    }
                    
                    if isEndOfSentence {
                        sentences.append(currentSentence.trimmingCharacters(in: .whitespaces))
                        currentSentence = ""
                    }
                }
            }
            
            if !currentSentence.isEmpty {
                sentences.append(currentSentence.trimmingCharacters(in: .whitespaces))
            }
            
            if sentences.isEmpty {
                continue
            }
            
            let chunks = stride(from: 0, to: sentences.count, by: maxSentences).map {
                sentences[$0..<min($0 + maxSentences, sentences.count)].joined(separator: " ")
            }
            
            result.append(contentsOf: chunks)
        }
        
        return result.isEmpty ? [self] : result
    }
}
