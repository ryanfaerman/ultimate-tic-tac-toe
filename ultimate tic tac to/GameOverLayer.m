//
//  GameOverLayer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/1/13.
//  Copyright 2013 Ryan Faerman. All rights reserved.
//

#import "GameOverLayer.h"
#import "RWGame.h"
#import "RWGameTimer.h"
#import "RWPlayerO.h"
#import "RWPlayerX.h"
#import "RWPlayTimer.h"
#import "RWLeaderBoard.h"

CCLabelTTF *shareButtonLabel;

@implementation GameOverLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameOverLayer *layer = [GameOverLayer node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    self.touchEnabled = YES;
    [self scheduleUpdate];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    
    NSString *winner = [[NSString alloc] initWithFormat:@"%@ Won", [[RWGame sharedGame] winner]];
    CCLabelTTF *label = [CCLabelTTF labelWithString:winner fontName:@"Marker Felt" fontSize:52];
		[self addChild:label z:0];
		[label setColor:ccc3(200,200,200)];
		label.position = ccp( s.width/2, s.height/2+50);
    
    CCLabelTTF *directions = [CCLabelTTF labelWithString:@"Touch Anywhere to Play Again" fontName:@"Marker Felt" fontSize:26];
		[self addChild:directions z:0];
		[directions setColor:ccc3(130,130,130)];
		directions.position = ccp( s.width/2, s.height/2-100);
    
    RWPlayTimer *xTimer = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerX class]];
    NSString *xTime = [[NSString alloc] initWithFormat:@"X playtime %@", [xTimer description]];
    CCLabelTTF *xTimerLabel = [CCLabelTTF labelWithString:xTime fontName:@"Marker Felt" fontSize:18];
    [self addChild:xTimerLabel z:0];
    [xTimerLabel setColor:ccc3(180,180,180)];
    xTimerLabel.position = ccp( s.width/2-80, s.height/2-5);
    
    
    RWPlayTimer *oTimer = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerO class]];
    NSString *oTime = [[NSString alloc] initWithFormat:@"O playtime %@", [oTimer description]];
    CCLabelTTF *oTimerLabel = [CCLabelTTF labelWithString:oTime fontName:@"Marker Felt" fontSize:18];
    [self addChild:oTimerLabel z:0];
    [oTimerLabel setColor:ccc3(180,180,180)];
    oTimerLabel.position = ccp( s.width/2+80, s.height/2-5);
    
    NSString *timeWinnerString = [[NSString alloc] initWithFormat:@"%@ is the faster player", [[[RWGameTimer sharedTimers] winner] description]];
    CCLabelTTF *timeWinner = [CCLabelTTF labelWithString:timeWinnerString fontName:@"Marker Felt" fontSize:18];
    [self addChild:timeWinner z:0];
    [timeWinner setColor:ccc3(190,190,190)];
    timeWinner.position = ccp( s.width/2, s.height/2-35);
    
    shareButtonLabel= [CCLabelTTF labelWithString:@"Tweet this epic game!" fontName:@"Marker Felt" fontSize:18];
    [self addChild:shareButtonLabel z:0];
    [shareButtonLabel setColor:ccc3(190,190,190)];
    shareButtonLabel.position = ccp( s.width/2, s.height/2-65);
    
    NSLog(@"fastest player: %@", [[RWGameTimer sharedTimers] winner]);
    
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
  CGPoint location = [self convertTouchToNodeSpace: touch];
  CGRect pointRect = CGRectMake(location.x, location.y, 1.0f, 1.0f);
  
  
  if(CGRectIntersectsRect([shareButtonLabel boundingBox], pointRect)) {
    NSString *urlString = [[[NSString alloc] initWithFormat:@"https://twitter.com/intent/tweet?text=%@ just beat %@ with a score of %@ in Ultimate Tic Tac Toe! http://www.fullsail.edu", [[[RWGameTimer sharedTimers] winner] description], [[[RWGameTimer sharedTimers] loser] description], [RWLeaderBoard shared].lastScore.value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL: url];
    return;
  }
  [[RWGame sharedGame] reset];
  [[CCDirector sharedDirector] popScene];
}

@end
