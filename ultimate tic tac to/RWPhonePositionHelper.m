//
//  RWPhonePositionHelper.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/31/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWPhonePositionHelper.h"

@implementation RWPhonePositionHelper
+ (CGPoint) boardSprite
{
  return CGPointMake(280, 160);
}

// dimensions of a sub board
+ (CGPoint) subBoardSize
{
  return CGPointMake(105, 105);
}

// dimensions of a playable area
+ (CGPoint) subPositionSize
{
  return CGPointMake(36, 36);
}

// offset of board sprite
+ (CGPoint) boardSpriteOffset
{
  return CGPointMake(120, 0);
}

// offset of player sprite
+ (CGPoint) playerSpriteOffset
{
  return CGPointMake(15, 15);
}

+ (CGPoint) playerXSource
{
  return CGPointMake(50, 200);
}

+ (CGPoint) playerOSource
{
  return CGPointMake(50, 100);
}

+ (CGPoint) currentPlayerIndicator
{
  return CGPointMake(80, [self playerXSource].y);
}

+ (CGPoint) pauseButtonLocation
{
  return CGPointMake(20, 300);
}

@end
