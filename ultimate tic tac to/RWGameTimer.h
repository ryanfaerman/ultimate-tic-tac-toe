//
//  RWGameTimer.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPosition.h"

@interface RWGameTimer : NSObject

@property (atomic, retain) NSDictionary* playTimers;

+ (RWGameTimer *)sharedTimers;

- (RWPosition *)winner;
- (RWPosition *)loser;

- (void) tick;
- (void) resetAll;
@end
