//
//  RWLeaderboardProtocol.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWScore.h"

@protocol RWLeaderboardProtocol <NSObject>

- (void) push:(RWScore *)score;

// get the top `quantity` of scores for the past `days` number of days
- (NSArray *) getTop:(NSNumber *)quantity forLast:(NSNumber *)days;

// uses getTop:forLast: with a 7 day default
- (NSArray *) getTop:(NSNumber *)quantity;

- (BOOL) available;

@end
