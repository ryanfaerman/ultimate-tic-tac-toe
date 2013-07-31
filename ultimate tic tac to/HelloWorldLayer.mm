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
#import "RWBoard.h"
#import "RWPlayerX.h"
#import "RWPlayerO.h"

#import "RWGame.h"

enum {
	kTagParentNode = 1,
};

CCSprite *player_x;
CCSprite *player_o;
CCSprite *board;

CCSprite *o_source;
CCSprite *x_source;

CCSprite *moving_target;
CCLabelTTF *spacesLeft;


NSMutableArray *boardMap;

NSMutableArray *masterGameBoard;

BOOL is_x_turn = YES;
BOOL first_contact = YES;
BOOL game_over = NO;
BOOL paused = NO;
int spaces_left = 81;

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
    
    
    boardMap = [[NSMutableArray alloc] initWithCapacity:81];
    for (int i = 1; i <= 81; i++) {
      [boardMap addObject:@"-"];
    }
    
    masterGameBoard = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i = 1; i <= 9; i++) {
      [masterGameBoard addObject:@"-"];
    }
		
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
    
    CCLabelTTF *spacesLeft = [CCLabelTTF labelWithString:@"81" fontName:@"Marker Felt" fontSize:32];
		[self addChild:spacesLeft z:0];
		[spacesLeft setColor:ccc3(0,0,255)];
		spacesLeft.position = ccp( 70, s.height-50);
    
    
    o_source = [CCSprite spriteWithFile:@"12-o@2x.png"];
    o_source.position = ccp(70, 350);
    [self addChild:o_source];
    x_source = [CCSprite spriteWithFile:@"11-x@2x.png"];
    x_source.position = ccp(70, 450);
    [self addChild:x_source];
    
    RWBoard *board = [[RWBoard alloc] init];
    NSLog(@"WELCOME TO THE BOARD:%@", board);
    [board playPosition:0 withPlayer:[RWPlayerX class]];
    [board playPosition:1 withPlayer:[RWPlayerX class]];
    [board playPosition:2 withPlayer:[RWPlayerX class]];
    NSLog(@"And the Winner is: %@", [board winner]);
    
    RWGame *theGame = [[RWGame alloc] init];
    NSLog(@"WELCOME TO THE GAME:%@", theGame);
    [theGame playPosition:0 onBoard:0 withPlayer:[RWPlayerX class]];
    [theGame playPosition:0 onBoard:1 withPlayer:[RWPlayerX class]];
    [theGame playPosition:0 onBoard:2 withPlayer:[RWPlayerX class]];
    
    [theGame playPosition:1 onBoard:0 withPlayer:[RWPlayerX class]];
    [theGame playPosition:1 onBoard:1 withPlayer:[RWPlayerX class]];
    [theGame playPosition:1 onBoard:2 withPlayer:[RWPlayerX class]];
    
    [theGame playPosition:2 onBoard:0 withPlayer:[RWPlayerX class]];
    [theGame playPosition:2 onBoard:1 withPlayer:[RWPlayerX class]];
    [theGame playPosition:2 onBoard:2 withPlayer:[RWPlayerX class]];
    
    NSLog(@"And the Winner is: %@", [theGame winner]);
    
		
		
		
//    // IMPORTANT:
//    // The sprite frames will be cached AND RETAINED, and they won't be released unless you call
//    //     [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
//    //NOTE:
//    //The name of your .png and .plist must be the same name
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"foo.plist"];
//    //
//    // Animation using Sprite Sheet
//    //
//    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"smoke1.png"]; //"grossini_dance_01.png" comes from your .plist file
//    sprite.position = ccp( s.width/2-80, s.height/2);
//    
//    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"foo.png"];
//    [batchNode addChild:sprite];
//    [self addChild:batchNode];
//    
//    
//    NSMutableArray *animFrames = [NSMutableArray array];
//    for(int i = 1; i < 5; i++) {
//      
//      CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"smoke%d.png",i]];
//      [animFrames addObject:frame];
//    }
//    CCAnimation *animation = [CCAnimation animation];
//    [sprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
//    
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Fuelship_Syphus.mp3"];
//    [CDAudioManager sharedManager].backgroundMusic.volume = 0.2f;
		

		[self scheduleUpdate];
	}
	return self;
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
  
  int board_x = (int)(location.x - 145)/250;
  int board_y = (int)(location.y - 8)/250;
  int sub_x = (int)((location.x - 145)/82)%3;
  int sub_y = (int)((location.y - 8)/82)%3;
  int grid_x = (int)(location.x - 145)/82;
  int grid_y = (int)(location.y - 8)/82;
  int locator = grid_y*9 + grid_x;
  int boardNum = 3*board_y + board_x;
  
