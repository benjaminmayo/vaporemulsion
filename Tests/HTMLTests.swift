import XCTest
@testable import VaporEmulsion

class HTMLTests : XCTestCase {
    func testPrimitives() {
        self.assert(.comment("The quick brown fox jumped over the lazy dog."), matches: "<!-- The quick brown fox jumped over the lazy dog. --!>")
        self.assert(.text("The quick brown fox jumped over the lazy dog."), matches: "The quick brown fox jumped over the lazy dog.")
    }
    
    func testBareTags() {
        self.assert(.tag("span"), matches: "<span></span>")
        self.assert(.tag("p"), matches: "<p></p>")
        self.assert(.tag("div"), matches: "<div></div>")
        self.assert(.tag("br"), matches: "<br>")
        self.assert(.tag("hr"), matches: "<hr>")
    }
    
    func testNested() {
        self.assert(.tag("div", children: [.tag("p", text: "Text")]), matches: "<div><p>Text</p></div>")
        self.assert(.tag("div", children: [.tag("p", text: "Text"), .tag("p", text: "Another")]), matches: "<div><p>Text</p><p>Another</p></div>")
    }
    
    func testAttributes() {
        var attributes = HTML.Attributes()
        attributes.append("a", "b")
        attributes.append("c", "d")
        attributes.append("e", "f")
        attributes.append("g", "h")
        
        self.assert(.tag("div", attributes: attributes), matches: "<div a=\"b\" c=\"d\" e=\"f\" g=\"h\"></div>")
    }
    
    func testLiteralInitialization() {
        let attributes: HTML.Attributes = ["test1" : "value1", "test2": "value2", "test3" : "value3"]
        
        var attributes2 = HTML.Attributes()
        
        attributes2.append("test1", "value1")
        attributes2.append("test2","value2")
        attributes2.append("test3", "value3")

        XCTAssertEqual(attributes, attributes2)
    }
    
    func testClassConvenienceInitialization() {
        let div = HTML.tag("div", class: "test-class", text: "")
        let equivalentDiv = HTML.tag("div", attributes: ["class" : "test-class"])
        
        XCTAssertEqual("\(div)", "\(equivalentDiv)")
        
        let div2 = HTML.tag("div", class: "test-class", text: "This is some text.")
        let equivalentDiv2 = HTML.tag("div", attributes: ["class" : "test-class"], text: "This is some text.")
        
        XCTAssertEqual("\(div2)", "\(equivalentDiv2)")
    }
    
    func testEmptyTextInitialization() {
        let div = HTML.tag("div", text: "")
        let equivalentDiv = HTML.tag("div", attributes: [:], children: [])
        
        XCTAssertEqual("\(div)", "\(equivalentDiv)")
    }
}

extension HTMLTests {
    func assert(_ html: HTML, matches expectation: String, line: UInt = #line) {
        XCTAssertEqual("\(html)", expectation, line: line)
    }
}
