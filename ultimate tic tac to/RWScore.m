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

@synthesize value, date, player;

- (id) init
{
  if (self = [super init]) {
    [self setDefaults];
  }
  
  return self;
}

- (void) setDefaults
{
  date = [[NSDate alloc] init];
  player = [[RWEmpty alloc] init];
}

@end
