//
//  RWGame.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWBoard.h"
#import "RWGameStat.h"

@interface RWGame : RWBoard

@property (atomic) int nextBoard;
@property (atomic) bool isPlaying;
@property (atomic, retain) Class currentPlayer;
@property (atomic, retain) RWGameStat *gameStats;

- (RWBoard *) blank;
- (BOOL) playPosition:(int)position onBoard:(int)b withPlayer:(Class)player;
- (BOOL) nextIsPlayable;
- (void) notify;

+ (RWGame *)sharedGame;
@end
