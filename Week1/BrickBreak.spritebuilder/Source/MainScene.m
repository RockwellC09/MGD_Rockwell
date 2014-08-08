//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

CCSprite *_player;
CCSprite *_brick;
CCSprite *_brick2;
CCSprite *_ball;
CCPhysicsNode *_physicsWorld;
int height;
int width;
bool collided;
CCSprite *_bound1;
CCSprite *_bound2;
bool first;

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    first = true;
    
    // get screen size
    CGSize s = [[CCDirector sharedDirector] viewSize];
    width = s.width;
    height = s.height;
    
    // create a colored background (Dark Grey)
    CCPhysicsNode *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:background];
    [background addChild:_physicsWorld];
    
    // add player sprites
    _player = [CCSprite spriteWithImageNamed:@"arrow.png"];
    _player.position  = ccp(width/2,10);
    [_physicsWorld addChild:_player];
    [self rotateRight];
    
    _brick = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick.position  = ccp(35, height - 10);
    _brick.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _brick.contentSize} cornerRadius:0];
    _brick.physicsBody.collisionGroup = @"brickGroup";
    _brick.physicsBody.collisionType  = @"brickCollision";
    [_physicsWorld addChild:_brick];
    [self moveRight];
    
    // add ball sprite
    _ball = [CCSprite spriteWithImageNamed:@"ball.png"];
    _ball.scale = .2f;
    _ball.position  = ccp(width / 2, 50);
    _ball.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ball.contentSize} cornerRadius:0];
    _ball.physicsBody.collisionGroup = @"ballGroup";
    _ball.physicsBody.collisionType  = @"ballCollision";
    [_physicsWorld addChild:_ball];
    
    // add boundary markers
    _bound1 = [CCSprite spriteWithImageNamed:@"boundary1.png"];
    _bound1.position  = ccp(0, height / 2);
    [_physicsWorld addChild:_bound1];
    
    _bound2 = [CCSprite spriteWithImageNamed:@"boundary1.png"];
    _bound2.position  = ccp(width, height / 2);
    [_physicsWorld addChild:_bound2];
    
    // create a dummy brick to get the location to launch the ball(s)
    _brick2 = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick2.position  = ccp(width / 2, -20);
    [_physicsWorld addChild:_brick2];
    [self moveRight2];
    
    // done
	return self;
}

// handle screen tap
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // access audio object
    OALSimpleAudio *audioObj = [OALSimpleAudio sharedInstance];
    // play sound
    [audioObj playEffect:@"shot.wav"];
    
    // Move our sprite to proper location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(_brick2.position.x, height)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [_ball removeFromParent];
        _ball = [CCSprite spriteWithImageNamed:@"ball.png"];
        _ball.scale = .2f;
        _ball.position  = ccp(width / 2, 50);
        _ball.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ball.contentSize} cornerRadius:0];
        _ball.physicsBody.collisionGroup = @"ballGroup";
        _ball.physicsBody.collisionType  = @"ballCollision";
        [_physicsWorld addChild:_ball];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_ball runAction:seq];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair brickCollision:(CCNode *)brick ballCollision:(CCNode *)ball {
    collided = true;
    // access audio object
    OALSimpleAudio *audioObj = [OALSimpleAudio sharedInstance];
    // play sound
    [audioObj playEffect:@"break.wav"];
    [_brick removeFromParent];
    _brick = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick.position  = ccp(35, height - 10);
    _brick.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _brick.contentSize} cornerRadius:0];
    _brick.physicsBody.collisionGroup = @"brickGroup";
    _brick.physicsBody.collisionType  = @"brickCollision";
    [_physicsWorld addChild:_brick];
    [self moveRight];
    return YES;
}

// move brick to the left
-(void)moveLeft {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:2.0f position:ccp(35, height - 10)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveRight];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick runAction:seq];
}

// move the brick to the right
-(void)moveRight {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:2.0f position:ccp(width - 35, _brick.position.y)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveLeft];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick runAction:seq];
}

// move the dummy brick to the left
-(void)moveLeft2 {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(width/2 - 280,_brick2.position.y)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveRight2];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick2 runAction:seq];
}

// move the dummy brick to the right
-(void)moveRight2 {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(width/2 + 280, _brick2.position.y)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveLeft2];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick2 runAction:seq];
}

// rotate the arrow to the right
-(void)rotateRight {
    CCActionRotateBy *rotatePlayer;
    if (first) {
        rotatePlayer = [CCActionRotateBy actionWithDuration:1.0f angle:45];
        first = false;
    } else {
        rotatePlayer = [CCActionRotateBy actionWithDuration:1.0f angle:90];
    }
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self rotateLeft];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rotatePlayer, actionAfterMove]];
    [_player runAction:seq];
}

// rotate the arrow to the left
-(void)rotateLeft {
    CCActionRotateBy *rotatePlayer = [CCActionRotateBy actionWithDuration:1.0f angle:-90];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self rotateRight];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rotatePlayer, actionAfterMove]];
    [_player runAction:seq];
}

@end
