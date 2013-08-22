//
//  RWScore.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPosition.h"

@interface RWScore : NSObject

@property (atomic, retain) NSNumber *primaryKey;
@property (atomic, retain) NSNumber *value;
@property (atomic, retain) NSDate *date;
@property (atomic, retain) RWPosition *player;

- (void) setDefaults;
- (RWScore *) initWithValue:(NSNumber *)v for:(RWPosition *)p on:(NSDate *)d;

@end
