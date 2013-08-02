//
//  RWAssetHelper.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/31/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWAssetHelper : NSObject
+ (NSString *) playerIndicator;
+ (NSString *) boardIndicator;
+ (NSString *) board;
+ (NSString *) playerX;
+ (NSString *) playerO;
+ (NSString *) playerXWinner;
+ (NSString *) playerOWinner;

+ (NSString *) pauseButton;
+ (NSString *) helpButton;
+ (NSString *) menuButton;

@end
