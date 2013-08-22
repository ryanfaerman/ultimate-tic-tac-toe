//
//  RWLeaderBoard.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/20/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWScore.h"

@interface RWLeaderBoard : NSObject

@property (atomic, retain) NSMutableSet *engines;

+ (RWLeaderBoard *)shared;

- (void) enroll:(Class)engine;
- (void) push:(RWScore*)score;

- (NSDictionary *) top:(NSNumber *)quantity forlast:(NSNumber *)days;
- (NSArray *) top:(NSNumber *)quantity forlast:(NSNumber *)days in:(Class)engine;
// [[RWLeaderBoard shared] top: 25 forLast: 30, in: [RWGameCenterEngine class]]
@end
