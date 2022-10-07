import XCTest
@testable import Log4Swift

final class Log4SwiftTests: XCTestCase {
    func testExample() throws {
		if let c = Bundle.main.url(forResource: "Log4Swift", withExtension: "config" )
		{
			Log.shared.debug("Debug Statement")
			Log.shared.info("Info Statement")
			Log.shared.warn("Warn Statement")
			Log.shared.error("Error Statement")
		}
		else
		{
			XCTFail("Can't find Bundle Resources")
		}
    }
}
