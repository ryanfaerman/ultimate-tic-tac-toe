//
//  CreditsOverlay.m
//  ultimate tic tac to
//
//  Created by Ryan Faerman on 8/1/13.
//  Copyright 2013 Ryan Faerman. All rights reserved.
//

#import "CreditsOverlay.h"


@implementation CreditsOverlay
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
  CreditsOverlay *layer = [CreditsOverlay node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
    self.touchEnabled = YES;
    [self scheduleUpdate];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    

    
    CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"I'd like to thank the Academy!\nNot really...\n\nThanks for not failing me Celey\n-Ryan Faerman" fontName:@"Marker Felt" fontSize:26];
    [self addChild:creditsLabel z:0];
    [creditsLabel setColor:ccc3(200,200,200)];
    creditsLabel.position = ccp( s.width/2, s.height/2 + 50);
    
    
    
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
