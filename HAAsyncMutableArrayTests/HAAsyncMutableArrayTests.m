//
//  HAAsyncMutableArrayTests.m
//  HAAsyncMutableArrayTests
//
//  Created by Brad Greenlee on 2/7/11.
//  Copyright 2011 Hack Arts. All rights reserved.
//

#import "HAAsyncMutableArrayTests.h"


@implementation HAAsyncMutableArrayTests

- (void)setUp {
    [super setUp];
    asyncArray = [[HAAsyncMutableArray alloc] init];
}

- (void)tearDown {
    [asyncArray release];
    [super tearDown];
}

- (void)testInsertion {
    [asyncArray addObject:@"First value"];
    STAssertEquals(@"First value", [asyncArray objectAtIndex:0],
                   @"First value assertion failed!");
}

- (void)testCount {
    [asyncArray addObject:@"First value"];
    STAssertEquals((NSUInteger)1, [asyncArray count], nil);
    [asyncArray addObject:@"Second value"];
    STAssertEquals((NSUInteger)2, [asyncArray count], nil);
    [asyncArray removeAllObjects];
    STAssertEquals((NSUInteger)0, [asyncArray count], nil);    
}

- (void)testRetrievalWithBlock {
    [asyncArray addObject:@"First value"];
    [asyncArray objectAtIndex:0 withBlock:^(id obj) {
        STAssertEquals(@"First value", obj, nil);
    }];
}

- (void)testAsyncRetrieval {
	__block BOOL finished = NO;
    [asyncArray objectAtIndex:0 withBlock:^(id obj) {
        STAssertEquals(@"First value", obj, nil);
		finished = YES;
    }];
    [asyncArray addObject:@"First value"];
	STAssertTrue(finished, nil);
}

@end
