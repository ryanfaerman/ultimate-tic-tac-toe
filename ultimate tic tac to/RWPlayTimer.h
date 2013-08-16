//
//  RWPlayerTimer.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/14/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWPlayTimer : NSObject

@property (atomic, retain) Class _player;
@property (atomic) int tickCount;

- (void) tick;
- (void) reset;

- (id) initForPlayer:(Class) player;

@end
