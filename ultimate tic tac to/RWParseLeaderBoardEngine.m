//
//  RWParseLeaderBoardEngine.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/22/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWParseLeaderBoardEngine.h"
#import <Parse/Parse.h>

#import "RWScore.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"

@implementation RWParseLeaderBoardEngine

#pragma mark - LeaderBoard Protocol

- (void) push:(RWScore *)score
{
  NSNumber *scoreDate = [[NSNumber alloc] initWithDouble:[[score date] timeIntervalSince1970]];
  NSDictionary *values = [[NSDictionary alloc]
                          initWithObjects: [NSArray arrayWithObjects: [score value], scoreDate, [[score player] description], nil]
                          forKeys: [NSArray arrayWithObjects:@"value", @"date", @"player", nil]];
  
  PFObject *testObject = [PFObject objectWithClassName:@"Score"];
  [testObject setValuesForKeysWithDictionary:values];
  [testObject save];
}

// get the top `quantity` of scores for the past `days` number of days
- (NSArray *) getTop:(NSNumber *)quantity forLast:(NSNumber *)days
{
  int today = [[[NSNumber alloc] initWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]] intValue];
  int nDays = [days intValue];
  int since = today - (nDays * 86400); // not so magic number for seconds in a day
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %d", since];
  
  PFQuery *query = [PFQuery queryWithClassName:@"Score" predicate:predicate];
  [query orderByAscending:@"score"];
  query.limit = [quantity intValue];
  
  NSMutableArray *recordset = [[NSMutableArray alloc] init];
  RWScore *score;
  NSString *playerDescription;
  
  RWPlayerX *playerX = [[RWPlayerX alloc] init];
  RWPlayerO *playerO = [[RWPlayerO alloc] init];
  
  NSArray *records = [query findObjects];
    
  for (id record in records) {
    score = [[RWScore alloc] init];
    score.value = [record objectForKey:@"value"];
    score.date = [[NSDate alloc] initWithTimeIntervalSince1970:[[record objectForKey:@"date"] doubleValue]];
    
    playerDescription = [record objectForKey:@"player"];
    if ([playerDescription isEqualToString: [playerX description]]) {
      score.player = playerX;
    } else if ([playerDescription isEqualToString: [playerO description]]) {
      score.player = playerO;
    }

    [recordset addObject:score];
  }
  
  return recordset;
}

// uses getTop:forLast: with a 7 day default
- (NSArray *) getTop:(NSNumber *)quantity
{
  NSNumber *days = [[NSNumber alloc] initWithInt:7];
  return [self getTop:quantity forLast:days];
}

- (BOOL) available
{
  return YES; // Let's be dumb and assume the network is always available
}

@end
