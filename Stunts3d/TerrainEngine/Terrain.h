//
//  Terrain.h
//  Stunts3d
//
//  Created by Chris Hulbert on 25/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@class Texture;

@interface Terrain : NSObject {
    char tiles[MAP_HEIGHT][MAP_WIDTH];
}
@property (nonatomic,retain) Texture* grass;

-(void) load;
-(void) render;

@end
