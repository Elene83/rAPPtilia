extension String {
    func splitText(maxSentences: Int) -> [String] {
        let paragraphs = self.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        var result: [String] = []
        
        for paragraph in paragraphs {
            var sentences: [String] = []
            var currentSentence = ""
            
            let words = paragraph.split(separator: " ", omittingEmptySubsequences: false)
            
            for word in words {
                currentSentence += (currentSentence.isEmpty ? "" : " ") + word
                
                if word.hasSuffix(".") || word.hasSuffix("!") || word.hasSuffix("?") {
                    let trimmed = word.trimmingCharacters(in: .punctuationCharacters)
                    
                    if trimmed.count == 1 || trimmed.first?.isLowercase == true {
                        continue
                    }
                    
                    sentences.append(currentSentence.trimmingCharacters(in: .whitespaces))
                    currentSentence = ""
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
