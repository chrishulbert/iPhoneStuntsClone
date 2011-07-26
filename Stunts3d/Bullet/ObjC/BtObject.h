//
//  BtObject.h
//  Stunts3d
//
//  Created by Chris Hulbert on 20/07/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
class btCollisionShape;
class btDefaultMotionState;
class btRigidBody;
#endif

@interface BtObject : NSObject {
#ifdef __cplusplus
    btCollisionShape* shape;
    btDefaultMotionState* motionState;
    btRigidBody* rigidBody;
#else
    void* shape;
    void* motionState;
    void* rigidBody;
#endif    
}

#ifdef __cplusplus
- (btRigidBody*)getRigidBody;
#else
- (void*)getRigidBody;
#endif    

@end
