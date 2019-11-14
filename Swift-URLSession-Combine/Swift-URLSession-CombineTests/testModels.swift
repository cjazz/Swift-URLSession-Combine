//
//  testModels.swift
//  Swift-URLSession-CombineTests
//
//  Created by Adam Chin on 11/14/19.
//  Copyright © 2019 Adam Chin. All rights reserved.
//

import XCTest
@testable import Swift_URLSession_Combine

class testModels: XCTestCase {
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

  func testFirstNameNotEmpty() throws {
    let card = Card(id: "22", name: "hello", nationalPokedexNumber: 2, imageUrl: "http.whaterver", imageUrlHiRes: "http.what")
    let imageURL =  try XCTUnwrap(card.imageUrl)
      XCTAssertFalse(imageURL.isEmpty)
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

}
