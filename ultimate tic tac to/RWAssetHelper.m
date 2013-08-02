//
//  RWAssetHelper.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/31/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWAssetHelper.h"

@implementation RWAssetHelper
+ (NSString *) playerIndicator
{
  return @"05-arrow-west.png";
}

+ (NSString *) boardIndicator
{
  return @"board-indicator.png";
}

+ (NSString *) board
{
  return @"board.png";
}

+ (NSString *) playerX
{
  return @"11-x@2x.png";
}
+ (NSString *) playerO
{
  return @"12-o@2x.png";
}

+ (NSString *) playerXWinner
{
  return @"winner-x.png";
}

+ (NSString *) playerOWinner
{
  return @"winner-o.png";
}

+ (NSString *) pauseButton
{
  return @"17-pause@2x.png";
}

+ (NSString *) menuButton
{
  return @"19-gear@2x.png";
}

@end
