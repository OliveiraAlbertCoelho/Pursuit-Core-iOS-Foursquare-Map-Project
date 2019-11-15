//
//  FoursquareMapTests.swift
//  FoursquareMapTests
//
//  Created by albert coelho oliveira on 11/4/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import XCTest
@testable import FoursquareMap

class FoursquareMapTests: XCTestCase {
    
    func testVenueModel() {
        let testData = DataToTest.getDataFromBundle(withName: "venueData", andType: "json")
        let testVenues = Location.getVenues(from: testData)
        
        XCTAssert(testVenues != nil, "testvenues is empty")
        
    }

}
