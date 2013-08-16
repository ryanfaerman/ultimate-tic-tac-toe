//
//  RWPlayerTimer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWPlayTimer.h"


@implementation RWPlayTimer
@synthesize _player, tickCount;

- (id) init
{
  if (self = [super init]) {
    [self reset];
  }
  
  return self;
}

- (id) initForPlayer:(Class) player
{
  if (self = [super init]) {
    [self reset];
    _player = player;
  }
  return self;
}

- (void) tick
{
  tickCount++;
}

- (void) reset
{
  tickCount = 0;
}

- (NSString *)description
{
  int minutes = tickCount / 60;
  int seconds = tickCount % 60;
  return [[NSString alloc] initWithFormat:@"%02d:%02d", minutes, seconds];
}

- (NSComparisonResult)compare:(id)object
{
  RWPlayTimer *other = (RWPlayTimer *)object;
  
  if ([other tickCount] > tickCount) {
    return NSOrderedAscending;
  }
  
  if ([other tickCount] < tickCount) {
    return NSOrderedDescending;
  }
  
  
  return NSOrderedSame;
}

@end
