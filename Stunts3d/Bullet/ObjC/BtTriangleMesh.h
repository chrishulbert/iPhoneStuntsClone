//
//  BtTriangleMesh.h
//  Stunts3d
//
//  Created by Chris on 4/08/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtObject.h"
#import "BtTypes.h"

#ifdef __cplusplus
class btTriangleMesh;
#endif

@interface BtTriangleMesh : BtObject {
#ifdef __cplusplus
    btTriangleMesh* trimesh;     
#else
    void* trimesh;     
#endif
}

+ (BtTriangleMesh*) triangleMesh;
- (void)addTri:(btPos)a b:(btPos)b c:(btPos)c;
- (void)doneAddingTriangles;

@end
