//
//  HAAsyncMutableArray.h
//  HAAsyncMutableArray
//
//  Created by Brad Greenlee on 2/7/11.
//  Copyright 2011 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HAAsyncArrayBlock)(id obj);

@interface HAAsyncMutableArray : NSMutableArray {
@private
    NSMutableArray *asyncArray; // backing store for the array
    NSMutableDictionary *blockCorral; // holding pen for blocks waiting on the array
}

- (id)init;

- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)idx;
- (void)objectAtIndex:(NSUInteger)idx withBlock:(HAAsyncArrayBlock)block;

- (void)insertObject:(id)obj atIndex:(NSUInteger)idx;

- (void)removeObjectAtIndex:(NSUInteger)idx;

@end
