//
//  MenuLayer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/1/13.
//  Copyright 2013 Ryan Faerman. All rights reserved.
//

#import "MenuLayer.h"
#import "RWGame.h"
#import "CreditsOverlay.h"
//#import "HelloWorldLayer.h"


CCLabelTTF *resumeLabel;
CCLabelTTF *newLabel;
CCLabelTTF *creditsLabel;
CCLabelTTF *rulesLabel;

@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    self.touchEnabled = YES;
    [self scheduleUpdate];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    
    if([[RWGame sharedGame] isPlaying]) {
      resumeLabel = [CCLabelTTF labelWithString:@"Resume your Game" fontName:@"Marker Felt" fontSize:26];
      [self addChild:resumeLabel z:0];
      [resumeLabel setColor:ccc3(200,200,200)];
      resumeLabel.position = ccp( s.width/2, s.height/2 + 100);
      
    }
    
    newLabel = [CCLabelTTF labelWithString:@"Start a New Game" fontName:@"Marker Felt" fontSize:26];
    [self addChild:newLabel z:0];
    [newLabel setColor:ccc3(200,200,200)];
    newLabel.position = ccp( s.width/2, s.height/2 + 50);
    
    creditsLabel = [CCLabelTTF labelWithString:@"Credits" fontName:@"Marker Felt" fontSize:26];
    [self addChild:creditsLabel z:0];
    [creditsLabel setColor:ccc3(200,200,200)];
    creditsLabel.position = ccp( s.width/2, s.height/2);
    
    rulesLabel = [CCLabelTTF labelWithString:@"Rules" fontName:@"Marker Felt" fontSize:26];
    [self addChild:rulesLabel z:0];
    [rulesLabel setColor:ccc3(200,200,200)];
    rulesLabel.position = ccp( s.width/2, s.height/2-50);
    
    
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
  
  NSLog(@"(%f, %f)", location.x, location.y);
  
  CGRect resumeRect = [resumeLabel boundingBox];
  CGRect newRect = [newLabel boundingBox];
  CGRect creditsRect = [creditsLabel boundingBox];
  CGRect pointRect = CGRectMake(location.x, location.y, 1.0f, 1.0f);
  
  if(CGRectIntersectsRect(resumeRect, pointRect) && [[RWGame sharedGame] isPlaying]) {
    [[CCDirector sharedDirector] popScene];
    return;
  }
  
  if(CGRectIntersectsRect([rulesLabel boundingBox], pointRect)) {
    NSURL * url = [NSURL URLWithString:@"http://mathwithbaddrawings.com/2013/06/16/ultimate-tic-tac-toe/"];
    [[UIApplication sharedApplication] openURL: url];
    return;
  }
  
  if(CGRectIntersectsRect(newRect, pointRect)) {
    [[RWGame sharedGame] reset];
    [[CCDirector sharedDirector] popScene];
    return;
  }
  
  if(CGRectIntersectsRect(creditsRect, pointRect)) {
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.3 scene:[CreditsOverlay scene]]];
    return;
  }

  
  
}

@end
