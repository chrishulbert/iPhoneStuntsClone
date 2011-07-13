//
//  Texture.m
//  Stunts3d
//
//  Created by Chris Hulbert on 13/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "Texture.h"

@implementation Texture

- (void) loadImageData:(NSString*)file {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
//    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
//    UIImage *image = [[UIImage alloc] initWithData:texData];
//    if (image == nil)
//        NSLog(@"Do real error checking here");
    UIImage *image = [UIImage imageNamed:file];
    
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM( context, 0, height - height );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    
    free(imageData);
//    [image release];
//    [texData release];
}

- (id) initFromFile:(NSString*)file {
    self = [self init];
    if (self) {
        
        glGenTextures(1, &textureName); // Make the texture name (like a handle)
        glBindTexture(GL_TEXTURE_2D, textureName); // Select the texture to work with
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); // So we don't need mipmaps
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); // So we don't need mipmaps
        [self loadImageData:file];
        
    }
    return self;
}

- (void) bind {
    glBindTexture(GL_TEXTURE_2D, textureName); // Select the texture to work with
}

+ (id) textureFromFile:(NSString*)file {
    return [[[Texture alloc] initFromFile:file] autorelease];    
}

@end
