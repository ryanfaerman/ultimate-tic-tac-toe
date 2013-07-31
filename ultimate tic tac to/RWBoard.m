//
//  RWBoard.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWBoard.h"

#import "RWEmpty.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"

@implementation RWBoard
@synthesize board, boardWinner;

- (id) init
{
  if (self = [super init]) {
    [self reset];
  }
  
  return self;
}

#pragma mark - Interface

- (void) reset
{
  boardWinner = [[RWEmpty alloc] init];
  
  board = [[NSMutableArray alloc] initWithCapacity:9];
  for (int i = 1; i <= 9; i++) {
    [board addObject:[self blank]];
  }
}

- (RWPosition *) winner {
  
  // don't calculate the winner once determined
  if (![boardWinner isClass:[RWEmpty class]]) {
    return boardWinner;
  }
  
  Class winner = [RWEmpty class];
  
  Class A = [self winnerForRows];
  Class B = [self winnerForColumns];
  Class C = [self winnerForDiagonals];
  
  if(A == [RWPlayerX class] || B == [RWPlayerX class] || C == [RWPlayerX class]) {
    winner = [RWPlayerX class];
  } else if (A == [RWPlayerO class] || B == [RWPlayerO class] || C == [RWPlayerO class]) {
    winner = [RWPlayerO class];
  }
  
  boardWinner = [[winner alloc] init];
  
  return boardWinner;
};

- (BOOL) playPosition:(int)position withPlayer:(Class)player
{
  
  // Make sure the board position is open
  if ([[[board objectAtIndex:position] winner] isClass:[RWEmpty class]]) {
    [board setObject:[[player alloc] init] atIndexedSubscript:position];
    return YES;
  }
  
  return NO;
}

- (RWPosition *) blank
{
  return [[RWEmpty alloc] init];
}

#pragma mark - Calculators

- (Class)winnerforTriplet:(int)a b:(int) b c:(int)c
{
  Class winner = [RWEmpty class];
  
  RWPosition *A = [[board objectAtIndex:a] winner];
  RWPosition *B = [[board objectAtIndex:b] winner];
  RWPosition *C = [[board objectAtIndex:c] winner];
  
  if ([A isEqual:B] && [B isEqual:C]) {
    if ([A isClass: [RWPlayerX class]]) {
      winner = [RWPlayerX class];
    } else if ([A isClass: [RWPlayerO class]]) {
      winner = [RWPlayerO class];
    }
  }
  
  return winner;
}

- (Class)winnerForRows
{
  Class winner = [RWEmpty class];
  
  Class A = [self winnerforTriplet:0 b:1 c:2];
  Class B = [self winnerforTriplet:3 b:4 c:5];
  Class C = [self winnerforTriplet:6 b:7 c:8];
  
  if(A == [RWPlayerX class] || B == [RWPlayerX class] || C == [RWPlayerX class]) {
    winner = [RWPlayerX class];
  } else if (A == [RWPlayerO class] || B == [RWPlayerO class] || C == [RWPlayerO class]) {
    winner = [RWPlayerO class];
  }

  return winner;
}

- (Class)winnerForColumns
{
  Class winner = [RWEmpty class];
  
  Class A = [self winnerforTriplet:0 b:3 c:6];
  Class B = [self winnerforTriplet:1 b:4 c:7];
  Class C = [self winnerforTriplet:2 b:5 c:8];
  
  if(A == [RWPlayerX class] || B == [RWPlayerX class] || C == [RWPlayerX class]) {
    winner = [RWPlayerX class];
  } else if (A == [RWPlayerO class] || B == [RWPlayerO class] || C == [RWPlayerO class]) {
    winner = [RWPlayerO class];
  }
  
  return winner;
}

- (Class)winnerForDiagonals
{
  Class winner = [RWEmpty class];
  
  Class A = [self winnerforTriplet:0 b:4 c:8];
  Class B = [self winnerforTriplet:2 b:4 c:6];
  
  if(A == [RWPlayerX class] || B == [RWPlayerX class]) {
    winner = [RWPlayerX class];
  } else if (A == [RWPlayerO class] || B == [RWPlayerO class]) {
    winner = [RWPlayerO class];
  }
  
  return winner;
}

@end
