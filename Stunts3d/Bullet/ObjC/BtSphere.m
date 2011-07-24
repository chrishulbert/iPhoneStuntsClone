//
//  BtSphere.m
//  Stunts3d
//
//  Created by Chris Hulbert on 20/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "BtSphere.h"
#include "btBulletDynamicsCommon.h"

@implementation BtSphere

- (void)dealloc {
    delete rigidBody;
    delete motionState;
    delete shape;
    [super dealloc];
}

- (id)initWithRadius:(float)radius atX:(float)x y:(float)y z:(float)z {
    self = [self init];
    if (self) {
        shape = new btSphereShape(1);

        motionState =
        new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,50,0)));
        
        btScalar mass = 1;
        btVector3 inertia(0,0,0);
        shape->calculateLocalInertia(mass, inertia);

        btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(mass,motionState,shape,inertia);
        rigidBody = new btRigidBody(rigidBodyCI);
    }
    return self;
}

+ (BtSphere*) sphereWithRadius:(float)radius atX:(float)x y:(float)y z:(float)z {
    return [[[BtSphere alloc] initWithRadius:radius atX:x y:y z:z] autorelease];
}

@end
