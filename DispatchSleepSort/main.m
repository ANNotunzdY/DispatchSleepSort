//
//  main.m
//  DispatchSleepSort
//
//  Created by ANNotunzdY on 11/05/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

int main (int argc, const char * argv[])
{

	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	dispatch_semaphore_t s = dispatch_semaphore_create(0);
	__block int remain = argc - 1;
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:remain];
	
	for (int i=1; i<argc; i++) {
		int n = atoi(argv[i]);
		
		double delayInSeconds = n;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
			NSLog(@"%d", n);
			[result addObject:[NSNumber numberWithInt:n]];
			remain--;
			if (!remain) {
				dispatch_semaphore_signal(s);
			}
		});
	}
	
	if (argc == 1) {
		dispatch_semaphore_signal(s);
	}
	
	dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
	dispatch_release(s);
	
	NSLog(@"Result: %@", [result description]);
	
	[pool drain];
    return 0;
}

