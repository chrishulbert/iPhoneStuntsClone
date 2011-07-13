//
//  Stunts3dAppDelegate.h
//  Stunts3d
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stunts3dViewController;

@interface Stunts3dAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Stunts3dViewController *viewController;

@end
