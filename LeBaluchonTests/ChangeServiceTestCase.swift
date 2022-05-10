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
    
    func testGivenTextInTextToTranslate_WhenTapText_ThenShowingResult() {
        let dateTimestamp = Date().timeIntervalSince1970 - 24.0*60.0*60.0
        UserDefaults.standard.set(dateTimestamp, forKey: ChangeService.userDefaultsDateKey)
        
        let changeService = ChangeService(session: URLSessionFake(data: FakeResponseData.changeCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        changeService.fetchCurrentRate { rate, date in
            let lastRate: Float = 1.090667
            
            XCTAssertEqual(rate, lastRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenTextInTextToTranslate_WhenTapText_ThenShowingResult2() {
        ChangeService.shared.saveCurrentRate()
        let storedDollarRate: Float = 1.090667
        
        XCTAssertNotNil(storedDollarRate)
    }
    
    func testCalculation() {
        // Given
        let changeService = ChangeService()
        let dollarValue: Float = 1
        
        // When
        let calculatedValue = changeService.calculation(value: dollarValue)
        
        // Then
        XCTAssertNil(calculatedValue)
    }
    
    func testCalculationWithRate() {
        // Given
        let changeService = ChangeService()
        changeService.storedDollarRate = 2.4
        let dollarValue: Float = 1
        
        // When
        let calculatedValue = changeService.calculation(value: dollarValue)
        
        // Then
        XCTAssertEqual(calculatedValue, 2.4)
    }
    
    func testSaveCurrentRateWithoutRate() {
        // Given
        let changeService = ChangeService()
        UserDefaults.standard.removeObject(forKey: ChangeService.userDefaultsRateKey)
        UserDefaults.standard.removeObject(forKey: ChangeService.userDefaultsDateKey)
        
        // When
        changeService.saveCurrentRate()
        
        // Then
        let storedRate = UserDefaults.standard.float(forKey: ChangeService.userDefaultsRateKey)
        let date = UserDefaults.standard.double(forKey: ChangeService.userDefaultsDateKey)
        XCTAssertEqual(storedRate, 0)
        XCTAssertEqual(date, 0)
    }
    
    func testFetchCurrentRateWithSavedRateTimestamp() {
        // Given
        let changeService = ChangeService()
        let currentTimestamp = Double(Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(currentTimestamp, forKey: ChangeService.userDefaultsDateKey)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.fetchCurrentRate { _, date in
            XCTAssertEqual(date.timeIntervalSince1970, currentTimestamp)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.00)
    }
}
