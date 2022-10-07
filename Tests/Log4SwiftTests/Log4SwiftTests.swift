import XCTest
@testable import Log4Swift

final class Log4SwiftTests: XCTestCase {
    func testExample() throws {

		Log.shared.debug("Debug Statement")
			Log.shared.info("Info Statement")
			Log.shared.warn("Warn Statement")
			Log.shared.error("Error Statement")
		Log.shared.markTimerStart(msg: "Start Timer")
		Log.shared.markTime(msg: "Check Lap")
		Log.shared.markTimerEnd(msg: "End Timer")
	}
}
