//
//  GameOverLayer.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/1/13.
//  Copyright 2013 Ryan Faerman. All rights reserved.
//

#import "GameOverLayer.h"
#import "RWGame.h"

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
		label.position = ccp( s.width/2, s.height/2);
    
    CCLabelTTF *directions = [CCLabelTTF labelWithString:@"Touch Anywhere to Play Again" fontName:@"Marker Felt" fontSize:26];
		[self addChild:directions z:0];
		[directions setColor:ccc3(200,200,200)];
		directions.position = ccp( s.width/2, s.height/2-80);
    
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
  [[RWGame sharedGame] reset];
  [[CCDirector sharedDirector] popScene];
}

@end
