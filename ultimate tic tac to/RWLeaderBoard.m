//
//  RWLeaderBoard.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWLeaderBoard.h"
#import "RWLeaderboardProtocol.h"

static RWLeaderBoard *sharedInstance = nil;

@implementation RWLeaderBoard

@synthesize engines;

+ (RWLeaderBoard *)shared
{
  static dispatch_once_t onceQueue;
  dispatch_once(&onceQueue, ^{
    sharedInstance = [[RWLeaderBoard alloc] init];
  });
  
  return sharedInstance;
}

- (id) init
{
  if (self = [super init]) {
    engines = [[NSMutableSet alloc] init];
  }
  
  return self;
}

- (void) enroll:(Class)engine
{
  id <RWLeaderboardProtocol> klass = [[engine alloc] init];
  [engines addObject:klass];
}

- (void) push:(RWScore*)score
{
  for ( id engine in [engines allObjects]) {
    [engine push:score];
  }
}

@end
