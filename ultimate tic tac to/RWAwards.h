//
//  RWAwards.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/29/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWAwards : NSObject

- (void) setupDatabase;
- (bool) alreadyEarned:(NSString *)name;
- (bool) earn:(NSString *)name when:(NSString *)conditions exceeds:(int)limit;

+ (bool) playedOneGame;
+ (bool) playedTwoGames;
+ (bool) playedThreeGames;

+ (bool) withinTwoMinutes;

+ (bool) slowerThanFiveMinutes;

@end
