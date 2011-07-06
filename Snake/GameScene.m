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

#define MAX_COLS    20
#define MAX_ROWS    11
#define MAX_SPEED   10
#define BASE_SPEED  0.2

void ccDrawFilledRect( CGPoint v1, CGPoint v2 )
{
	CGPoint poli[]={v1,CGPointMake(v1.x,v2.y),v2,CGPointMake(v2.x,v1.y)};
    
	ccDrawLine(poli[0], poli[1]);
	ccDrawLine(poli[1], poli[2]);
	ccDrawLine(poli[2], poli[3]);
	ccDrawLine(poli[3], poli[0]);
}

void ccDrawFilledCGRect( CGRect rect )
{
	CGPoint poli[]=
        {rect.origin,
        CGPointMake(rect.origin.x,rect.origin.y + rect.size.height),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
        CGPointMake(rect.origin.x + rect.size.width,rect.origin.y)};
    
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

@interface  GameScene (Private)
- (void)loadLevel:(NSInteger)level;
- (void)setUpFoodPiece;
- (CCSprite *)snakeSpriteAtIndex:(NSInteger)index;
@end

@implementation GameScene
@synthesize score = score_;
@synthesize level = level_;


- (NSInteger)distanceBetweenFoodAndSnake {
    SnakePiece head = snake_[0];
    SnakePiece food = MakeSnakePiece(foodSprite_.tag / 100, foodSprite_.tag %100);
    NSInteger distance = ABS(head.x - food.x) + ABS(head.y - food.y);
    
    // if on the same line or column and moving in the opposite direction two more units are needed
    if (head.x == food.x) {
        if (head.y - food.y > 0) {
            if (direction_ == DOWN) {
                direction_ += 2;
            }
        }
        else {
            if (direction_ == UP) {
                direction_ += 2;
            }
        }
    }
    else 
    if (head.y == food.y) {
        if (head.x - food.x) {
            if (direction_ == RIGHT) {
                direction_ += 2;
            }
        }
        else {
            if (direction_ == RIGHT) {
                direction_ += 2;
            }
        }
    }
    return  distance;
}

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
        self.isTouchEnabled = YES;
        gameAreaRect_ = CGRectMake(29, 38, 422, 242);
        
        CCMenuItem *pauseButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-off.png"] 
                                                          selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-pause-on.png"] 
                                                                  target:self 
                                                                selector:@selector(pauseBtnTapped:)];
        CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
        menu.position = ccp(400.0f, 17.0f);
        [self addChild:menu];
        snakeSprites_ = [[NSMutableArray alloc] init];
        
        levels_ = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]] retain];
        
        [self setScore:0];
        [self setLevel:1];

        srand ( time(NULL) );
        [self scheduleUpdate];
        [self setUpFoodPiece];
        gameState_ = GameStateRunning;
    }
    return self;
}

- (void)pauseBtnTapped:(CCMenuItem *)sender {
    
}

- (void)setUpFoodPiece {
    NSArray *foodTypes = [NSArray arrayWithObjects:@"snail.png",@"worm.png", nil];
    
    foodSprite_ = [CCSprite spriteWithSpriteFrameName:[foodTypes objectAtIndex:rand()%[foodTypes count]]];
    
    NSInteger col = 0;
    NSInteger row = 0;
    
    while (true) {
        col = rand() % MAX_COLS;
        row = rand() % MAX_ROWS;
        BOOL isColliding = NO;
        for (int i = 0; i < snakePieces_; i++) {
            if (snake_[i].x == col || snake_[i].y == row)
            {
                isColliding = YES;
            }
        }
        if (!isColliding)
        {
            foodSprite_.tag = col * 100 + row;
            break;
        }
    }
    [self addChild:foodSprite_];
    foodSprite_.position = CGPointMake(38 + col * 20, 49 + row * 20);
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
    
    [self loadLevel:level];
}

- (void)loadLevel:(NSInteger)level {
    NSDictionary *levelDef = [levels_ objectAtIndex:level-1];
    NSLog(@"Loading level: %@", levelDef);
    for (int i=0; i<[[levelDef objectForKey:@"snake"] count]; i++)
    {
        NSDictionary *piece = [[levelDef objectForKey:@"snake"] objectAtIndex:i];
        snake_[i] = MakeSnakePiece([[piece valueForKey:@"x"] intValue], [[piece valueForKey:@"y"] intValue]);
        if (i == 0)
        {
            direction_ = [[piece valueForKey:@"direction"] intValue];
        }
        [self snakeSpriteAtIndex:i].scale = 1;
    }
    
    snakePieces_ = [[levelDef objectForKey:@"snake"] count];
    remainingFoodPieces_ = [[levelDef valueForKey:@"foodPieces"] intValue];
}

