//
//  HHDropDownListUITests.m
//  HHDropDownListUITests
//
//  Created by Herbert Hu on 2017/10/31.
//  Copyright © 2017年 Herbert Hu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HHDropDownListUITests : XCTestCase

@end

@implementation HHDropDownListUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// Test tapping
- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *dropdownElementsQuery = [app.otherElements containingType:XCUIElementTypeButton identifier:@"dropDown"];
    [[[dropdownElementsQuery childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"MacBook Air"]/*[[".cells.staticTexts[@\"MacBook Air\"]",".staticTexts[@\"MacBook Air\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [[[dropdownElementsQuery childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] tap];
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Mac Pro"]/*[[".cells.staticTexts[@\"Mac Pro\"]",".staticTexts[@\"Mac Pro\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
}

// When dataSource changed, whether the list reload the data correctlly.
- (void)testExample2 {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = [[[app.otherElements containingType:XCUIElementTypeButton identifier:@"dropDown"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [element tap];
    [element tap];
    [app.buttons[@"reloadList"] tap];
    [element tap];
    [element tap];
}

@end
