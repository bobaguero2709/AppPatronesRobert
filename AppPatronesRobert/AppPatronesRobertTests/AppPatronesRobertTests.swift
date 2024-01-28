//
//  AppPatronesRobertTests.swift
//  AppPatronesRobertTests
//
//  Created by Robert Aguero on 1/23/24.
//

import XCTest
@testable import AppPatronesRobert

final class AppPatronesRobertTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_AllHeroesListViewModelFakeSuccess() throws{
        let expectation = self.expectation(description: "Expect list of heroes")
        
        let vm = HomeViewModel(homeUseCase: HomeUseCaseFakeSuccess())
        XCTAssertNotNil(vm)
        
        vm.homeStatusLoad = { status in
            if(status == .loaded){
                expectation.fulfill()
            }
        }
        
        vm.loadHeroes()
        
        wait(for: [expectation], timeout: 5.0)
        
    }

}
