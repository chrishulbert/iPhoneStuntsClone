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
    delete trimesh;
    delete rigidBody;
    delete motionState;
    delete shape;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        trimesh = new btTriangleMesh();
    }
    return self;
}

// btVector3 A(0.0f,0.0f,0.0f);
- (void)addTri:(btPos)a b:(btPos)b c:(btPos)c {
    trimesh->addTriangle(
                         btVector3(a.x,a.y,a.z),
                         btVector3(b.x,b.y,b.z),
                         btVector3(c.x,c.y,c.z),
                         false); // false, don’t remove duplicate vertices
}

- (void)doneAddingTriangles {
    // true for using quantization; true for building the BVH
    shape = new btBvhTriangleMeshShape(trimesh, true, true);
    
    // Make a non-transformed and non-rotated (identity) motion state / transform / quaternion
    motionState = new btDefaultMotionState();
    
    btScalar mass = 0; // Setting the mass to zero makes this a non moving object
    btVector3 inertia(0,0,0);
    shape->calculateLocalInertia(mass, inertia);
    
    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(mass,motionState,shape,inertia);
    rigidBody = new btRigidBody(rigidBodyCI);
}

+ (BtTriangleMesh*) triangleMesh {
    return [[[BtTriangleMesh alloc] init] autorelease];
}

@end
