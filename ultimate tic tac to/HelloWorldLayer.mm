//
//  HelloWorldLayer.mm
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/10/13.
//  Copyright Ryan Faerman 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
#import "MenuLayer.h"
#import "GameOverLayer.h"

#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "RWBoard.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"
#import "RWStalemate.h"

#import "RWGame.h"
#import "RWPositionHelper.h"
#import "RWPhonePositionHelper.h"
#import "RWAssetHelper.h"
#import "RWPhoneAssetHelper.h"
#import "RWGameTimer.h"
#import "RWPlayTimer.h"

#import "RWLeaderBoard.h"
#import "RWLocalLeaderBoardEngine.h"
#import "RWParseLeaderBoardEngine.h"

enum {
	kTagParentNode = 1,
  kTagPlayerToken = 2,
  kTagIndicatorToken = 3,
};

CCSprite *player_x;
CCSprite *player_o;
CCSprite *board;

CCSprite *o_source;
CCSprite *x_source;
CCSprite *boardIndicator;
CCSprite *playerIndicator;

CCSprite *pauseButton;

Class PositionHelper;
Class AssetHelper;

CCLabelTTF *xTimerLabel;
CCLabelTTF *oTimerLabel;

RWGame *Game;


BOOL game_over = NO;
BOOL paused = NO;

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()

@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
      /* Device is iPad */
      PositionHelper = [RWPositionHelper class];
      AssetHelper = [RWAssetHelper class];
    } else {
      PositionHelper = [RWPhonePositionHelper class];
      AssetHelper = [RWPhoneAssetHelper class];
    }
    
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		//Set up background
    
    CCSprite* bg = [CCSprite spriteWithFile:@"retina_wood.png"
                                       rect:CGRectMake(0, 0, s.width, s.height)];
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [bg.texture setTexParameters:&params];
    [bg setPosition:ccp(s.width * 0.5f, s.height * 0.5f)];
    [self addChild:bg];
		
    board = [CCSprite spriteWithFile:[AssetHelper board]];
    board.position = ccp([PositionHelper boardSprite].x, [PositionHelper boardSprite].y);
    [self addChild:board];
    
    
    o_source = [CCSprite spriteWithFile:[AssetHelper playerO]];
    o_source.position = ccp([PositionHelper playerOSource].x, [PositionHelper playerOSource].y);
    [self addChild:o_source];
    x_source = [CCSprite spriteWithFile:[AssetHelper playerX]];
    x_source.position = ccp([PositionHelper playerXSource].x, [PositionHelper playerXSource].y);
    [self addChild:x_source];
    
    boardIndicator = [CCSprite spriteWithFile:[AssetHelper boardIndicator]];
    boardIndicator.position = ccp(-1000, -1000);
    [self addChild:boardIndicator];
    
    playerIndicator = [CCSprite spriteWithFile:[AssetHelper playerIndicator]];
    playerIndicator.position = ccp([PositionHelper currentPlayerIndicator].x, [PositionHelper currentPlayerIndicator].y);
    [self addChild:playerIndicator];
    
    pauseButton = [CCSprite spriteWithFile:[AssetHelper pauseButton]];
    pauseButton.position = ccp([PositionHelper pauseButtonLocation].x, [PositionHelper pauseButtonLocation].y);
    [self addChild:pauseButton];
    
    
    xTimerLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Marker Felt" fontSize:18];
    [self addChild:xTimerLabel z:0];
    [xTimerLabel setColor:ccc3(30,30,30)];
    xTimerLabel.position = ccp( [PositionHelper playerXSource].x, [PositionHelper playerXSource].y - 25);
    
    oTimerLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Marker Felt" fontSize:18];
    [self addChild:oTimerLabel z:0];
    [oTimerLabel setColor:ccc3(100,100,100)];
    oTimerLabel.position = ccp( [PositionHelper playerOSource].x, [PositionHelper playerOSource].y - 25);
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardWon:) name:@"RWBoardWon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameWon:) name:@"RWGameWon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameReset:) name:@"RWGameReset" object:nil];
    
    Game = [RWGame sharedGame];
        
    [self schedule: @selector(ticktock:) interval:1];
		[self scheduleUpdate];
	}
	return self;
}

- (void)ticktock:(ccTime) dt
{
  [[RWGameTimer sharedTimers] tick];
  RWPlayTimer *xTime = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerX class]];
  RWPlayTimer *oTime = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[RWPlayerO class]];
  
  [xTimerLabel setString:[xTime description]];
  [oTimerLabel setString:[oTime description]];
}

- (void) gameReset:(NSNotification *)notification
{
  // board offscreen
  boardIndicator.position = ccp(-1000, -1000);
  
  // x goes first
  playerIndicator.position = ccp([PositionHelper currentPlayerIndicator].x, [PositionHelper currentPlayerIndicator].y);
  
  // whack all tokens
  while([self getChildByTag:kTagPlayerToken] != nil) {
    [self removeChildByTag:kTagPlayerToken cleanup:YES];
  }
  
  // whack all indicators
  while([self getChildByTag:kTagIndicatorToken] != nil) {
    [self removeChildByTag:kTagIndicatorToken cleanup:YES];
  }
  
  // reset clocks
  [[RWGameTimer sharedTimers] resetAll];
  
  // reset clock labels
  [xTimerLabel setColor:ccc3(30,30,30)];
  [oTimerLabel setColor:ccc3(100,100,100)];
  
  [xTimerLabel setString:@"00:00"];
  [oTimerLabel setString:@"00:00"];
}

