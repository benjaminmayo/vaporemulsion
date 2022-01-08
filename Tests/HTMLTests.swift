import XCTest
import VaporEmulsion

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
    
    func testCompleteDocument() {
        let html = HTML.tag("html", children: [
            .tag("head", children: [
                .tag("title", text: "This is some title"),
                .tag("link", attributes: ["rel": "stylesheet", "href": "www.example.com"]),
            ]),
            .tag("body", children: [
                .tag("div", attributes: ["id": "container"], children: [
                    .tag("main", children: [
                        .tag("h1", text: "Page Header"),
                        .tag("h2", text: "Page subheading"),
                        .tag("p", text: "This is some text"),
                        .tag("p", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel eleifend enim, sit amet rutrum neque. Nulla facilisi. Proin pellentesque lacus justo. Phasellus vestibulum ante turpis, quis efficitur urna condimentum in. Morbi finibus suscipit magna, et dapibus quam viverra eget. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas ut urna nulla. Praesent ex diam, semper ac scelerisque ut, aliquet eu arcu. Duis enim velit, egestas at laoreet eget, maximus in arcu. Sed consequat dui vel elit facilisis hendrerit. Etiam eros diam, viverra non ipsum id, consequat efficitur dui. Phasellus nulla nisl, ultrices non hendrerit fringilla, fermentum sed justo. Donec eget risus ac tortor pretium convallis. Vivamus neque est, placerat eget pulvinar sit amet, consequat sit amet nibh."),
                        .tag("p", text: "Aliquam erat volutpat. Sed ac leo in elit rutrum dignissim vitae vel erat. Vestibulum condimentum tellus vel tempus varius. Phasellus mollis malesuada auctor. Phasellus commodo facilisis nisl et porta. Cras convallis blandit turpis. Duis elementum mollis magna, efficitur interdum ex consectetur tempor. Integer scelerisque fermentum rutrum. Donec elementum enim vitae ligula pellentesque, et fringilla metus ullamcorper. Duis sed nibh in nibh varius laoreet. Sed venenatis mauris a orci posuere, eget interdum orci feugiat. Nullam eu venenatis lorem, et ultrices ante. Fusce non velit eget elit gravida dictum maximus id ipsum. Duis pulvinar dolor erat, id aliquam ipsum tincidunt a. Donec porta imperdiet felis vel elementum."),
                        .tag("p", text: "Aliquam erat volutpat. Pellentesque finibus cursus est, a pretium felis laoreet eu. Aliquam a leo eget quam lacinia ultrices sit amet sed mi. Donec volutpat venenatis convallis. Cras mattis ornare sollicitudin. Curabitur venenatis sem felis, vel sagittis tortor sagittis ut. Pellentesque justo odio, aliquam ac mi id, feugiat tincidunt nunc. Nullam et diam eget velit facilisis porta eget gravida dolor. Sed hendrerit pharetra enim, vitae faucibus tortor viverra a."),
                        .tag("p", text: "Quisque mollis, nunc ac viverra pretium, mauris mi faucibus sapien, id ultrices lectus quam id ligula. Donec pharetra commodo sem sed sollicitudin. Phasellus ultricies vitae eros vel volutpat. Morbi orci tellus, euismod ut aliquet non, viverra nec mauris. Morbi lacinia orci sed vehicula molestie. Proin eleifend erat erat, ac tempor leo commodo imperdiet. Praesent sed tincidunt nisl, nec tempus felis. Aliquam at justo nulla. Nullam imperdiet erat sed volutpat pulvinar. Vivamus ligula tellus, suscipit a magna quis, ullamcorper mollis elit. Nullam nec nisl faucibus, sollicitudin sapien sed, fringilla velit. Nunc vitae tellus odio. Integer eget ligula tortor. Praesent in porttitor elit, id vestibulum nisi."),
                        .tag("p", text: "Proin quis eros sit amet mi gravida pulvinar non ut velit. Etiam sed purus enim. Sed condimentum convallis aliquet. Proin et rutrum elit, nec efficitur nisi. Phasellus tortor purus, volutpat id pharetra id, mattis ut felis. Fusce faucibus nulla in felis scelerisque dapibus. Nulla vulputate purus eu magna condimentum, ac vestibulum erat hendrerit. Suspendisse potenti. Nunc ultrices nisi nulla. Integer ac rhoncus urna. Vestibulum felis ex, maximus eget est a, consequat luctus orci. Maecenas mattis finibus libero at dignissim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultrices et nunc eget tempus.")
                    ]),
                    .tag("aside", children: [
                        .tag("p", text: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.")
                    ]),
                    .tag("footer", children: [
                        .tag("ul", children: [
                            .tag("li", attributes: ["class": "this is a class"], text: "This is some text"),
                            .tag("li", attributes: ["class": "this is a class"], text: "This is some text"),
                            .tag("li", attributes: ["class": "this is a class"], text: "This is some text"),
                                .tag("li", attributes: ["class": "this is a class", "tul": "tandem"], text: "This is some text"),
                                .tag("li", attributes: ["class": "this is a class", "tul": "tandem"], text: "This is some text"),
                                .tag("li", attributes: ["class": "this is a class", "tul": "tandem"], text: "This is some text")
                        ])
                    ])
                ])
            ]),
        ])
            
        let expected = #"<html><head><title>This is some title</title><link rel="stylesheet" href="www.example.com"></head><body><div id="container"><main><h1>Page Header</h1><h2>Page subheading</h2><p>This is some text</p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel eleifend enim, sit amet rutrum neque. Nulla facilisi. Proin pellentesque lacus justo. Phasellus vestibulum ante turpis, quis efficitur urna condimentum in. Morbi finibus suscipit magna, et dapibus quam viverra eget. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas ut urna nulla. Praesent ex diam, semper ac scelerisque ut, aliquet eu arcu. Duis enim velit, egestas at laoreet eget, maximus in arcu. Sed consequat dui vel elit facilisis hendrerit. Etiam eros diam, viverra non ipsum id, consequat efficitur dui. Phasellus nulla nisl, ultrices non hendrerit fringilla, fermentum sed justo. Donec eget risus ac tortor pretium convallis. Vivamus neque est, placerat eget pulvinar sit amet, consequat sit amet nibh.</p><p>Aliquam erat volutpat. Sed ac leo in elit rutrum dignissim vitae vel erat. Vestibulum condimentum tellus vel tempus varius. Phasellus mollis malesuada auctor. Phasellus commodo facilisis nisl et porta. Cras convallis blandit turpis. Duis elementum mollis magna, efficitur interdum ex consectetur tempor. Integer scelerisque fermentum rutrum. Donec elementum enim vitae ligula pellentesque, et fringilla metus ullamcorper. Duis sed nibh in nibh varius laoreet. Sed venenatis mauris a orci posuere, eget interdum orci feugiat. Nullam eu venenatis lorem, et ultrices ante. Fusce non velit eget elit gravida dictum maximus id ipsum. Duis pulvinar dolor erat, id aliquam ipsum tincidunt a. Donec porta imperdiet felis vel elementum.</p><p>Aliquam erat volutpat. Pellentesque finibus cursus est, a pretium felis laoreet eu. Aliquam a leo eget quam lacinia ultrices sit amet sed mi. Donec volutpat venenatis convallis. Cras mattis ornare sollicitudin. Curabitur venenatis sem felis, vel sagittis tortor sagittis ut. Pellentesque justo odio, aliquam ac mi id, feugiat tincidunt nunc. Nullam et diam eget velit facilisis porta eget gravida dolor. Sed hendrerit pharetra enim, vitae faucibus tortor viverra a.</p><p>Quisque mollis, nunc ac viverra pretium, mauris mi faucibus sapien, id ultrices lectus quam id ligula. Donec pharetra commodo sem sed sollicitudin. Phasellus ultricies vitae eros vel volutpat. Morbi orci tellus, euismod ut aliquet non, viverra nec mauris. Morbi lacinia orci sed vehicula molestie. Proin eleifend erat erat, ac tempor leo commodo imperdiet. Praesent sed tincidunt nisl, nec tempus felis. Aliquam at justo nulla. Nullam imperdiet erat sed volutpat pulvinar. Vivamus ligula tellus, suscipit a magna quis, ullamcorper mollis elit. Nullam nec nisl faucibus, sollicitudin sapien sed, fringilla velit. Nunc vitae tellus odio. Integer eget ligula tortor. Praesent in porttitor elit, id vestibulum nisi.</p><p>Proin quis eros sit amet mi gravida pulvinar non ut velit. Etiam sed purus enim. Sed condimentum convallis aliquet. Proin et rutrum elit, nec efficitur nisi. Phasellus tortor purus, volutpat id pharetra id, mattis ut felis. Fusce faucibus nulla in felis scelerisque dapibus. Nulla vulputate purus eu magna condimentum, ac vestibulum erat hendrerit. Suspendisse potenti. Nunc ultrices nisi nulla. Integer ac rhoncus urna. Vestibulum felis ex, maximus eget est a, consequat luctus orci. Maecenas mattis finibus libero at dignissim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultrices et nunc eget tempus.</p></main><aside><p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.</p></aside><footer><ul><li class="this is a class">This is some text</li><li class="this is a class">This is some text</li><li class="this is a class">This is some text</li><li class="this is a class" tul="tandem">This is some text</li><li class="this is a class" tul="tandem">This is some text</li><li class="this is a class" tul="tandem">This is some text</li></ul></footer></div></body></html>"#
        let rendered = "\(html)"
        
        XCTAssertEqual(expected, rendered)
    }
}

extension HTMLTests {
    func assert(_ html: HTML, matches expectation: String, line: UInt = #line) {
        XCTAssertEqual("\(html)", expectation, line: line)
    }
}
