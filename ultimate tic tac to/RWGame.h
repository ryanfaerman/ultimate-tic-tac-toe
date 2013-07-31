//
//  RWGame.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWBoard.h"

@interface RWGame : RWBoard

@property (atomic) int nextBoard;

- (RWBoard *) blank;
- (BOOL) playPosition:(int)position onBoard:(int)b withPlayer:(Class)player;

@end
