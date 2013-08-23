//
//  RWLocalLeaderBoardEngine.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/21/13.
//  Copyright (c) 2013 Ryan Faerman. All rights reserved.
//

#import "RWLocalLeaderBoardEngine.h"
#import <sqlite3.h>
#import "RWScore.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"

@implementation RWLocalLeaderBoardEngine

#pragma mark - Database Setup
- (id) init
{
  if (self = [super init]) {
    [self setupDatabase];
  }
  
  return self;
}

#pragma mark - LeaderBoard Protocol

- (void) push:(RWScore *)score
{
  [self insert:score];
}

// get the top `quantity` of scores for the past `days` number of days
- (NSArray *) getTop:(NSNumber *)quantity forLast:(NSNumber *)days
{
  
  int today = [[[NSNumber alloc] initWithDouble:[[[NSDate alloc] init] timeIntervalSince1970]] intValue];
  int nDays = [days intValue];
  int since = today - (nDays * 86400); // not so magic number for seconds in a day
  
  NSString *conditions = [[NSString alloc] initWithFormat:@"where updated_at >= %d order by score asc limit %d", since, [quantity intValue]];
  
  return [self findWithConditions:conditions];
}

// uses getTop:forLast: with a 7 day default
- (NSArray *) getTop:(NSNumber *)quantity
{
  NSNumber *days = [[NSNumber alloc] initWithInt:7];
  return [self getTop:quantity forLast:days];
}


- (BOOL) available
{
  return YES; // Local leader boards should always be available
}

#pragma mark - Database Helpers

- (void) setupDatabase
{
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    const char *createTableStatement = "create table if not exists scores (id integer primary key autoincrement, updated_at integer, score integer, player varcharr(255))";
    char *error;
    sqlite3_exec(dbContext, createTableStatement, NULL, NULL, &error);
  }];

}

- (void) insert:(RWScore *)score
{  
  NSArray *dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if(dirpaths != nil) {
    NSString *documentsDirectory = [dirpaths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    sqlite3 *dbContext;
    
    if(sqlite3_open([dbPath UTF8String], &dbContext) == SQLITE_OK) {
      
      const char *insert_sql = "insert into scores (score, player, updated_at) values(?,?,?)";
      sqlite3_stmt *compiledStatement;

      sqlite3_prepare_v2(dbContext, insert_sql, -1, &compiledStatement, NULL);
        
      sqlite3_bind_int(compiledStatement, 1, [[score value] intValue]);
      sqlite3_bind_text(compiledStatement, 2, [[[score player] description] UTF8String], -1, SQLITE_TRANSIENT);
      sqlite3_bind_int(compiledStatement, 3, [[[NSDate alloc] init] timeIntervalSince1970]);
      
      sqlite3_step(compiledStatement);
      sqlite3_finalize(compiledStatement);
      
      sqlite3_close(dbContext);
    }
  }
}


// Conditions should be something like @"where score > 10 order by updated_at desc limit 5"
- (NSArray *) findWithConditions:(NSString *)conditions
{
  NSMutableString *query = [[NSMutableString alloc] initWithString:@"SELECT id, updated_at, score, player FROM scores"];
  [query appendFormat:@" %@", conditions];

  NSMutableArray *recordset = [[NSMutableArray alloc] init];
  
  
  [RWLocalLeaderBoardEngine transaction:^(sqlite3 *dbContext) {
    sqlite3_stmt *compiledQuery;
    sqlite3_prepare_v2(dbContext, [query UTF8String], -1, &compiledQuery, NULL);
    
    RWScore *score;
    NSString *playerDescription;
    
    RWPlayerX *playerX = [[RWPlayerX alloc] init];
    RWPlayerO *playerO = [[RWPlayerO alloc] init];
    
    while(sqlite3_step(compiledQuery) == SQLITE_ROW) {
      
      
      score = [[RWScore alloc] init];
      score.primaryKey = [[NSNumber alloc] initWithUnsignedInt:sqlite3_column_int(compiledQuery, 1)];
      score.date = [[NSDate alloc] initWithTimeIntervalSince1970:sqlite3_column_int(compiledQuery, 2)];
      score.value = [[NSNumber alloc] initWithUnsignedInt:sqlite3_column_int(compiledQuery, 3)];
      
      playerDescription = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(compiledQuery, 3)];
      
      
      if ([playerDescription isEqualToString: [playerX description]]) {
        score.player = playerX;
      } else if ([playerDescription isEqualToString: [playerO description]]) {
        score.player = playerO;
      }
      
      [recordset addObject:score];
      
    }
    
  }];
  
  return recordset;
}

+ (NSNumber*) transaction:(void (^)(sqlite3 *))block
{
  NSNumber *output = [[NSNumber alloc] initWithInt:0];
  
  NSArray *dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  if(dirpaths != nil) {
    NSString *documentsDirectory = [dirpaths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    sqlite3 *dbContext;
    
    if(sqlite3_open([dbPath UTF8String], &dbContext) == SQLITE_OK) {
      if(block) block(dbContext);
      
      output = [[NSNumber alloc] initWithLongLong: sqlite3_last_insert_rowid(dbContext)];
      sqlite3_close(dbContext);
    }
  }
  return output;
}

@end
