//
//  IntroScene.m
//  Brick Break
//
//  Created by Christopher Rockwell on 8/12/14.
//  Copyright Christopher Rockwell 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "MainScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Brick Break label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Brick Break" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // main scene button
    CCButton *playButton = [CCButton buttonWithTitle:@"[ Play ]" fontName:@"Verdana-Bold" fontSize:20.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.35f);
    [playButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:playButton];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