//  NSLog(@"I love it when you touch me here: (%f, %f)", location.x, location.y);
//  NSLog(@"in square: (%d, %d)", grid_x, grid_y);
//  NSLog(@"relative square: (%d, %d)", sub_x, sub_y);
  NSLog(@"in board: %d", boardNum);
//  NSLog(@"(%d, %d) = %d => %@", grid_x, grid_y, locator, [boardMap objectAtIndex: locator]);
//  NSLog(@"board: (%d, %d), locator: %d", board_x, board_y, locator);
  
  NSString *desiredSquare = [boardMap objectAtIndex: locator];
  if (![desiredSquare isEqual: @"-"]) {
    return;
  }
  
  if(!CGRectIntersectsRect(boardRect, pointRect)) {
    return;
  }
  
  if(game_over || paused) {
    return;
  }
    
  CCSprite *player;
  spaces_left--;
  NSString *spacesString = [[NSString alloc] initWithFormat:@"%d", spaces_left ];

  
  if (is_x_turn) {
    player = [CCSprite spriteWithFile:@"11-x@2x.png"];
    player.position = ccp(70, 450);
    player_x = player;
//    boardMap[board_y][board_x][sub_y][sub_x] = @"x";
    [boardMap setObject:@"x" atIndexedSubscript:locator];
    
  } else {
    player = [CCSprite spriteWithFile:@"12-o@2x.png"];
    player.position = ccp(70, 350);
//    boardMap[board_y][board_x][sub_y][sub_x] = @"o";
    [boardMap setObject:@"o" atIndexedSubscript:locator];
  }
  
  is_x_turn = !is_x_turn;
  [self addChild:player];
  
  id move = [CCMoveTo actionWithDuration:0.3f position:location];
  id wrapperAction = [CCCallFunc actionWithTarget:self selector:@selector(actionComplete)];
  [player runAction: [CCSequence actions:move, wrapperAction, nil]];
  
  NSString *winner = [self winnerForBoard:board_x By:board_y];
//  NSLog(@"board %d won by %@", boardNum, winner);
  if(![winner isEqual:@"-"]) {
    CCSprite *winnerMarker;
    
    [masterGameBoard setObject:winner atIndexedSubscript:boardNum];
    
    if([winner isEqual:@"x"]) {
      winnerMarker = [CCSprite spriteWithFile:@"winner-x.png"];
    } else {
      winnerMarker = [CCSprite spriteWithFile:@"winner-o.png"];
    }
    winnerMarker.position = ccp(250*board_x + 125 + 145, 250*board_y+125);
    [self addChild:winnerMarker];
  }
  
  NSString *gameWinner = [self winnerForGame];
  if(![gameWinner isEqual:@"-"]) {
    
    NSString *winnerString;
    game_over = YES;
    if([winner isEqual:@"x"]) {
      winnerString = @"X won!";
    } else {
      winnerString = @"O won!";
    }
    
    CGSize s = [CCDirector sharedDirector].winSize;
    CCLabelTTF *label = [CCLabelTTF labelWithString:winnerString fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);
  }
  
  
}

-(void) actionComplete
{
  
  [[SimpleAudioEngine sharedEngine] playEffect:@"thid.mp3"];

  
}

- (int) boardFromBoardX:(int)Bx By:(int)By
{
  return 3*By + Bx;
}

- (int) gridFromBoardX:(int)Bx By:(int)By
{
  return 27*By + 3*Bx;
}

