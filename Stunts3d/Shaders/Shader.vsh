//
//  Shader.vsh
//  Stunts3d
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
