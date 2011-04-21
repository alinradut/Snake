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

@implementation GameScene

+ (id)scene {
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
    if ((self = [super init])) {
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kGameBackgroundColor];
        [self addChild:backgroundLayer];
    }
    return self;
}

@end
