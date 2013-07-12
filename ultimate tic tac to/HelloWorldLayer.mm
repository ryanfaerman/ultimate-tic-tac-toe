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
CCSprite *double_o;

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
		
		// enable events
    
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    _world = new b2World(gravity);
    
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    _world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    m_debugDraw->SetFlags(flags);
		
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
    [self addBoxBodyForSprite:player_x];
    
    player_o = [CCSprite spriteWithFile:@"12-o@2x.png"];
    player_o.position = ccp(200, 300);
    [self addChild:player_o];
    
    double_o = [CCSprite spriteWithFile:@"32-circle-o@2x.png"];
    double_o.position = ccp(200, 400);
    [self addChild:double_o];
    [self addBoxBodyForSprite:double_o];
    
    [self schedule:@selector(nextFrame:)];
		
		
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Fuelship_Syphus.mp3"];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.3f;
		
    [self schedule:@selector(tick:)];
		[self scheduleUpdate];
	}
	return self;
}

- (void)addBoxBodyForSprite:(CCSprite *)sprite {
  
  b2BodyDef spriteBodyDef;
  spriteBodyDef.type = b2_dynamicBody;
  spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                             sprite.position.y/PTM_RATIO);
  spriteBodyDef.userData = sprite;
  b2Body *spriteBody = _world->CreateBody(&spriteBodyDef);
  
  b2PolygonShape spriteShape;
  spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
                       sprite.contentSize.height/PTM_RATIO/2);
  b2FixtureDef spriteShapeDef;
  spriteShapeDef.shape = &spriteShape;
  spriteShapeDef.density = 10.0;
  spriteShapeDef.isSensor = false;
  spriteBody->CreateFixture(&spriteShapeDef);
  
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	_world->DrawDebugData();
	
	kmGLPopMatrix();
}

- (void)tick:(ccTime)dt {
  
  _world->Step(dt, 10, 10);
  for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
    if (b->GetUserData() != NULL) {
      CCSprite *sprite = (CCSprite *)b->GetUserData();
      
      b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                 sprite.position.y/PTM_RATIO);
      float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
      
      b->SetTransform(b2Position, b2Angle);
    }
  }
  
}

-(void) nextFrame:(ccTime)dt
{
  player_o.position = ccp(player_o.position.x + 100*dt, player_o.position.y);
  
  CGRect movingRect = [player_o boundingBox];
  CGRect player = [player_x boundingBox];
  if(CGRectIntersectsRect(movingRect, player)) {
    NSLog(@"ha ha Collision detected");
    [[SimpleAudioEngine sharedEngine] playEffect:@"garble.mp3"];
  }
  
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
  id move = [CCMoveTo actionWithDuration:0.2f position:location];
  id wrapperAction = [CCCallFunc actionWithTarget:self selector:@selector(actionComplete)];
	[player_x runAction: [CCSequence actions:move, wrapperAction, nil]];
  
}

-(void) actionComplete
{
  
  CGRect targetRect = [double_o boundingBox];
  CGRect player = [player_x boundingBox];
  if(CGRectIntersectsRect(targetRect, player)) {
    NSLog(@"ha ha Collision detected");
    [[SimpleAudioEngine sharedEngine] playEffect:@"garble.mp3"];
  } else  {
    [[SimpleAudioEngine sharedEngine] playEffect:@"thid.mp3"];
  }
  
}

-(void) dealloc
{
	delete _world;
	_world = NULL;
	
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
