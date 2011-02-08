//
//  HAAsyncMutableArray.m
//  HAAsyncMutableArray
//
//  Created by Brad Greenlee on 2/7/11.
//  Copyright 2011 Hack Arts. All rights reserved.
//

#import "HAAsyncMutableArray.h"


@implementation HAAsyncMutableArray

#pragma mark -
#pragma mark Lifecycle

- (id)init {
    if ((self = [super init])) {
        asyncArray = [[NSMutableArray alloc] init];
        blockCorral = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    [asyncArray release], asyncArray = nil;
    [blockCorral release], blockCorral = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Querying

- (NSUInteger)count {
    return [asyncArray count];
}

- (id)objectAtIndex:(NSUInteger)idx {
    return [asyncArray objectAtIndex:idx];
}

- (void)objectAtIndex:(NSUInteger)idx withBlock:(HAAsyncArrayBlock)block {
    @synchronized(self) {
        @try {
            block([asyncArray objectAtIndex:idx]);
        }
        @catch (NSException *exception) {
            if ([exception name] == NSRangeException) {
                // array isn't populated yet; add the block to the corral                
                NSNumber *key = [NSNumber numberWithUnsignedInteger:idx];
                NSMutableSet *blocks = [blockCorral objectForKey:key];
                if (blocks == nil) {
                    blocks = [[[NSMutableSet alloc] init] autorelease];
                }
                [blocks addObject:block];
                [blockCorral setObject:blocks forKey:key];
            } else {
                @throw;
            }
        }
    }
}

#pragma mark -
#pragma mark Insertion

- (void)insertObject:(id)obj atIndex:(NSUInteger)idx {
    @synchronized(self) {
        [asyncArray insertObject:obj atIndex:idx];
        // alert any blocks in the corral
        NSNumber *key = [NSNumber numberWithUnsignedInteger:idx];
        NSMutableSet *blocks = [blockCorral objectForKey:key];
        if (blocks != nil) {
            for (HAAsyncArrayBlock block in [blocks allObjects]) {
                block(obj);
            }
            [blocks removeAllObjects];
            [blockCorral removeObjectForKey:key];
        }
    }
}

#pragma mark -
#pragma mark Removal

- (void)removeObjectAtIndex:(NSUInteger)idx {
	@synchronized(self) {
		[asyncArray removeObjectAtIndex:idx];
	}
}

@end
