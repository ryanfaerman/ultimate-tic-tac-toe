//
//  RWGameProvider.h
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/1/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWGame.h"

@interface RWGameProvider : NSObject
{
  RWGame *game;
}
+ (RWGame *)sharedGame;
@end
