#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/wdVSR1
// MODE set effect type.
// 0 : no effect
// 1 : color 
// 2 : uv.x slip if glitched
// 3 : inverse
// 4 : uv shift glitch
// 5 : rgb shift
#define ENABLE_MODE 2
#define MODE 5

float hash(in float v) { return fract(sin(v)*43768.5453); }
float hash(in vec2 v) { return fract(sin(dot(v, vec2(12.9898, 78.233)))*43768.5453); }
vec2 hash2(in float v) { return vec2(hash(v+vec2(77.77)), hash(v+vec2(999.999))); }
vec2 hash2(in vec2 v) { return vec2(hash(v+vec2(77.77)), hash(v+vec2(999.999))); }

#define GLITCH_THR 0.09
#define GLITCH_RECT_DIVISION 5.
#define GLITCH_RECT_ITR 2
vec3 glitch(in vec2 p, in float seed) {
	vec2 q = fract(p);
    float g = -1.;
    for(int i=0;i<GLITCH_RECT_ITR;i++) {
        float fi = float(i)+1.;
        float h = hash(fi + seed);
        vec2 h2 = hash2(fi + seed);

        q = p *  GLITCH_RECT_DIVISION * fi + h2;
        q *= hash2(fi + seed)*2.-1.;
    	vec2 iq = floor(q);
        vec2 fq = fract(q);
        float hq = hash(iq);
        if(hq<GLITCH_THR) {
        	p += hash2(iq)*2.-1.;
            g = h;
        }
    }
    return vec3(fract(p), g);
}


vec4 tex(in vec2 uv) { return texture(iChannel0, uv); }

vec3 pattern0(in vec2 uv, in vec3 g) { return tex(uv).rgb; }
vec3 pattern1(in vec2 uv, in vec3 g) { return g.z<0. ? tex(uv).rgb : g.z * tex(uv).rgb; }
vec3 pattern2(in vec2 uv, in vec3 g) { return g.z<0. ? tex(uv).rgb : tex(uv+vec2(0.1*(g.z*2.-1.), 0.)).rgb; }
vec3 pattern3(in vec2 uv, in vec3 g) { return g.z<0. ? tex(uv).rgb : 1.-tex(uv).rgb; }
vec3 pattern4(in vec2 uv, in vec3 g) { return g.z<0. ? tex(uv).rgb : tex(g.xy).rgb; }
#define RGB_SHIFT (g.z*vec3(0.16, 0.04, -0.8))
vec3 pattern5(in vec2 uv, in vec3 g) { return g.z<0. ? tex(uv).rgb : vec3(tex(uv+vec2(RGB_SHIFT.r, 0.)).r, tex(uv+vec2(RGB_SHIFT.g, 0.)).g, tex(uv+vec2(RGB_SHIFT.b, 0.)).b); }

void mainImage()
{
    vec2 uv = fragCoord/iResolution.xy;
    
    float gps = 15.;// glitch per seconds
	vec3 g = glitch(uv, floor(iTime*gps)/gps);
    
    vec3 col = vec3(0.);
    if (ENABLE_MODE==0) {
        float m = mod(iTime, 6.);
        col = 
            m<1. ? pattern0(uv, g) : 
            m<2. ? pattern1(uv, g) : 
            m<3. ? pattern2(uv, g) : 
            m<4. ? pattern3(uv, g) : 
            m<5. ? pattern4(uv, g) : 
            			 pattern5(uv, g) ;
    } else {
        col =
            MODE==0 ? pattern0(uv, g) : 
            MODE==1 ? pattern1(uv, g) : 
            MODE==2 ? pattern2(uv, g) : 
            MODE==3 ? pattern3(uv, g) : 
            MODE==4 ? pattern4(uv, g) : 
            MODE==5 ? pattern5(uv, g) : 
            vec3(0.);
    }

    // Output to screen
    gl_FragColor = vec4(col,1.0);
gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}