HAAsyncMutableArray
===================

A subclass of NSMutableArray that allows callers to register blocks to receive the value of an element in the array, 
even if that element does not exist yet.

This was created to solve a problem I was having with an iOS application that needed to access data in an array that 
was being populated by an asynchronous process.


Usage
-----

    [asyncArray objectAtIndex:0 withBlock:^(id obj) {
      // do something with obj
    }];
    
    // somewhere else
    [asyncArray addObject:myAwesomeObject]



Author
------
Brad Greenlee (<brad@hackarts.com>)
    