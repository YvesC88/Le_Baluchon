//
//  TranslateServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Yves Charpentier on 26/04/2022.
//

import XCTest
@testable import LeBaluchon

class TranslateServiceTestCase: XCTestCase {
    func testGetQuoteShouldPostFailedCallbackIfError() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.translateError))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        translateService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        translateService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.translateIncorrectData, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        translateService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.translateIncorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        translateService.getValue { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.translateCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
                                            
        translateService.getValue { success, data in
            
            let translatedText: String = "Aujourd'hui"
            
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            
            XCTAssertEqual(translatedText, data?.data.translations.first?.translatedText)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenTextInTextToTranslate_WhenTapText_ThenShowingResult() {
        TranslateService.shared.changeTextUser(text: "Bonjour")

        XCTAssertTrue(TranslateService.textToTranslate == "Bonjour")
    }
    
    func testGivenChangeSourceLanguage_WhenTapOnChangeLanguageButton_LanguageChanged() {
        TranslateService.shared.changeLanguage(source: "en", target: "fr")

        XCTAssertTrue(TranslateService.languageToTranslate == "en")
        XCTAssertTrue(TranslateService.targetLanguage == "fr")
    }
}
