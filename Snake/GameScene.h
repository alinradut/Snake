//
//  GameScene.h
//  Snake
//
//  Created by Clawoo on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCLayer {
    CCLabelTTF *scoreLabel_;
    CCLabelTTF *scoreLabelShadow_;
    CCLabelTTF *levelLabel_;
    CCLabelTTF *levelLabelShadow_;
    NSInteger score_;
    NSInteger level_;
    
}

+ (id)scene;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger level;

@end
