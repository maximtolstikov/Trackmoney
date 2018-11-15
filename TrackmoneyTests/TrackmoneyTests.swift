//
//  TrackmoneyTests.swift
//  TrackmoneyTests
//
//  Created by Maxim Tolstikov on 30/09/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import XCTest

class TrackmoneyTests: XCTestCase {
    
    var age: Int!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMyTest() throws {
        try given("i am 37 old", closure: {
            age = 37
        })
        try when("after two yars", closure: {
            age += 2
        })
        try then("my age equal 39", closure: {
            XCTAssertEqual(39, age)
        })
        try then("my age minus 2 equal 37", closure: {
            let num = age - 2
            XCTAssertEqual(num, 37)
        })
    }

}
