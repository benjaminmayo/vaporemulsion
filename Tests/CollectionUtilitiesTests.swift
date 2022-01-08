import XCTest
import VaporEmulsion

class CollectionUtilitiesTests : XCTestCase {
    func testEmpty() {
        XCTAssertNil("".nonEmpty)
        XCTAssertNil([String]().nonEmpty)
        XCTAssertNil([String:String]().nonEmpty)
        
        XCTAssertEqual("a".nonEmpty, "a")
    }
}
