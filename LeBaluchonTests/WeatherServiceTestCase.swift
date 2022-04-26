//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Yves Charpentier on 13/04/2022.
//

import XCTest
@testable import LeBaluchon

class WeatherServiceTestCase: XCTestCase {
    func testGetQuoteShouldPostFailedCallbackIfError() {
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.weatherError))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        weatherService.getValue(city: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        weatherService.getValue(city: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        weatherService.getValue(city: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherIncorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        weatherService.getValue(city: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        weatherService.getValue(city: "") { success, data in
            
            let description: String = "ciel dégagé"
            let temp: Float = 11.76
            let cityName: String = "Paris"
            
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            
            XCTAssertEqual(description, data!.weather.first?.description)
            XCTAssertEqual(temp, data!.main.temp)
            XCTAssertEqual(cityName, data!.name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
