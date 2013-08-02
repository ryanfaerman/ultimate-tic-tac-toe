//
//  RWBoard.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPosition.h"

@interface RWBoard : NSObject

@property (atomic, retain) NSMutableArray *board;
@property (atomic, retain) RWPosition *boardWinner;

- (void) reset;
- (RWPosition *) winner;
- (BOOL) playPosition:(int)position withPlayer:(Class)player;

- (RWPosition *) blank;
- (Class) winnerforTriplet:(int)a b:(int) b c:(int)c;
- (Class) winnerForRows;
- (Class) winnerForColumns;
- (Class) winnerForDiagonals;
- (int) positionsRemaining;
- (void) notify;

@end
