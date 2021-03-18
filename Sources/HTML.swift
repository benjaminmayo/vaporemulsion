public struct HTML {
    public static func comment(_ comment: String) -> HTML {
        return HTML(kind: .comment(comment))
    }
    
    public static func text(_ text: String) -> HTML {
        return HTML(kind: .text(text))
    }
    
    public static func tag(_ name: String, class: String, children: [HTML] = []) -> HTML {
        return HTML(kind: .tag(name: name, attributes: ["class" : `class`], children: children))
    }
    
    public static func tag(_ name: String, class: String, text: String) -> HTML {
		return HTML(kind: .simpleTagWithSingleAttribute(name: name, attributeName: "class", attributeValue: `class`, textContent: text))
    }
    
    public static func tag(_ name: String, attributes: Attributes = [:], children: [HTML] = []) -> HTML {
        return HTML(kind: .tag(name: name, attributes: attributes, children: children))
    }
	
    public static func tag(_ name: String, text: String) -> HTML {
		return HTML(kind: .simpleTag(name: name, text: text))
	}
    
    public static func tag(_ name: String, attributes: Attributes, text: String) -> HTML {
		if attributes.count == 1, let attributeName = attributes.firstAttribute.key.nonEmpty, let attributeValue = attributes.firstAttribute.value.nonEmpty {
			return HTML(kind: .simpleTagWithSingleAttribute(name: name, attributeName: attributeName, attributeValue: attributeValue, textContent: text))
		} else {
			return self.tag(name, attributes: attributes, children: text.nonEmpty.map { [.text($0)] } ?? [])
		}
    }
    
    private let kind: Kind
    
    private init(kind: Kind) {
        self.kind = kind
    }
    
    private enum Kind {
        case comment(String)
        case text(String)
		case simpleTag(name: String, text: String)
		case simpleTagWithSingleAttribute(name: String, attributeName: String, attributeValue: String, textContent: String)
        case tag(name: String, attributes: Attributes, children: [HTML])
    }
}

extension HTML : TextOutputStreamable {
    public func write<Target>(to target: inout Target) where Target : TextOutputStream {
        switch self.kind {
            case .comment(let comment):
                target.write("<!-- \(comment) --!>")
            case .text(let text):
                target.write(text)
			case .simpleTag(name: let name, text: let text):
				target.write("<\(name)>\(text)</\(name)>")
			case .simpleTagWithSingleAttribute(name: let name, attributeName: let attributeName, attributeValue: let attributeValue, textContent: let textContent):
				target.write("<\(name) \(attributeName)=\"\(attributeValue)\">\(textContent)</\(name)>")
            case .tag(let name, let attributes, let children):
                target.write("<\(name)")
				
				for (key, value) in attributes {
                    target.write(" \(key)")
                    
                    if !value.isEmpty {
                        target.write("=\"\(value)\"")
                    }
                }
                
                if HTML.isTagSelfClosing(name, children) {
                    target.write(">")
                } else {
                    target.write(">")
                    
                    for child in children {
                        child.write(to: &target)
                    }

                    target.write("</\(name)>")
                }
        }
    }

    private static func isTagSelfClosing(_ tag: String, _ children: [HTML]) -> Bool {
        if !children.isEmpty {
            return false
        }
        
        return HTML.html5SelfClosingTags.contains(tag)
    }
    
    private static let html5SelfClosingTags: Set<String> = ["area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"]
}

extension HTML {
    public struct Attributes : Equatable, ExpressibleByDictionaryLiteral, Sequence {
        private var properties: [(String, String)]
        
        public init(dictionaryLiteral elements: (String, String)...) {
            self.properties = elements
        }
		
        var count: Int {
			return self.properties.count
		}
        
        var firstAttribute: (key: String, value: String) {
			return self.properties[0]
		}
		
        public mutating func append(_ key: String, _ value: String = "") {
            self.properties.append((key, value))
        }
        
        public func makeIterator() -> IndexingIterator<[(String, String)]> {
            return self.properties.makeIterator()
        }
        
        public static func ==(lhs: HTML.Attributes, rhs: HTML.Attributes) -> Bool {
            return lhs.elementsEqual(rhs, by: { (a, b) in
                a.0 == b.0 && a.1 == b.1
            })
        }
    }
}
