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

@interface BtPhysics : NSObject {
    btBroadphaseInterface* broadphase;
    btDefaultCollisionConfiguration* collisionConfiguration;
    btCollisionDispatcher* dispatcher;
    btSequentialImpulseConstraintSolver* solver;
    btDiscreteDynamicsWorld* dynamicsWorld;    
}

@end
