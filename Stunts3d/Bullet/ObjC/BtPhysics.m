//
//  BtPhysics.m
//  Stunts3d
//
//  Created by Chris on 18/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "BtPhysics.h"
#include "btBulletDynamicsCommon.h"

// Privates
@interface BtPhysics()
@end

@implementation BtPhysics

- (id)init {
    self = [super init];
    if (self) {
        
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
        
        // Do_everything_else_here
    }
    return self;
}

-(void)dealloc {
    // Clean up behind ourselves like good little programmers
    delete dynamicsWorld;
    delete solver;
    delete dispatcher;
    delete collisionConfiguration;
    delete broadphase;
    [super dealloc];
}

@end
