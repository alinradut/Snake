//
//  GameScene.m
//  Snake
//
//  Created by Clawoo on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameConfig.h"
#import "CCDrawingPrimitives.h"

#define MAX_COLS    25
#define MAX_ROWS    25
#define MAX_SPEED   10
#define BASE_SPEED  0.7

void ccDrawFilledRect( CGPoint v1, CGPoint v2 )
{
	CGPoint poli[]={v1,CGPointMake(v1.x,v2.y),v2,CGPointMake(v2.x,v1.y)};
    
	ccDrawLine(poli[0], poli[1]);
	ccDrawLine(poli[1], poli[2]);
	ccDrawLine(poli[2], poli[3]);
	ccDrawLine(poli[3], poli[0]);
}

SnakePiece MakeSnakePiece(NSInteger x, NSInteger y) {
    SnakePiece piece;
    piece.x = x;
    piece.y = y;
    return piece;
}

@implementation GameScene
@synthesize score = score_;
@synthesize level = level_;

+ (id)scene {
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
    if ((self = [super init])) {
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kGameBackgroundColor];
        // we need to add the background layer to a Z index of -1 in order to be able to draw primitives
        // in the draw method. The primitives are [apparently] always drawn at Z index 0
        [self addChild:backgroundLayer z:-1];
        
        CCMenuItem *pauseButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-off.png"] 
                                                          selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-on.png"] 
                                                                  target:self 
                                                                selector:@selector(pauseBtnTapped:)];
        CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
        menu.position = ccp(400.0f, 17.0f);
        [self addChild:menu];
        
        [self setScore:0];
        [self setLevel:1];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)pauseBtnTapped:(CCMenuItem *)sender {
    
}

- (void)setScore:(NSInteger)score {
    score_ = score;
    if (!scoreLabelShadow_) {
        scoreLabelShadow_ = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Krungthep" fontSize:20.0f];
        scoreLabelShadow_.color = ccc3(135,159,106);
        scoreLabelShadow_.position = ccp(29.5, 294.5);
        scoreLabelShadow_.anchorPoint = ccp(0.0, 0.5);
        [self addChild:scoreLabelShadow_];
    }
    if (!scoreLabel_) {
        scoreLabel_ = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Krungthep" fontSize:20.0f];
        scoreLabel_.color = ccc3(26,26,13);
        scoreLabel_.position = ccp(31, 296);
        scoreLabel_.anchorPoint = ccp(0.0, 0.5);
        [self addChild:scoreLabel_];
    }
    [scoreLabelShadow_ setString:[NSString stringWithFormat:@"Score: %d", score_]];
    [scoreLabel_ setString:[NSString stringWithFormat:@"Score: %d", score_]];
}

- (void)setLevel:(NSInteger)level {
    level_ = level;
    if (!levelLabelShadow_) {
        levelLabelShadow_ = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Krungthep" fontSize:16.0f];
        levelLabelShadow_.color = ccc3(135,159,106);
        levelLabelShadow_.position = ccp(29.5, 13.5);
        levelLabelShadow_.anchorPoint = ccp(0.0, 0.5);
        [self addChild:levelLabelShadow_];
    }
    if (!levelLabel_) {
        levelLabel_ = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Krungthep" fontSize:16.0f];
        levelLabel_.color = ccc3(26,26,13);
        levelLabel_.position = ccp(31, 15);
        levelLabel_.anchorPoint = ccp(0.0, 0.5);
        [self addChild:levelLabel_];
    }
    [levelLabelShadow_ setString:[NSString stringWithFormat:@"Level %d", level_]];
    [levelLabel_ setString:[NSString stringWithFormat:@"Level %d", level_]];
    
    // max 20 pieces
    snake_[0] = MakeSnakePiece(2,1);
    snake_[1] = MakeSnakePiece(1,1);
    snake_[2] = MakeSnakePiece(0,1);
}

- (void)step {
    for (int i = snakePieces_ - 1; i > 0; i--) {
        snake_[i] = snake_[i-1];
    }
    switch (direction_) {
        case UP:
            snake_[0].y++;
            break;
        case RIGHT:
            snake_[0].x++;
            break;
        case DOWN:
            snake_[0].y--;
            break;
        case LEFT:
            snake_[0].x--;
            break;
        default:
            break;
    }
    if (snake_[0].x < 0 
        || snake_[0].x > MAX_COLS 
        || snake_[0].y < 0 
        || snake_[0].y > MAX_ROWS) {
        // game over
    }
}

- (void)update:(ccTime)time {
    accumulator += time;
    float speedStep = BASE_SPEED - BASE_SPEED/MAX_SPEED * currentSpeed_;
    while (accumulator >= speedStep) {
        [self step];
        accumulator -= speedStep;
    }
}

-(void) draw {
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	glDisable(GL_LINE_SMOOTH);
	glLineWidth( 1.0f );
	glColor4ub(0,0,0,255);
	ccDrawFilledRect(ccp(s.width - 26, s.height - 42), ccp(28, 32));
    
    NSInteger existingSprites = [snakeSprites_ count];
    for (int i = 0; i < snakePieces_; i++) {
        //if ()
    }
}

@end
