//
//  BtPhysics.h
//  Stunts3d
//
//  Created by Chris on 18/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

class btBroadphaseInterface;
class btDefaultCollisionConfiguration;
class btCollisionDispatcher;
class btSequentialImpulseConstraintSolver;
class btDiscreteDynamicsWorld;
class btCollisionShape;
class btDefaultMotionState;
class btRigidBody;
@class BtObject;

@interface BtPhysics : NSObject {
    btBroadphaseInterface* broadphase;
    btDefaultCollisionConfiguration* collisionConfiguration;
    btCollisionDispatcher* dispatcher;
    btSequentialImpulseConstraintSolver* solver;
    btDiscreteDynamicsWorld* dynamicsWorld;    
    btCollisionShape* groundShape;
    btDefaultMotionState* groundMotionState;
    btRigidBody* groundRigidBody;
}

- (void)addObject:(BtObject*)object;

@end
