//
//  BtPhysics.m
//  Stunts3d
//
//  Created by Chris on 18/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "BtPhysics.h"
#import "BtObject.h"
#include "btBulletDynamicsCommon.h"

// Privates
@interface BtPhysics()
@property(nonatomic,retain) NSMutableArray* objects;
@end

@implementation BtPhysics

@synthesize objects;

- (id)init {
    self = [super init];
    if (self) {
        // Set up the obj-c bits first
        self.objects = [NSMutableArray array];
        
        // Now set up the bullet stuff
        // Build the broadphase
        broadphase = new btDbvtBroadphase();
        
        // Set up the collision configuration and dispatcher
        collisionConfiguration = new btDefaultCollisionConfiguration();
        dispatcher = new btCollisionDispatcher(collisionConfiguration);
        
        // The actual physics solver
        solver = new btSequentialImpulseConstraintSolver;
        
        // The world.
        dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,broadphase,solver,collisionConfiguration);
        dynamicsWorld->setGravity(btVector3(0,0,-10));
        
        // Set up the ground plane
        groundShape = new btStaticPlaneShape(btVector3(0,0,1),0);
        groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,0,0)));
        btRigidBody::btRigidBodyConstructionInfo groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
        groundRigidBody = new btRigidBody(groundRigidBodyCI);
        dynamicsWorld->addRigidBody(groundRigidBody);
    }
    return self;
}

-(void)dealloc {
    // Clean up children
    self.objects = nil;
    // Clean up behind ourselves like good little programmers
    delete groundRigidBody;
    delete groundMotionState;
    delete groundShape;
    delete dynamicsWorld;
    delete solver;
    delete dispatcher;
    delete collisionConfiguration;
    delete broadphase;
    [super dealloc];
}

// Add and retain a child object
- (void)addObject:(BtObject*)object {
    dynamicsWorld->addRigidBody((btRigidBody*)[object getRigidBody]);
    [self.objects addObject:object];
}

@end