- (NSString *) winnerForGame
{
  NSString *winner = @"-";
  
  NSString *A = [masterGameBoard objectAtIndex:0];
  NSString *B = [masterGameBoard objectAtIndex:1];
  NSString *C = [masterGameBoard objectAtIndex:2];
  
  NSString *D = [masterGameBoard objectAtIndex:3];
  NSString *E = [masterGameBoard objectAtIndex:4];
  NSString *F = [masterGameBoard objectAtIndex:5];
  
  NSString *G = [masterGameBoard objectAtIndex:6];
  NSString *H = [masterGameBoard objectAtIndex:7];
  NSString *I = [masterGameBoard objectAtIndex:8];
  
  NSLog(@"\n %@ %@ %@ \n %@ %@ %@ \n %@ %@ %@ \n", A, B, C, D, E, F, G, H, I);
  
  NSString *R1 = [self winnerForTriplet:A b:B c:C];
  NSString *R2 = [self winnerForTriplet:D b:E c:F];
  NSString *R3 = [self winnerForTriplet:G b:H c:I];
  
  NSString *C1 = [self winnerForTriplet:A b:D c:G];
  NSString *C2 = [self winnerForTriplet:B b:E c:H];
  NSString *C3 = [self winnerForTriplet:C b:F c:I];
  
  NSString *D1 = [self winnerForTriplet:A b:E c:I];
  NSString *D2 = [self winnerForTriplet:C b:E c:G];
  
  if([R1 isEqual:@"x"] || [R2 isEqual:@"x"] || [R3 isEqual:@"x"] || [C1 isEqual:@"x"] || [C2 isEqual:@"x"] || [C3 isEqual:@"x"] || [D1 isEqual:@"x"] || [D2 isEqual:@"x"]) {
    winner = @"x";
  } else if ([R1 isEqual:@"o"] || [R2 isEqual:@"o"] || [R3 isEqual:@"o"] || [C1 isEqual:@"o"] || [C2 isEqual:@"o"] || [C3 isEqual:@"o"] || [D1 isEqual:@"o"] || [D2 isEqual:@"o"]) {
    winner = @"o";
  };
  
  
  return winner;
}

- (NSString*) winnerForBoard:(int)Bx By:(int)By
{
  NSString *winner = @"-";
  
  //board array ids
  int a = [self gridFromBoardX:Bx By:By];
  int b = a + 1;
  int c = a + 2;
  
  int d = a + 9;
  int e = b + 9;
  int f = c + 9;
  
  int g = d + 9;
  int h = e + 9;
  int i = f + 9;
  
  NSString *A = [boardMap objectAtIndex:a];
  NSString *B = [boardMap objectAtIndex:b];
  NSString *C = [boardMap objectAtIndex:c];
  
  NSString *D = [boardMap objectAtIndex:d];
  NSString *E = [boardMap objectAtIndex:e];
  NSString *F = [boardMap objectAtIndex:f];
  
  NSString *G = [boardMap objectAtIndex:g];
  NSString *H = [boardMap objectAtIndex:h];
  NSString *I = [boardMap objectAtIndex:i];
  
  NSLog(@"\n %@ %@ %@ \n %@ %@ %@ \n %@ %@ %@ \n", A, B, C, D, E, F, G, H, I);
  
  NSString *R1 = [self winnerForTriplet:A b:B c:C];
  NSString *R2 = [self winnerForTriplet:D b:E c:F];
  NSString *R3 = [self winnerForTriplet:G b:H c:I];
  
  NSString *C1 = [self winnerForTriplet:A b:D c:G];
  NSString *C2 = [self winnerForTriplet:B b:E c:H];
  NSString *C3 = [self winnerForTriplet:C b:F c:I];
  
  NSString *D1 = [self winnerForTriplet:A b:E c:I];
  NSString *D2 = [self winnerForTriplet:C b:E c:G];
  
  if([R1 isEqual:@"x"] || [R2 isEqual:@"x"] || [R3 isEqual:@"x"] || [C1 isEqual:@"x"] || [C2 isEqual:@"x"] || [C3 isEqual:@"x"] || [D1 isEqual:@"x"] || [D2 isEqual:@"x"]) {
    winner = @"x";
  } else if ([R1 isEqual:@"o"] || [R2 isEqual:@"o"] || [R3 isEqual:@"o"] || [C1 isEqual:@"o"] || [C2 isEqual:@"o"] || [C3 isEqual:@"o"] || [D1 isEqual:@"o"] || [D2 isEqual:@"o"]) {
    winner = @"o";
  };
  
  
  return winner;
}

- (NSString*) winnerForTriplet:(NSString *)A b:(NSString *)B c:(NSString *)C
{
  NSString *winner = @"-";
  if ([A isEqual:B] && [B isEqual:C]) {
    if ([A isEqual:@"x"]) {
      winner = @"x";
      NSLog(@"winner x");
    } else if ([A isEqual:@"o"]) {
      winner = @"o";
      NSLog(@"winner o");
    }
  }
  return winner;
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
