//
//  RWPositionHelper.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/31/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWPositionHelper.h"

@implementation RWPositionHelper

+ (CGPoint) boardSprite
{
  return CGPointMake(520, 385);
}

// dimensions of a sub board
+ (CGPoint) subBoardSize
{
  return CGPointMake(250, 250);
}

// dimensions of a playable area
+ (CGPoint) subPositionSize
{
  return CGPointMake(83, 83);
}

// offset of board sprite
+ (CGPoint) boardSpriteOffset
{
  return CGPointMake(145, 8);
}

// offset of player sprite
+ (CGPoint) playerSpriteOffset
{
  return CGPointMake(45, 45);
}

// offset of board indicator sprite
+ (CGPoint) boardIndicatorSpriteOffset
{
  return CGPointMake([self subBoardSize].x/2, [self subBoardSize].y/2);
}

+ (CGPoint) playerXSource
{
  return CGPointMake(50, 450);
}

+ (CGPoint) playerOSource
{
  return CGPointMake(50, 350);
}

+ (CGPoint) currentPlayerIndicator
{
  return CGPointMake(80, [self playerXSource].y);
}

+ (CGPoint) pauseButtonLocation
{
  return CGPointMake(1000, 740);
}

// determine the (x,y) of the board
+ (CGPoint) boardCoordinateFromLocation:(CGPoint)location
{
  int x = (int)(location.x - [self boardSpriteOffset].x)/[self subBoardSize].x;
  int y = (int)(location.y - [self boardSpriteOffset].y)/[self subBoardSize].y;
  
  return CGPointMake(x, y);
}

// determine the (x,y) on a sub-board
+ (CGPoint) subBoardCoordinateFromLocation:(CGPoint)location
{
  CGPoint grid = [self positionCoordinateFromLocation:location];
  
  return CGPointMake((int)grid.x%3, (int)grid.y%3);
}

// determine the (x,y) of a position in the entire board
+ (CGPoint) positionCoordinateFromLocation:(CGPoint)location
{
  int x = (int)(location.x - [self boardSpriteOffset].x)/[self subPositionSize].x;
  int y = (int)(location.y - [self boardSpriteOffset].y)/[self subPositionSize].y;
  
  return CGPointMake(x, y);
}

// convert (x,y) to position
+ (int) positionFromCoordinate:(CGPoint)location
{
  return 3*location.y + location.x;
}

+ (int) positionNumberFromLocation:(CGPoint)location
{
  return [self positionFromCoordinate:[self subBoardCoordinateFromLocation:location]];
}

+ (int) boardNumberFromLocation:(CGPoint)location
{
  return [self positionFromCoordinate:[self boardCoordinateFromLocation:location]];
}

// convert position to (x,y)
+ (CGPoint) coordinateFromPosition:(int)position
{
  return CGPointMake((int)position%3, (int)position/3);
}

+ (CGPoint) positionCenterPointForLocation:(CGPoint)location
{
  CGPoint grid = [self positionCoordinateFromLocation:location];
  
  int x = grid.x * [self subPositionSize].x + [self boardSpriteOffset].x;
  int y = grid.y * [self subPositionSize].y + [self boardSpriteOffset].y;
  
  return CGPointMake(x, y);
}

+ (CGPoint) boardCenterPointForBoard:(int)boardNumber
{
  CGPoint board = [self coordinateFromPosition:boardNumber];
  
  int x = board.x * [self subBoardSize].x + [self boardSpriteOffset].x;
  int y = board.y * [self subBoardSize].y + [self boardSpriteOffset].y;
  
  return CGPointMake(x, y);
}


@end
