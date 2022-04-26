//
//  ChangeServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Yves Charpentier on 26/04/2022.
//

import XCTest
@testable import LeBaluchon


class ChangeServiceTestCase: XCTestCase {
    func testGetQuoteShouldPostFailedCallbackIfError() {
        let changeService = ChangeService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.latestRatesError))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        changeService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        let changeService = ChangeService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        changeService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        let changeService = ChangeService(session: URLSessionFake(data: FakeResponseData.changeIncorrectData, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        changeService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        let changeService = ChangeService(session: URLSessionFake(data: FakeResponseData.changeIncorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        changeService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let changeService = ChangeService(session: URLSessionFake(data: FakeResponseData.changeCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        changeService.getValue { success, data in
            
            let dollarRate: Float = 1.090667
            
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            
            XCTAssertEqual(dollarRate, data?.usdRate)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
