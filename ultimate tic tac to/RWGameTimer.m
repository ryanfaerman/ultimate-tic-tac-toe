//
//  RWGameTimer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWGameTimer.h"
#import "RWPlayTimer.h"
#import "RWPlayerO.h"
#import "RWPlayerX.h"
#import "RWStalemate.h"
#import "RWGame.h"

static RWGameTimer *sharedInstance = nil;

@implementation RWGameTimer
@synthesize playTimers;

+ (RWGameTimer *)sharedTimers
{
  static dispatch_once_t onceQueue;
  dispatch_once(&onceQueue, ^{
    sharedInstance = [[RWGameTimer alloc] init];
  });
  
  return sharedInstance;
}

- (id) init
{
  if (self = [super init]) {
    RWPlayTimer *timer_x = [[RWPlayTimer alloc] initForPlayer:[RWPlayerX class]];
    RWPlayTimer *timer_o = [[RWPlayTimer alloc] initForPlayer:[RWPlayerO class]];
    RWPlayTimer *timer_game = [[RWPlayTimer alloc] initForPlayer:[RWGame class]];
    
    playTimers = [[NSDictionary alloc] initWithObjects:@[timer_x, timer_o, timer_game] forKeys:@[[RWPlayerX class], [RWPlayerO class], [RWGame class]]];
  }
  
  return self;
}

- (void) tick
{
  RWPlayTimer *player_timer = [playTimers objectForKey:[[RWGame sharedGame] currentPlayer]];
  RWPlayTimer *game_timer = [playTimers objectForKey:[RWGame class]];
  
  [player_timer tick];
  [game_timer tick];
}

- (void) resetAll
{
  for (RWPlayTimer *timer in [playTimers objectEnumerator]) {
    [timer reset];
  }
}

- (RWPosition *)winner
{
  RWPlayTimer *x_timer = [playTimers objectForKey:[RWPlayerX class]];
  RWPlayTimer *o_timer = [playTimers objectForKey:[RWPlayerO class]];
  
  Class winner = [RWStalemate class];
  
  if (x_timer < o_timer) {
    winner = [RWPlayerX class];
  }
  
  if (x_timer > o_timer) {
    winner = [RWPlayerO class];
  }
  
  return [[winner alloc] init];
}

- (RWPosition *)loser
{
  RWPlayTimer *x_timer = [playTimers objectForKey:[RWPlayerX class]];
  RWPlayTimer *o_timer = [playTimers objectForKey:[RWPlayerO class]];
  
  Class loser = [RWStalemate class];
  
  if (x_timer > o_timer) {
    loser = [RWPlayerO class];
    
  }
  
  if (o_timer > x_timer) {
    loser = [RWPlayerX class];
  }
  
  return [[loser alloc] init];
}

@end
