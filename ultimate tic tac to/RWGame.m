//
//  RWGame.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWGame.h"

@implementation RWGame

@synthesize nextBoard;

- (RWBoard *) blank
{
  return [[RWBoard alloc] init];
}

- (BOOL) playPosition:(int)position onBoard:(int)b withPlayer:(Class)player;
{
  NSMutableArray *boards = [super board];
  RWBoard *subBoard = [boards objectAtIndex:b];
  
  if ([subBoard playPosition:position withPlayer:player]) {
    // next player needs to play in the board of the previous players position
    nextBoard = position;
    return YES;
  }
  
  return NO;
}
@end
