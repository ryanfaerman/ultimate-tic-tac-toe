//
//  RWScore.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWScore.h"
#import "RWEmpty.h"

@implementation RWScore

@synthesize value, date, player, primaryKey;

- (id) init
{
  if (self = [super init]) {
    [self setDefaults];
  }
  
  return self;
}

- (void) setDefaults
{
  primaryKey = nil;
  value = [[NSNumber alloc] initWithInt:0];
  date = [[NSDate alloc] init];
  player = [[RWEmpty alloc] init];
}

- (id) initWithValue:(NSNumber *)v for:(RWPosition *)p on:(NSDate *)d
{
  if (self = [super init]) {
    value = v;
    player = p;
    date = d;
  }
  
  return self;
}

- (NSString *)description
{
  return [[NSString alloc] initWithFormat:@"Player %@ with %@", [player description], [value stringValue]];
}

@end
