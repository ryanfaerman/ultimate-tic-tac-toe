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

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
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
		
		// enable events
		
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
		
    //Set up sprites
		player_x = [CCSprite spriteWithFile:@"11-x@2x.png"];
    player_x.position = ccp(50, 100);
    [self addChild:player_x];
    
    player_o = [CCSprite spriteWithFile:@"12-o@2x.png"];
    player_o.position = ccp(200, 300);
    [self addChild:player_o];
    
    [self schedule:@selector(nextFrame:)];
		
		
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Fuelship_Syphus.mp3"];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.3f;
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) nextFrame:(ccTime)dt
{
  player_o.position = ccp(player_o.position.x + 100*dt, player_o.position.y);
  if (player_o.position.x > [[CCDirector sharedDirector] winSize].width + 32) {
    player_o.position = ccp(-32, player_o.position.y);
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
  
	[player_x stopAllActions];
	[player_x runAction: [CCMoveTo actionWithDuration:0.2f position:location]];
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
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
