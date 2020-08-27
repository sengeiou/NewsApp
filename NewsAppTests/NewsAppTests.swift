//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import XCTest
@testable import NewsApp
import Nimble

class NewsAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidatePassword() throws {
        
        // Your password must be between 6 and 16 characters
        expect(SignUpViewModelImpl().validatePassword(password: "123", confirmPassword: "123")).to(equal(false))
        expect(SignUpViewModelImpl().validatePassword(password: "1234567890123456789", confirmPassword: "1234567890123456789")).to(equal(false))

        //Password do not match
        expect(SignUpViewModelImpl().validatePassword(password: "12345678", confirmPassword: "87654321")).to(equal(false))
        
        // all Rule
        expect(SignUpViewModelImpl().validatePassword(password: "12345678", confirmPassword: "12345678")).to(equal(true))

        expect(SignUpViewModelImpl().validatePassword(password: "@bcd12345678%a", confirmPassword: "@bcd12345678%a")).to(equal(true))

    }



}
