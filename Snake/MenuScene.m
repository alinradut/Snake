//
//  MenuScene.m
//  Snake
//
//  Created by Clawoo on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameConfig.h"
#import "GameScene.h"
#import "HighscoresScene.h"
#import "AboutScene.h"

@implementation MenuScene

+(id) scene {
	CCScene *scene = [CCScene node];
	MenuScene *layer = [MenuScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
    if ((self = [super init])) {
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:backgroundLayer];
        
        CCMenuItem *playButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-play-off.png"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-play-on.png"]
                                                                 target:self 
                                                               selector:@selector(playBtnTapped:)];
        
        CCMenuItem *highscoresButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-highscores-off.png"]
                                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-highscores-on.png"]
                                                                       target:self 
                                                                     selector:@selector(highscoresBtnTapped:)];
        
        CCMenuItem *aboutButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-about-off.png"]
                                                          selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-about-on.png"]
                                                                  target:self 
                                                                selector:@selector(aboutBtnTapped:)];
        
        CCMenu *menu = [CCMenu menuWithItems:playButton, highscoresButton, aboutButton, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

- (void)playBtnTapped:(CCMenuItem *)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:.5 
																					 scene:[GameScene scene]]];
}

- (void)highscoresBtnTapped:(CCMenuItem *)sender {
    
}

- (void)aboutBtnTapped:(CCMenuItem *)sender {
    
}

@end
