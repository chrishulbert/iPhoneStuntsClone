//
//  BtSphere.h
//  Stunts3d
//
//  Created by Chris Hulbert on 20/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtObject.h"

@interface BtSphere : BtObject {
}

+ (BtSphere*) sphereWithRadius:(float)radius atX:(float)x y:(float)y z:(float)z;

@end
