//
//  Shader.fsh
//  Stunts3d
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Splinter Software. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
