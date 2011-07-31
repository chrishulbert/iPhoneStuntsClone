//
//  BtObject.m
//  Stunts3d
//
//  Created by Chris Hulbert on 20/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "BtObject.h"
#include "btBulletDynamicsCommon.h"

@implementation BtObject

- (btRigidBody*)getRigidBody {
    return rigidBody;
}

- (btPos)getPos {
    btTransform trans;
    rigidBody->getMotionState()->getWorldTransform(trans);
    btVector3 origin = trans.getOrigin();
    btPos p;
    p.x = origin.getX();
    p.y = origin.getY();
    p.z = origin.getZ();
    return p;
}


@end
