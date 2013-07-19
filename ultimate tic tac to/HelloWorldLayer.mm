//
//  HelloWorldLayer.mm
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 7/10/13.
//  Copyright Ryan Faerman 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


enum {
	kTagParentNode = 1,
};

CCSprite *player_x;
CCSprite *player_o;
CCSprite *board;

CCSprite *o_source;
CCSprite *x_source;

CCSprite *moving_target;

BOOL is_x_turn = YES;
BOOL first_contact = YES;

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
		
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		//Set up background
    
    CCSprite* bg = [CCSprite spriteWithFile:@"retina_wood_@2X.png"
                                       rect:CGRectMake(0, 0, s.width, s.height)];
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    [bg.texture setTexParameters:&params];
    [bg setPosition:ccp(s.width * 0.5f, s.height * 0.5f)];
    [self addChild:bg];
		
    board = [CCSprite spriteWithFile:@"board.png"];
    board.position = ccp(520, 385);
    [self addChild:board];
    
    //Set up sprites
//		player_x = [CCSprite spriteWithFile:@"11-x@2x.png"];
//    player_x.position = ccp(50, 100);
//    [self addChild:player_x];
    
    moving_target = [CCSprite spriteWithFile:@"32-circle-o@2x.png"];
    moving_target.position = ccp(950, 300);
    [self addChild:moving_target];
    
    o_source = [CCSprite spriteWithFile:@"12-o@2x.png"];
    o_source.position = ccp(70, 350);
    [self addChild:o_source];
    x_source = [CCSprite spriteWithFile:@"11-x@2x.png"];
    x_source.position = ccp(70, 450);
    [self addChild:x_source];
    
    
    [self schedule:@selector(nextFrame:)];
    
    
		
		
		
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
//		[self addChild:label z:0];
//		[label setColor:ccc3(0,0,255)];
//		label.position = ccp( s.width/2, s.height-50);
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Fuelship_Syphus.mp3"];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.2f;
		
//    [self schedule:@selector(tick:)];
		[self scheduleUpdate];
	}
	return self;
}

-(void) nextFrame:(ccTime)dt
{
  moving_target.position = ccp(moving_target.position.x + 100*dt, moving_target.position.y);
  
  CGRect movingRect = [moving_target boundingBox];
  CGRect player = [player_x boundingBox];
  if(CGRectIntersectsRect(movingRect, player)) {
    
    if (first_contact == YES) {
      NSLog(@"ha ha Collision detected");
      [[SimpleAudioEngine sharedEngine] playEffect:@"garble.mp3"];
      first_contact = NO;
    }
    
//    
    
  } else {
    first_contact = YES;
  }
  
  
  if (moving_target.position.x > [[CCDirector sharedDirector] winSize].width + 32) {
    moving_target.position = ccp(-32, moving_target.position.y);
  }
  
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
  
  CGRect boardRect = [board boundingBox];
  CGRect pointRect = CGRectMake(location.x, location.y, 1.0f, 1.0f);
  if(!CGRectIntersectsRect(boardRect, pointRect)) {
    return;
  }
    
  CCSprite *player;
  
  if (is_x_turn) {
    player = [CCSprite spriteWithFile:@"11-x@2x.png"];
    player.position = ccp(70, 450);
    player_x = player;
  } else {
    player = [CCSprite spriteWithFile:@"12-o@2x.png"];
    player.position = ccp(70, 350);
  }
  
  is_x_turn = !is_x_turn;
  [self addChild:player];
  
  id move = [CCMoveTo actionWithDuration:0.3f position:location];
  id wrapperAction = [CCCallFunc actionWithTarget:self selector:@selector(actionComplete)];
  [player runAction: [CCSequence actions:move, wrapperAction, nil]];
  
  
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

@end
