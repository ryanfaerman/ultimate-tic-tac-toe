//
//  RWPositionHelper.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/31/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWPositionHelper : NSObject

+ (CGPoint) boardSprite;
+ (CGPoint) boardSpriteOffset;
+ (CGPoint) playerSpriteOffset;
+ (CGPoint) boardIndicatorSpriteOffset;
+ (CGPoint) subBoardSize;
+ (CGPoint) subPositionSize;
+ (CGPoint) playerXSource;
+ (CGPoint) playerOSource;
+ (CGPoint) currentPlayerIndicator;
+ (CGPoint) pauseButtonLocation;

+ (CGPoint) boardCoordinateFromLocation:(CGPoint)location;
+ (CGPoint) subBoardCoordinateFromLocation:(CGPoint)location;
+ (CGPoint) positionCoordinateFromLocation:(CGPoint)location;
+ (int) positionFromCoordinate:(CGPoint)location;
+ (int) positionNumberFromLocation:(CGPoint)location;
+ (int) boardNumberFromLocation:(CGPoint)location;
+ (CGPoint) coordinateFromPosition:(int)position;
+ (CGPoint) positionCenterPointForLocation:(CGPoint)location;
+ (CGPoint) boardCenterPointForBoard:(int)boardNumber;
@end
