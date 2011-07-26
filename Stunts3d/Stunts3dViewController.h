//
//  Stunts3dViewController.h
//  Stunts3d
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class Terrain;
@class BtPhysics;
@class BtSphere;

@interface Stunts3dViewController : UIViewController {
@private
    EAGLContext *context;
    GLuint program;
    
    BOOL animating;
    NSInteger animationFrameInterval;
    CADisplayLink *displayLink;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic, retain) Terrain* terrain;
@property (nonatomic, retain) BtPhysics* physics;

- (void)startAnimation;
- (void)stopAnimation;

@end
