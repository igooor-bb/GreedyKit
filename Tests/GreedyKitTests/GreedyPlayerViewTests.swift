import XCTest
@testable import GreedyKit

final class GreedyPlayerViewTests: XCTestCase {
    func testPlayerViewDeinitIsCalled_WhenIsOrphan() throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        autoreleasepool {
            let playerView: GreedyPlayerView? = GreedyPlayerView(frame: .zero)
            playerView!.onDeinit = {
                semaphore.signal()
            }
        }
        
        let result = semaphore.wait(timeout: .now() + .seconds(5))
        XCTAssertTrue(result == .success)
    }
    
    func testPlayerViewDeinitIsCalled_WhenAddedToSuperview() throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        let uiView = UIView()
        autoreleasepool {
            let playerView: GreedyPlayerView? = GreedyPlayerView(frame: .zero)
            playerView!.onDeinit = {
                semaphore.signal()
            }
            
            uiView.addSubview(playerView!)
            playerView?.removeFromSuperview()
        }
        
        let result = semaphore.wait(timeout: .now() + .seconds(5))
        XCTAssertTrue(result == .success)
    }
}
