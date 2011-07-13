//
//  Texture.h
//  Stunts3d
//
//  Created by Chris Hulbert on 13/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>
//#import <OpenGLES/ES1/glext.h>
//#import <OpenGLES/ES2/gl.h>
//#import <OpenGLES/ES2/glext.h>

@interface Texture : NSObject {
    GLuint textureName;
}

+ (id) textureFromFile:(NSString*)file;
- (void) bind;

@end
