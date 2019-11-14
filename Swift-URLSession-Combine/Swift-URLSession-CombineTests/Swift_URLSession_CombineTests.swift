//
//  Swift_URLSession_CombineTests.swift
//  Swift-URLSession-CombineTests
//
//  Created by Adam Chin on 11/14/19.
//  Copyright © 2019 Adam Chin. All rights reserved.
//

import XCTest
@testable import Swift_URLSession_Combine

class Swift_URLSession_CombineTests: XCTestCase {
  var sut: URLSession!
  
  override func setUp() {
    super.setUp()
    sut = URLSession(configuration: .default)
    
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  //MARK: Network API Completion
  func testCallToAPICompletes() {
    let url = URL(string: "https://my-json-server.typicode.com/cjazz/jbucket/cards/")
    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?

    let dataTask = sut.dataTask(with: url!) { data, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
    
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  //MARK: Network Status Code 200
  func testValidCallToGetHTTPStatusCode(){

    let url = URL(string: "https://my-json-server.typicode.com/cjazz/jbucket/cards/")

    let promise = expectation(description: "Status code: 200")

    let dataTask = sut.dataTask(with: url!) { data, response, error in
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
  }
  

  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
