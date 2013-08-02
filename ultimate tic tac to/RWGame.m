//
//  RWGame.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWGame.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"
#import "RWStalemate.h"
#import "RWEmpty.h"

static RWGame *sharedInstance = nil;

@implementation RWGame

@synthesize nextBoard, currentPlayer, isPlaying;

+ (RWGame *)sharedGame
{
  static dispatch_once_t onceQueue;
  dispatch_once(&onceQueue, ^{
    sharedInstance = [[RWGame alloc] init];
  });
  
  return sharedInstance;
}


- (RWBoard *) blank
{
  return [[RWBoard alloc] init];
}

- (void) reset
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RWGameReset" object:self];
  nextBoard = NULL;
  isPlaying = NO;
  currentPlayer = [RWPlayerX class];
  [super reset];
}

- (BOOL) playPosition:(int)position onBoard:(int)b withPlayer:(Class)player;
{
  NSMutableArray *boards = [super board];
  RWBoard *subBoard = [boards objectAtIndex:b];
  
  // Has to play the correct board
  if (nextBoard != NULL) {
    // if current board already isn't playable (winner or stalemate) - go anywhere
    if([self nextIsPlayable] && nextBoard != b) {
      NSLog(@"wrong board");
      return NO;
    }
  }
  

  
  // Only the correct player can play
  if (player != currentPlayer) {
    return NO;
  }
  
  
  if ([subBoard playPosition:position withPlayer:player]) {
    // next player needs to play in the board of the previous players position
    nextBoard = position;
    if (currentPlayer == [RWPlayerX class]) {
      currentPlayer = [RWPlayerO class];
    } else {
      currentPlayer = [RWPlayerX class];
    }
    
    
    NSLog(@"next board is: %d", nextBoard);
    isPlaying = YES;
    return YES;
  }
  
  
  return NO;
}

- (BOOL) nextIsPlayable
{
  NSMutableArray *boards = [super board];
  return [[[boards objectAtIndex:nextBoard] winner] isClass:[RWEmpty class]];
}

- (void) notify
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RWGameWon" object:self];
}

@end
