//
//  Terrain.m
//  Stunts3d
//
//  Created by Chris Hulbert on 25/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

#import "Terrain.h"
#import "Texture.h"
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@implementation Terrain

@synthesize grass;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    self.grass = nil;
    [super dealloc];
}

// Load the file, split into lines
- (NSArray*)fileLines {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terrain1" ofType:@"txt"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    return [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
}

// Load the file, without filling in the corners and edges
- (void)loadRaw {
    int currentRow=0;
    for (NSString* line in [self fileLines]) {
        if (line.length >= MAP_WIDTH) {
            if (currentRow < MAP_HEIGHT) {
                for (int currentCol=0; currentCol<MAP_WIDTH; currentCol++) {
                    unichar c = [line characterAtIndex:currentCol];
                    char t = tileGroundLow;
                    if (c=='-') t = tileGroundLow;
                    if (c=='+') t = tileGroundHigh;
                    if (c=='(') t = tileGroundVerticalLowToHigh;
                    if (c==')') t = tileGroundVerticalHighToLow;
                    if (c=='_') t = tileGroundHorizontalLowToHigh;
                    if (c=='=') t = tileGroundHorizontalHighToLow;
                    if (c=='/') t = tileUncertainCorner;
                    if (c=='\\') t = tileUncertainCorner;
                    tiles[currentRow][currentCol] = t;
                }
                currentRow ++;
            }
        }
    }
}

// Get the tile at the given position, or 0 if its out of range
- (char)tileAtCol:(int)col row:(int)row {
    if (col<0) return 0;
    if (col>=MAP_WIDTH) return 0;
    if (row<0) return 0;
    if (row>=MAP_HEIGHT) return 0;
    return tiles[row][col];
}

// Fix the uncertain corners and edges
- (void)fixUncertainTiles {
    for (int row=0; row<MAP_HEIGHT; row++) {
        for (int col=0; col<MAP_WIDTH; col++) {
            if (tiles[row][col]==tileUncertainCorner) {
                // Figure out the surrounding tiles
                char tl = [self tileAtCol:col-1 row:row-1];
                char t = [self tileAtCol:col row:row-1];
                char tr = [self tileAtCol:col+1 row:row-1];
                char l = [self tileAtCol:col-1 row:row];
                char r = [self tileAtCol:col+1 row:row];
                char bl = [self tileAtCol:col-1 row:row+1];
                char b = [self tileAtCol:col row:row+1];
                char br = [self tileAtCol:col+1 row:row+1];
                
                // Figure out the heights of the corners of this tile
                char ht_tl, ht_tr, ht_bl, ht_br;
                ht_tl = ht_tr = ht_bl = ht_br = 0;
                if (tl==tileGroundHigh) ht_tl=1;
                if (tl==tileGroundVerticalLowToHigh) ht_tl=1;
                if (tl==tileGroundHorizontalLowToHigh) ht_tl=1;
                if (t==tileGroundHigh) ht_tl=ht_tr=1;
                if (t==tileGroundHorizontalLowToHigh) ht_tl=ht_tr=1;
                if (t==tileGroundVerticalLowToHigh) ht_tr=1;
                if (tr==tileGroundHigh) ht_tr=1;
                if (tr==tileGroundVerticalHighToLow) ht_tr=1;
                if (tr==tileGroundHorizontalLowToHigh) ht_tr=1;
                if (l==tileGroundHigh) ht_tl=ht_bl=1;
                if (l==tileGroundHorizontalLowToHigh) ht_bl=1;
                if (l==tileGroundHorizontalHighToLow) ht_tl=1;
                if (l==tileGroundVerticalLowToHigh) ht_tl=ht_bl=1;
                if (r==tileGroundHigh) ht_tr=ht_br=1;
                if (r==tileGroundHorizontalLowToHigh) ht_br=1;
                if (r==tileGroundHorizontalHighToLow) ht_tr=1;
                if (r==tileGroundVerticalHighToLow) ht_tr=ht_br=1;
                if (bl==tileGroundHigh) ht_bl=1;
                if (bl==tileGroundVerticalLowToHigh) ht_bl=1;
                if (bl==tileGroundHorizontalHighToLow) ht_bl=1;
                if (b==tileGroundHigh) ht_bl=ht_br=1;
                if (b==tileGroundHorizontalHighToLow) ht_bl=ht_br=1;
                if (b==tileGroundVerticalLowToHigh) ht_br=1;
                if (b==tileGroundVerticalHighToLow) ht_bl=1;
                if (br==tileGroundHigh) ht_br=1;
                if (br==tileGroundVerticalHighToLow) ht_br=1;
                if (br==tileGroundHorizontalHighToLow) ht_br=1;
                
                // Now figure out what this corner is
                char highs = ht_tl+ht_tr+ht_bl+ht_br;
                if (highs>=3) { // It is a high corner
                    if (!ht_br) tiles[row][col] = tileCornerHighTL;
                    if (!ht_bl) tiles[row][col] = tileCornerHighTR;
                    if (!ht_tr) tiles[row][col] = tileCornerHighBL;
                    if (!ht_tl) tiles[row][col] = tileCornerHighBR;
                } else { // It is a low corner
                    if (ht_br) tiles[row][col] = tileCornerLowTL;
                    if (ht_bl) tiles[row][col] = tileCornerLowTR;
                    if (ht_tr) tiles[row][col] = tileCornerLowBL;
                    if (ht_tl) tiles[row][col] = tileCornerLowBR;
                }
            }
        }
    }
}

