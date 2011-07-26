//
//  Stunts3dViewController.m
//  Stunts3d
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Stunts3dViewController.h"
#import "EAGLView.h"
#import "Terrain.h"
#import "Settings.h"
#import "ConciseKit.h"
#import "Bullet.h"

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface Stunts3dViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
@end

@implementation Stunts3dViewController

@synthesize animating, context, displayLink;
@synthesize terrain;
@synthesize physics;

- (void)awakeFromNib
{
    // TODO make it work with ES2?
    EAGLContext *aContext = nil;//[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!aContext) {
        aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    }
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
        
    animating = FALSE;
    animationFrameInterval = 2;
    self.displayLink = nil;

    // Enable the z buffer
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    // Enable textures
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ZERO);// GL_SRC_COLOR); // Todo change this so that it ues the source colour too
    
    // TODO enable lighting
}

- (void)dealloc
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    
    self.terrain = nil;
    self.physics = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.terrain = [[[Terrain alloc] init] autorelease];
    [self.terrain load];
    
    self.physics = $new(BtPhysics);
    
    BtSphere* sph = [BtSphere sphereWithRadi
//    [self.physics addObject:]
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (void)viewWillAppear:(BOOL)animated {
    [self startAnimation];    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self stopAnimation];
    [super viewWillDisappear:animated];
}

- (NSInteger)animationFrameInterval {
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval {
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation {
    if (!animating) {
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
    }
}

- (void)stopAnimation {
    if (animating) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}

- (void)gluPerspective:(double)fovy :(double)aspect :(double)zNear :(double)zFar {
    // Start in projection mode.
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    double xmin, xmax, ymin, ymax;
    ymax = zNear * tan(fovy * M_PI / 360.0);
    ymin = -ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;
    glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
}

static void normalize(GLfloat v[3]) {
    GLfloat r;
    
    r=(GLfloat)sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    if (r==0.0f)
    {
        return;
    }
    
    v[0]/=r;
    v[1]/=r;
    v[2]/=r;
}

static void __gluMakeIdentityf(GLfloat m[16]) {
    m[0+4*0] = 1; m[0+4*1] = 0; m[0+4*2] = 0; m[0+4*3] = 0;
    m[1+4*0] = 0; m[1+4*1] = 1; m[1+4*2] = 0; m[1+4*3] = 0;
    m[2+4*0] = 0; m[2+4*1] = 0; m[2+4*2] = 1; m[2+4*3] = 0;
    m[3+4*0] = 0; m[3+4*1] = 0; m[3+4*2] = 0; m[3+4*3] = 1;
}

static void cross(GLfloat v1[3], GLfloat v2[3], GLfloat result[3]) {
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
          GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
          GLfloat upz) {
    GLfloat forward[3], side[3], up[3];
    GLfloat m[4][4];
    
    forward[0] = centerx - eyex;
    forward[1] = centery - eyey;
    forward[2] = centerz - eyez;
    
    up[0] = upx;
    up[1] = upy;
    up[2] = upz;
    
    normalize(forward);
    
    /* Side = forward x up */
    cross(forward, up, side);
    normalize(side);
    
    /* Recompute up as: up = side x forward */
    cross(side, forward, up);
    
    __gluMakeIdentityf(&m[0][0]);
    m[0][0] = side[0];
    m[1][0] = side[1];
    m[2][0] = side[2];
    
    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];
    
    m[0][2] = -forward[0];
    m[1][2] = -forward[1];
    m[2][2] = -forward[2];
    
    glMultMatrixf(&m[0][0]);
    glTranslatef(-eyex, -eyey, -eyez);
}

- (void)drawFrame {
    [(EAGLView *)self.view setFramebuffer];

    // Make a spinning camera
    static float angle=0; angle+=0.01f;
    
    // Set up the camera
    //    glMatrixMode(GL_PROJECTION);
    //    glLoadIdentity();
    //    gluPerspective(50.0, 1.0, 3.0, 7.0);
    // TODO tweak the near and far distances below so the z-buffer is optimum
    [self gluPerspective:90 :self.view.frame.size.width/self.view.frame.size.height :1 :MAP_HEIGHT];
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    gluLookAt(0, -15, 15.0,
//              0.0, 0.0, 0.0,
//              0.0, 0.0, 1.0);
    glRotatef(-90, 0, 0,1); // So it's 'left'
    gluLookAt(sinf(angle)*12, cosf(angle)*12, 5.0,
              0.0, 0.0, 0.0,
              0.0, 0.0, 1.0);
        
    glClearColor(0, 0, 0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
    [terrain render];
    
    [(EAGLView *)self.view presentFramebuffer];
}

@end
