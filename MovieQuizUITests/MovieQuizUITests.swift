import XCTest

final class MovsieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }
    
    //MARK: - Yes button test
    @MainActor
    func testYesButton() {
        sleep(5)
        let firstPoster = app.images["poster"]
        let firstPoserScreenShot = firstPoster.screenshot().pngRepresentation
        app.buttons["yes"].tap()
        
        sleep(5)
        let nextPoster = app.images["poster"]
        let nextPoserScreenShot = nextPoster.screenshot().pngRepresentation
        let counterLabel = app.staticTexts["counterLabel"].label
        XCTAssertNotEqual(firstPoserScreenShot, nextPoserScreenShot)
        XCTAssertEqual(counterLabel, "2/10")
    }
    
    //MARK: - No button test
    @MainActor
    func testNoButton() {
        sleep(5)
        let firstPoster = app.images["poster"]
        let firstPoserScreenShot = firstPoster.screenshot().pngRepresentation
        app.buttons["no"].tap()
        
        sleep(5)
        let nextPoster = app.images["poster"]
        let nextPoserScreenShot = nextPoster.screenshot().pngRepresentation
        let counterLabel = app.staticTexts["counterLabel"].label
        XCTAssertNotEqual(firstPoserScreenShot, nextPoserScreenShot)
        XCTAssertEqual(counterLabel, "2/10")
        
    }
    
    //MARK: - Alert test
    @MainActor
    func testAlert(){
        var index = 1
        sleep(5)
        while index <= 10{
            app.buttons["yes"].tap()
            index += 1
            sleep(2)
        }
        sleep(5)
        let alert = app.alerts["resultAlert"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    @MainActor
    func testAlertDismiss(){
        sleep(3)
        var index = 1
        sleep(5)
        while index <= 10{
            app.buttons["no"].tap()
            index += 1
            sleep(2)
        }
        sleep(5)
        let alert = app.alerts["resultAlert"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        let counterLabel = app.staticTexts["counterLabel"].label
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(counterLabel, "1/10")
        
    }
}