// Load the track
- (void)load {
    [self loadRaw];
    [self fixUncertainTiles];
}

// X: +East,  -West
// Y: +North, -South
// Z: +Up,    -Down
// Origin of the map is North West
// Rows go south (minus)
// Cols go east (positive)
- (void)render {
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // Load (if necessary) and bind the texture
    if (!grass) self.grass = [Texture textureFromFile:@"grass_256.jpg"];
    [grass bind];
    static const GLfloat texCoords[] = {
        0.0, 1.0,
        1.0, 1.0,
        0.0, 0.0,
        1.0, 0.0
    };
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);

    for (int currentRow=0; currentRow<MAP_HEIGHT; currentRow++) {
        for (int currentCol=0; currentCol<MAP_WIDTH; currentCol++) {
            float pieceTopLeftX = MAP_ORIGIN_X+currentCol;
            float pieceTopLeftY = MAP_ORIGIN_Y-currentRow;
            char tile = tiles[currentRow][currentCol];
            if (tile == tileGroundLow) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    36, 104, 32, 255, // Low colour
                    36, 104, 32, 255, // Low colour
                    36, 104, 32, 255, // Low colour
                    36, 104, 32, 255, // Low colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (tile == tileGroundHigh) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    132, 224, 132, 255, // High colour
                    132, 224, 132, 255, // High colour
                    132, 224, 132, 255, // High colour
                    132, 224, 132, 255, // High colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (tile == tileGroundVerticalLowToHigh) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    36, 104, 32, 255, // Low colour
                    132, 224, 132, 255, // High colour
                    36, 104, 32, 255, // Low colour
                    132, 224, 132, 255, // High colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (tile == tileGroundVerticalHighToLow) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    132, 224, 132, 255, // High colour
                    36, 104, 32, 255, // Low colour
                    132, 224, 132, 255, // High colour
                    36, 104, 32, 255, // Low colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (tile == tileGroundHorizontalLowToHigh) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    36, 104, 32, 255, // Low colour
                    36, 104, 32, 255, // Low colour
                    132, 224, 132, 255, // High colour
                    132, 224, 132, 255, // High colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            if (tile == tileGroundHorizontalHighToLow) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                };
                static const GLubyte squareColors[] = {
                    132, 224, 132, 255, // High colour
                    132, 224, 132, 255, // High colour
                    36, 104, 32, 255, // Low colour
                    36, 104, 32, 255, // Low colour
                };
                
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
            static const GLubyte lowCornerColors[] = {
                36, 104, 32, 255, // Low colour
                36, 104, 32, 255, // Low colour
                36, 104, 32, 255, // Low colour
                132, 224, 132, 255, // High colour
            };
            static const GLubyte highCornerColors[] = {
                132, 224, 132, 255, // High colour
                132, 224, 132, 255, // High colour
                132, 224, 132, 255, // High colour
                36, 104, 32, 255, // Low colour
            };
            if (tile == tileCornerLowTL) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, lowCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerLowTR) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX+1, pieceTopLeftY,   0, // Top right of tile
                    pieceTopLeftX,   pieceTopLeftY,   0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                    pieceTopLeftX,   pieceTopLeftY-1, 1, // Bottom left of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, lowCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerLowBL) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, lowCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerLowBR) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, lowCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }           
            if (tile == tileCornerHighTL) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 0, // Bottom right of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, highCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerHighTR) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 0, // Bottom left of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, highCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerHighBL) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX, pieceTopLeftY, 1, // Top left of tile
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                    pieceTopLeftX+1, pieceTopLeftY, 0, // Top right of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, highCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }            
            if (tile == tileCornerHighBR) {
                GLfloat tileVertices[] = {
                    pieceTopLeftX+1, pieceTopLeftY-1, 1, // Bottom right of tile
                    pieceTopLeftX+1, pieceTopLeftY, 1, // Top right of tile
                    pieceTopLeftX, pieceTopLeftY-1, 1, // Bottom left of tile
                    pieceTopLeftX, pieceTopLeftY, 0, // Top left of tile
                };
                glColorPointer(4, GL_UNSIGNED_BYTE, 0, highCornerColors);
                glVertexPointer(3, GL_FLOAT, 0, tileVertices);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            }
        }
    }
}

@end
