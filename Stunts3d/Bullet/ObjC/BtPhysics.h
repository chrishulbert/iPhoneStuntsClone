//
//  BtPhysics.h
//  Stunts3d
//
//  Created by Chris on 18/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
class btBroadphaseInterface;
class btDefaultCollisionConfiguration;
class btCollisionDispatcher;
class btSequentialImpulseConstraintSolver;
class btDiscreteDynamicsWorld;
class btCollisionShape;
class btDefaultMotionState;
class btRigidBody;
#endif
@class BtObject;

@interface BtPhysics : NSObject {
#ifdef __cplusplus
    btBroadphaseInterface* broadphase;
    btDefaultCollisionConfiguration* collisionConfiguration;
    btCollisionDispatcher* dispatcher;
    btSequentialImpulseConstraintSolver* solver;
    btDiscreteDynamicsWorld* dynamicsWorld;    
    btCollisionShape* groundShape;
    btDefaultMotionState* groundMotionState;
    btRigidBody* groundRigidBody;
#else
    void* broadphase;
    void* collisionConfiguration;
    void* dispatcher;
    void* solver;
    void* dynamicsWorld;    
    void* groundShape;
    void* groundMotionState;
    void* groundRigidBody;
#endif    
}

- (void)addObject:(BtObject*)object;

@end
