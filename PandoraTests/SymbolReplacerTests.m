//
//  SymbolReplacerTests.m
//  Pandora
//
//  Created by Olegas on 22/08/2015.
//  Copyright (c) 2015 SkyOffice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SymbolReplacer.h"

@interface SymbolReplacerTests : XCTestCase

@end

@implementation SymbolReplacerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    SymbolReplacer *replacer = [[SymbolReplacer alloc] initWithStringToReplace:@"$rerd$eeer$Aa$rew$oo$ee$.."];
    NSString *actual = [replacer replace];
    XCTAssertTrue([actual isEqualToString:@"RErdEEer$Aa$rewOO$ee$.."]);
}

@end
