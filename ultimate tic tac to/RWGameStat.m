//
//  RWGameStat.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/29/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWGameStat.h"

#import "RWLocalLeaderBoardEngine.h"
#import "RWGameTimer.h"
#import "RWPlayTimer.h"
#import "RWPlayerO.h"
#import "RWPlayerX.h"

@implementation RWGameStat

@synthesize time_x, time_o;

#pragma mark - Database Setup
- (id) init
{
  if (self = [super init]) {
    [self setupDatabase];
  }
  
  return self;
}

#pragma mark - stats
+ (int) count:(NSString *)conditions
{
  NSMutableString *query = [[NSMutableString alloc] initWithString:@"SELECT count(*) FROM stats"];
  [query appendFormat:@" %@", conditions];
  
  NSLog(query);
  
  __block int kount = 0;
  
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    sqlite3_stmt *compiledQuery;
    sqlite3_prepare_v2(dbContext, [query UTF8String], -1, &compiledQuery, NULL);
    
    while(sqlite3_step(compiledQuery) == SQLITE_ROW) {
      kount = sqlite3_column_int(compiledQuery, 0);
      NSLog(@"the block kount is: %d", kount);
    }
    
  }];
  
  NSLog(@"the kount is: %d", kount);
  
  return kount;
}

#pragma mark - Database Stuff
- (void) setupDatabase
{
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    const char *createTableStatement = "create table if not exists stats (id integer primary key autoincrement, time_x integer, time_o integer)";
    char *error;
    sqlite3_exec(dbContext, createTableStatement, NULL, NULL, &error);
  }];
}


- (void) save
{
  if (time_x == nil) {
    RWPlayTimer *xTime = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerX class]];
    time_x = [[NSNumber alloc] initWithInt:xTime.tickCount];
  }
  
  if (time_o == nil) {
    RWPlayTimer *oTime = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerO class]];
    time_o = [[NSNumber alloc] initWithInt:oTime.tickCount];
  }
  
  NSArray *dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if(dirpaths != nil) {
    NSString *documentsDirectory = [dirpaths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    sqlite3 *dbContext;
    
    if(sqlite3_open([dbPath UTF8String], &dbContext) == SQLITE_OK) {
      
      const char *insert_sql = "insert into stats (time_x, time_o) values(?,?)";
      sqlite3_stmt *compiledStatement;
      
      sqlite3_prepare_v2(dbContext, insert_sql, -1, &compiledStatement, NULL);
      
      sqlite3_bind_int(compiledStatement, 1, [time_x intValue]);
      sqlite3_bind_int(compiledStatement, 2, [time_o intValue]);
      
      sqlite3_step(compiledStatement);
      sqlite3_finalize(compiledStatement);
      
      sqlite3_close(dbContext);
    }
  }
}

@end
