#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    vec2 o_trpino = (fragCoord.xy - iResolution.xy*0.5) / iResolution.y;

    vec2 o = (fragCoord.xy / iResolution.xy);
    //https://www.desmos.com/calculator/lcwyvnubf7
    float n_x = abs(o.x-(1./2.))*-1.+(1./2.);
    float n_y = o.y;
    vec4 o_col_webcam = texture(iChannel0, vec2(n_x, n_y));
    
    fragColor = o_col_webcam;
    
}

// https://www.shadertoy.com/view/dssXRl