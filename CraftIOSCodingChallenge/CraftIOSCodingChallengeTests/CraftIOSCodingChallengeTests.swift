import XCTest
@testable import CraftIOSCodingChallenge

enum TestErrors: Error{
    case initialError
}

final class CraftIOSCodingChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func initialsOnNormalNames() throws {
        let normalName = "Oliver Brettner"
        let normalInitials = normalName.initials
        guard normalInitials.count == 2 && normalInitials == "OB" else {
            throw TestErrors.initialError
        }
    }
    
    func initialsOnShortNames() throws {
        let normalName = "Oliver"
        let normalInitials = normalName.initials
        guard normalInitials.count == 1 && normalInitials == "O" else {
            throw TestErrors.initialError
        }
    }
    
    func initialsOnLongNames() throws {
        let normalName = "Oliver Brettner The Third Of It's Name"
        let normalInitials = normalName.initials
        guard normalInitials.count == 2 && normalInitials == "OB" else {
            throw TestErrors.initialError
        }
    }
}
