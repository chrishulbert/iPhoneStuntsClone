//
//  BtTriangleMesh.m
//  Stunts3d
//
//  Created by Chris on 4/08/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "BtTriangleMesh.h"
#include "btBulletDynamicsCommon.h"

@implementation BtTriangleMesh

- (void)dealloc {
    delete rigidBody;
    delete motionState;
    delete shape;
    [super dealloc];
}

- (id)initWithRadius:(float)radius atX:(float)x y:(float)y z:(float)z {
    self = [self init];
    if (self) {
        btTriangleMesh* data = new btTriangleMesh();
        btVector3 A(0.0f,0.0f,0.0f);
        btVector3 B(1.0f,0.0f,0.0f);
        btVector3 C(0.0f,0.0f,1.0f);
        data->addTriangle(A,B,C,false); // false, don’t remove duplicate vertices
        // true for using quantization; true for building the BVH
        shape=new btBvhTriangleMeshShape(data,true,true);
        
        motionState =
        new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(x,y,z)));
        
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
