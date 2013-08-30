//
//  RWAwards.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/29/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWAwards.h"
#import "RWLocalLeaderBoardEngine.h"
#import "RWGameStat.h"

@implementation RWAwards

#pragma mark - Database Setup
- (id) init
{
  if (self = [super init]) {
    [self setupDatabase];
  }
  
  return self;
}

- (void) setupDatabase
{
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    const char *createTableStatement = "create table if not exists awards (id integer primary key autoincrement, name)";
    char *error;
    sqlite3_exec(dbContext, createTableStatement, NULL, NULL, &error);
  }];
}

- (bool) alreadyEarned:(NSString *)name
{
  NSMutableString *query = [[NSMutableString alloc] initWithString:@"SELECT count(*) FROM awards"];
  [query appendFormat:@" where name='%@'", name];
  
  __block int kount = 0;
  
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    sqlite3_stmt *compiledQuery;
    sqlite3_prepare_v2(dbContext, [query UTF8String], -1, &compiledQuery, NULL);
    
    while(sqlite3_step(compiledQuery) == SQLITE_ROW) {
      kount = sqlite3_column_int(compiledQuery, 0);
    }
    
  }];
  
  return kount > 0;
}

- (bool) earn:(NSString *)name when:(NSString *)conditions exceeds:(int)limit
{
  NSLog(@"\n");
  
  bool didEarn = [self alreadyEarned:name];
  if (didEarn) {
    NSLog(@"award %@ already earned", name);
    return NO;
  } else {
    
    
    NSLog(@"award %@ never earned", name);
    if ([RWGameStat count:conditions] > limit) {
      
      NSLog(@"conditions met %@ > %d", conditions, limit);
      NSArray *dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      if(dirpaths != nil) {
        NSString *documentsDirectory = [dirpaths objectAtIndex:0];
        NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
        
        sqlite3 *dbContext;
        
        if(sqlite3_open([dbPath UTF8String], &dbContext) == SQLITE_OK) {
          
          const char *insert_sql = "insert into awards (name) values(?)";
          sqlite3_stmt *compiledStatement;
          
          sqlite3_prepare_v2(dbContext, insert_sql, -1, &compiledStatement, NULL);
          
          sqlite3_bind_text(compiledStatement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
          
          sqlite3_step(compiledStatement);
          sqlite3_finalize(compiledStatement);
          
          sqlite3_close(dbContext);
        }
      }
      
      return YES;
    } else {
      
      NSLog(@"conditions not met %@ !> %d", conditions, limit);
      return NO;
    }
  }
}


#pragma mark - achievement short cuts

+ (bool) playedOneGame {
  return [[[RWAwards alloc] init] earn:@"played_1" when:@"" exceeds:0];
}

+ (bool) playedTwoGames {
  return [[[RWAwards alloc] init] earn:@"played_2" when:@"" exceeds:1];
}

+ (bool) playedThreeGames {
  return [[[RWAwards alloc] init] earn:@"played_3" when:@"" exceeds:2];
}

+ (bool) withinTwoMinutes {
  return [[[RWAwards alloc] init] earn:@"within_2_minutes" when:@"time_x + time_o < 120" exceeds:0];
}

+ (bool) slowerThanFiveMinutes {
  return [[[RWAwards alloc] init] earn:@"slower_5_minutes" when:@"time_x +time_o > 300" exceeds:0];
}


@end
