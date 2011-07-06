//
//  GameScene.h
//  Snake
//
//  Created by Clawoo on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    RIGHT,
    DOWN,
    LEFT,
    UP
} Direction;

typedef struct {
    NSInteger x;
    NSInteger y;
} SnakePiece;

typedef enum {
    GameStateNotStarted,
    GameStateRunning,
    GameStateGameOver,
    GameStateLevelOver,
    GameStatePaused,
} GameState;

@interface GameScene : CCLayer {
    CCLabelTTF *scoreLabel_;
    CCLabelTTF *scoreLabelShadow_;
    CCLabelTTF *levelLabel_;
    CCLabelTTF *levelLabelShadow_;
    NSInteger score_;
    NSInteger level_;
    GameState gameState_;

    CGRect gameAreaRect_;
    CCNode *gameArea_;
    
    NSArray *levels_;
    SnakePiece snake_[20];
    NSMutableArray *snakeSprites_;
    NSInteger snakePieces_;
    
    CCSprite *foodSprite_;
    NSInteger remainingFoodPieces_;

    Direction direction_;
    Direction nextDirection_;
    NSInteger currentSpeed_;
    float accumulator;
}

+ (id)scene;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger level;

@end
