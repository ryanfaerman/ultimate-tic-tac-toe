//
//  RWGameStat.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/29/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface RWGameStat : NSObject

@property (nonatomic, retain) NSNumber *time_x;
@property (nonatomic, retain) NSNumber *time_o;

- (void) setupDatabase;
- (void) save;

+ (int) count:(NSString *)conditions;
@end
