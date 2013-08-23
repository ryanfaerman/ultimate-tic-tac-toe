//
//  LeaderBoardLayer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/22/13.
//  Copyright 2013 Ryan Faerman. All rights reserved.
//

#import "LeaderBoardLayer.h"
#import "RWLeaderBoard.h"
#import "RWParseLeaderBoardEngine.h"

CCLabelTTF *oneDayLabel;
CCLabelTTF *sevenDayLabel;

CCLabelTTF *oneDayScores;
CCLabelTTF *sevenDayScores;

@implementation LeaderBoardLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
  LeaderBoardLayer *layer = [LeaderBoardLayer node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    self.touchEnabled = YES;
    [self scheduleUpdate];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    
    
    
    oneDayLabel = [CCLabelTTF labelWithString:@"Last Day" fontName:@"Marker Felt" fontSize:26];
    [self addChild:oneDayLabel z:0];
    [oneDayLabel setColor:ccc3(200,200,200)];
    oneDayLabel.position = ccp( s.width/2-150, s.height/2 + 250);
    
    sevenDayLabel = [CCLabelTTF labelWithString:@"Seven Days" fontName:@"Marker Felt" fontSize:26];
    [self addChild:sevenDayLabel z:0];
    [sevenDayLabel setColor:ccc3(200,200,200)];
    sevenDayLabel.position = ccp( s.width/2+150, s.height/2 + 250);
    
    
    NSArray *topToday = [[RWLeaderBoard shared] top:[[NSNumber alloc] initWithInt: 10] forlast:[[NSNumber alloc] initWithInt: 1] in:[RWParseLeaderBoardEngine class]];
    
    NSMutableString *todayScoreString = [[NSMutableString alloc] init];
    for (RWScore *score in topToday) {
      [todayScoreString appendFormat:@"%@\n", [score description]];
    }
    
    oneDayScores = [CCLabelTTF labelWithString:todayScoreString fontName:@"Marker Felt" fontSize:16];
    [self addChild:oneDayScores z:0];
    [oneDayScores setColor:ccc3(200,200,200)];
    oneDayScores.position = ccp( s.width/2-150, s.height/2 + 100);
    
    NSArray *topWeek= [[RWLeaderBoard shared] top:[[NSNumber alloc] initWithInt: 10] forlast:[[NSNumber alloc] initWithInt: 7] in:[RWParseLeaderBoardEngine class]];
    
    NSMutableString *weekScoreString = [[NSMutableString alloc] init];
    for (RWScore *score in topWeek) {
      [weekScoreString appendFormat:@"%@\n", [score description]];
    }
    
    sevenDayScores = [CCLabelTTF labelWithString:weekScoreString fontName:@"Marker Felt" fontSize:16];
    [self addChild:sevenDayScores z:0];
    [sevenDayScores setColor:ccc3(200,200,200)];
    sevenDayScores.position = ccp( s.width/2+150, s.height/2 + 100);
    
  }
  
  return self;
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [[CCDirector sharedDirector] popScene];
}


@end
