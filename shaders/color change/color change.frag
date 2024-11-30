#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/3lVBRV

/* Returns rgb vec from input 0-1 */
vec3 getRainbowColor(in float val) {
    /*convert to rainbow RGB*/
    float a = (1.0 - val) * 6.0;
    int X = int(floor(a));
    float Y = a - float(X);
    float r = 0.;
    float g = 0.;
    float b = 0.;
    if (X == 0) {
        r = 1.; g = Y; b = 0.;
    } else if (X == 1) {
        r = 1. - Y; g = 1.; b = 0.;
    } else if (X == 2) {
        r = 0.; g = 1.; b = Y;
    } else if (X == 3) {
        r = 0.; g = 1. - Y; b = 1.;
    } else if (X == 4) {
        r = Y; g = 0.; b = 1.;
    } else if (X == 5) {
        r = 1.; g = 0.; b = 1. - Y;
    } else {
        r = 0.; g = 0.; b = 0.;
    }
    return vec3(r, g, b);
}

float d;

float lookup(vec2 p, float dx, float dy, float edgeIntensity)
{
    vec2 uv = (p.xy + vec2(dx * edgeIntensity, dy * edgeIntensity)) / iResolution.xy;
    vec4 c = texture(iChannel0, uv.xy);
	
	// return as luma
    return 0.2126*c.r + 0.7152*c.g + 0.0722*c.b;
}

void mainImage()
{
    float timeNorm = mod(iTime, 5.) / 5.;
    vec3 glowCol = getRainbowColor(timeNorm);
    float edgeIntensity = 1.;
    if (timeNorm < .5) { edgeIntensity += (4. * timeNorm);}
    else { edgeIntensity += -4. * (timeNorm - 1.); }
    vec2 p = fragCoord.xy;
    
	// simple sobel edge detection
    float gx = 0.0;
    gx += -1.0 * lookup(p, -1.0, -1.0, edgeIntensity);
    gx += -2.0 * lookup(p, -1.0,  0.0, edgeIntensity);
    gx += -1.0 * lookup(p, -1.0,  1.0, edgeIntensity);
    gx +=  1.0 * lookup(p,  1.0, -1.0, edgeIntensity);
    gx +=  2.0 * lookup(p,  1.0,  0.0, edgeIntensity);
    gx +=  1.0 * lookup(p,  1.0,  1.0, edgeIntensity);
    
    float gy = 0.0;
    gy += -1.0 * lookup(p, -1.0, -1.0, edgeIntensity);
    gy += -2.0 * lookup(p,  0.0, -1.0, edgeIntensity);
    gy += -1.0 * lookup(p,  1.0, -1.0, edgeIntensity);
    gy +=  1.0 * lookup(p, -1.0,  1.0, edgeIntensity);
    gy +=  2.0 * lookup(p,  0.0,  1.0, edgeIntensity);
    gy +=  1.0 * lookup(p,  1.0,  1.0, edgeIntensity);
    
	// hack: use g^2 to conceal noise in the video
    float g = gx*gx + gy*gy;
    
    vec4 col = texture(iChannel0, p / iResolution.xy);
    col += vec4(g * glowCol, 1.0);
    
    fragColor = col;

gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}