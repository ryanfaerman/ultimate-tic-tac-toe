//
//  RWLocalLeaderBoardEngine.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/21/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWLeaderboardProtocol.h"
#import <sqlite3.h>

@interface RWLocalLeaderBoardEngine : NSObject <RWLeaderboardProtocol>

+ (NSNumber*) transaction:(void (^)(sqlite3 *))block;
- (void) setupDatabase;
- (void) insert:(RWScore *)score;
- (NSArray *) findWithConditions:(NSString *)conditions;

@end
