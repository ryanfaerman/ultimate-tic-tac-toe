//
//  RWPosition.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/30/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWPosition.h"

@implementation RWPosition

- (RWPosition *) winner
{
  return self;
}

- (BOOL)isEqual:(id)object
{
  return [object isKindOfClass:[self class]];
}

- (BOOL)isClass:(Class)klass
{
  return [self isKindOfClass:klass];
}

@end