- (void) boardWon:(NSNotification *)notification
{
  int winnerBoard = [[Game board] indexOfObject:[notification object]];
  
  CGPoint indicatorLocation = ccp(([PositionHelper boardCenterPointForBoard:winnerBoard].x + [PositionHelper boardIndicatorSpriteOffset].x), ([PositionHelper boardCenterPointForBoard:winnerBoard].y + [PositionHelper boardIndicatorSpriteOffset].y));
  
  RWBoard *board = [notification object];
  
  if (![[board boardWinner] isClass:[RWStalemate class]]) {
    CCSprite *winnerToken;
    NSLog(@"winner is: %@", [board boardWinner]);
    if ([[board boardWinner] isClass:[RWPlayerX class]]) {
      winnerToken = [CCSprite spriteWithFile:[AssetHelper playerXWinner]];
    } else {
      winnerToken = [CCSprite spriteWithFile:[AssetHelper playerOWinner]];
    }
    
    winnerToken.position = indicatorLocation;
    winnerToken.tag = kTagIndicatorToken;
    [self addChild:winnerToken];
  } else {
    NSLog(@"stalemate... poor baby");
  }
  
  
  
  NSLog(@"board %d was won!", winnerBoard);
}

- (void) gameWon:(NSNotification *)notification
{
  RWPlayTimer *playTimer = [[[RWGameTimer sharedTimers] playTimers] objectForKey:[[[RWGameTimer sharedTimers] winner] class]];
  
  RWScore *score = [[RWScore alloc] init];
  score.value = [[NSNumber alloc] initWithInt: playTimer.tickCount];
  score.player = [[RWGameTimer sharedTimers] winner];
  [[RWLeaderBoard shared] push:score];
  
  NSLog(@"GAME OVER. %@ won.", [[notification object] winner]);
  [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.3 scene:[GameOverLayer scene]]];
  
}


-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [[SimpleAudioEngine sharedEngine] playEffect:@"thud.mp3"];
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
  
  NSLog(@"(%f, %f)", location.x, location.y);
  
  CGRect boardRect = [board boundingBox];
  CGRect pointRect = CGRectMake(location.x, location.y, 1.0f, 1.0f);
  
  if(CGRectIntersectsRect([pauseButton boundingBox], pointRect)) {
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.3 scene:[MenuLayer scene]]];
    return;
  }
  
  if(!CGRectIntersectsRect(boardRect, pointRect)) {
//    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.3 scene:[GameOverLayer scene]]];
    return;
  }
  
  if(game_over || paused) {
    return;
  }

  CGPoint tokenLocation = ccp(([PositionHelper positionCenterPointForLocation:location].x + [PositionHelper playerSpriteOffset].x), ([PositionHelper positionCenterPointForLocation:location].y + [PositionHelper playerSpriteOffset].y));
  
  int indicatorY = 0;
  CCSprite *player;
  if ([Game currentPlayer] == [RWPlayerX class]) {
    player = [CCSprite spriteWithFile:[AssetHelper playerX]];
    player.position = ccp([PositionHelper playerXSource].x, [PositionHelper playerXSource].y);
    indicatorY = [PositionHelper playerOSource].y;
    
    [xTimerLabel setColor:ccc3(100,100,100)];
    [oTimerLabel setColor:ccc3(30,30,30)];
  } else {
    player = [CCSprite spriteWithFile:[AssetHelper playerO]];
    player.position = ccp([PositionHelper playerOSource].x, [PositionHelper playerOSource].y);
    indicatorY = [PositionHelper playerXSource].y;
    
    [oTimerLabel setColor:ccc3(100,100,100)];
    [xTimerLabel setColor:ccc3(30,30,30)];
  }
  
  player.tag = kTagPlayerToken;
  
  if([Game playPosition:[PositionHelper positionNumberFromLocation:location] onBoard:[PositionHelper boardNumberFromLocation:location] withPlayer:[Game currentPlayer]]) {
    [self addChild:player];
    
    id move = [CCMoveTo actionWithDuration:0.3f position:tokenLocation];
    id wrapperAction = [CCCallFunc actionWithTarget:self selector:@selector(actionComplete)];
    [player runAction: [CCSequence actions:move, wrapperAction, nil]];
    
    
    CGPoint indicatorLocation = ccp(([PositionHelper boardCenterPointForBoard:[Game nextBoard]].x + [PositionHelper boardIndicatorSpriteOffset].x), ([PositionHelper boardCenterPointForBoard:[Game nextBoard]].y + [PositionHelper boardIndicatorSpriteOffset].y));

    if ([Game nextIsPlayable]) {
      [boardIndicator runAction:[CCMoveTo actionWithDuration:0.3f position:indicatorLocation]];
    } else {
      boardIndicator.position = ccp(-1000, -1000);
    }
    
    [playerIndicator runAction:[CCMoveTo actionWithDuration:0.3f position:ccp([PositionHelper currentPlayerIndicator].x, indicatorY)]];
    
  }
  
}

-(void) actionComplete
{
  [[SimpleAudioEngine sharedEngine] playEffect:@"thid.mp3"];
}



#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) dealloc
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end