- (void)displayEndOfLevelAnimation {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Congratulations!" fontName:@"Krungthep" fontSize:20.0f];
    label.color = ccc3(26,26,13);
    label.position = ccp(31, 15);
    label.anchorPoint = ccp(0.0, 0.5);
    
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // position the label on the center of the screen
    label.position = ccp( size.width /2 , size.height/2 );
    label.anchorPoint = ccp(0.5, 0.5);
    // add the label as a child to this Layer
    [self addChild: label];
    
    id a1 = [ CCRotateBy actionWithDuration:1 angle:360];
    
    id ease = [CCEaseInOut actionWithAction:a1 rate:3];
    
    id grow = [CCScaleTo actionWithDuration:.4f scale:2.0f];
    id shrink = [CCScaleTo actionWithDuration:.3f scale:1.0f];

    id sequence = [CCSequence actions:ease, grow, shrink, nil];
    
    [label runAction:sequence]; 
    
    for (int i = 0; i < snakePieces_; i++) {
        CCSprite *sprite = [self snakeSpriteAtIndex:i];
        id shrink = [CCScaleTo actionWithDuration:.2f+(float)i/10 scale:0.0f];
        [sprite runAction:shrink];
    }
}

- (void)displayEndOfGameAnimationSuccessfully:(BOOL)successfully {
    
}

- (void)step {
    direction_ = nextDirection_;
    SnakePiece tmp = snake_[0];
    switch (direction_) {
        case UP:
            tmp.y++;
            break;
        case RIGHT:
            tmp.x++;
            break;
        case DOWN:
            tmp.y--;
            break;
        case LEFT:
            tmp.x--;
            break;
        default:
            break;
    }
    if (tmp.x < 0 
        || tmp.x > MAX_COLS 
        || tmp.y < 0 
        || tmp.y > MAX_ROWS) {
        gameState_ = GameStateGameOver;
        NSLog(@"GAME OVER");
    }
    else {
        SnakePiece lastPiece = snake_[snakePieces_-1];
        for (int i = snakePieces_ - 1; i > 0; i--) {
            snake_[i] = snake_[i-1];
        }
        NSLog(@"snake head position (%d, %d)", tmp.x, tmp.y);
        snake_[0] = tmp;
        if (foodSprite_.tag / 100 == snake_[0].x 
            && foodSprite_.tag % 100 == snake_[0].y) {
            snake_[snakePieces_] = lastPiece;
            snakePieces_++;
            remainingFoodPieces_--;
            [foodSprite_ removeFromParentAndCleanup:YES];
            if (remainingFoodPieces_) {
                [self setUpFoodPiece];
            }
            else {
                gameState_ = GameStateLevelOver;
                [self displayEndOfLevelAnimation];
            }
        }
    }
}

- (void)update:(ccTime)time {
    if (gameState_ == GameStateRunning) {
        accumulator += time;
        float speedStep = BASE_SPEED - BASE_SPEED/MAX_SPEED * currentSpeed_;
        while (accumulator >= speedStep) {
            [self step];
            accumulator -= speedStep;
        }
    }
}

- (CCSprite *)snakeSpriteAtIndex:(NSInteger)index {
    NSAssert(index <= [snakeSprites_ count], @"Oopsiee");
    if ([snakeSprites_ count] == index) {
        CCSprite *sprite = nil;
        if (index == 0) {
            sprite = [CCSprite spriteWithSpriteFrameName:@"snake-head.png"];
        }
        else {
            sprite = [CCSprite spriteWithSpriteFrameName:@"snake-body.png"];
        }
        [snakeSprites_ addObject:sprite];
    }
    return [snakeSprites_ objectAtIndex:index];
}

-(void) draw {
	glDisable(GL_LINE_SMOOTH);
	glLineWidth( 1.0f );
	glColor4ub(0,0,0,255);
	ccDrawFilledCGRect(gameAreaRect_);

    for (int i = 0; i < snakePieces_; i++) {
        CCSprite *sprite = [self snakeSpriteAtIndex:i];
        
        sprite.position = CGPointMake(38 + snake_[i].x * 20, 49 + snake_[i].y * 20);
        if (i == 0) {
            sprite.rotation = direction_ * 90;
        }
        if (![sprite parent]) {
            [self addChild:sprite];
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [self convertTouchToNodeSpace:touch];

    if (CGRectContainsPoint(gameAreaRect_, p)) {
        if (direction_ == UP || direction_ == DOWN) {
            if (p.x - 29 > gameAreaRect_.size.width / 2) {
                nextDirection_ = RIGHT;
            }
            else {
                nextDirection_ = LEFT;
            }
        }
        else {
            if (p.y - 38 > gameAreaRect_.size.height / 2) {
                nextDirection_ = UP;
            }
            else {
                nextDirection_ = DOWN;
            }
        }
    }
}

- (void)dealloc {
    [levels_ release];
    [super dealloc];
}

@end
