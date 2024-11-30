#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/4sjXzm
// TV Moire Pattern Effect
// by rinf 2014.
//
// Simulates a TV screen consisting of RGB pixels and a camera filming the screen,
// which creates a nice Moire pattern.
//
// Use fullscreen mode for best experience
//
// Press 'x' to toggle effect on and off

#define KEY_X 88.5/256.0
#define TV_SCREEN_RESOLUTION_X 640.0

struct Rectangle
{
    vec3 v1;
    vec3 v2;
    vec3 v3;
};

vec3 CalcNormal(Rectangle A)
{
 vec3 first = A.v1 - A.v2;
 vec3 second = A.v2 - A.v3;
    
 return cross(first,second);
}

vec3 Intersect(vec3 B, vec3 r, vec3 A, vec3 p)
{
 float u=0.0;
 if (r.x*p.x+r.y*p.y+r.z*p.z!=0.0)
 {
 	u =  (dot(A,p)-dot(B,p))/(dot(r,p));
 }
 
 return B+r*u;
}

vec2 Calc_ul(vec3 B, vec3 C, vec3 r, vec3 s)
{
    float l = (C.y*r.x-B.y*r.x-C.x*r.y+B.x*r.y)/(s.y-s.x*r.y);
    float u = 0.0;
	if (r.x==0.0)
	{
		u=0.0;
	}
	else
	{
		u = (C.x-B.x-l*s.x)/r.x;
	}
    
    return vec2(u,l);
}

vec3 GetScreenPixelColor(vec2 ul)
{
    float x = mod(ul.x * TV_SCREEN_RESOLUTION_X / (1600.0/iResolution.x) * 3.0,3.0);

    vec3 tex = texture(iChannel0, vec2(ul.x,ul.y) ).xyz;
    
    return mix(mix(vec3(tex.r,0.0,0.0),vec3(0.0,tex.g,0.0),step(1.0,x)),
              vec3(0.0,0.0,tex.b),step(2.0,x));
}

void mainImage()
{
	vec2 q = fragCoord.xy / iResolution.xy;
    
    vec2 rect_offset = vec2(-0.5, -0.5);
    float zoom = 0.9+sin(iTime*0.3)*0.55;
 
    Rectangle rect;
    rect.v1 = vec3(0.1+rect_offset.x, 0.1+rect_offset.y, 0.4+sin(iTime*1.5)*0.15);
    rect.v2 = vec3(0.1+rect_offset.x, 0.9+rect_offset.y, 0.5+sin(iTime*1.5)*0.15);
    rect.v3 = vec3(0.9+rect_offset.x, 0.9+rect_offset.y, 0.5+cos(iTime*1.0)*0.15);
    
    float bu = abs(rect.v2.x - rect.v3.x);
    float bl = abs(rect.v1.y - rect.v2.y);
    
    
    vec3 rect_normal_vector = CalcNormal(rect);
    rect_normal_vector = normalize(rect_normal_vector);
    
    vec3 plane_vector1 = normalize(rect.v2 - rect.v1);
    vec3 plane_vector2 = normalize(rect.v3 - rect.v2);
    
    
    vec3 screen_vector = vec3( q.x/10.0 , q.y/10.0 , -1);
    vec3 camera = vec3( q.x-0.5, q.y+0.5, zoom);
    vec3 ray = camera - screen_vector;
    vec3 intersection = Intersect(camera,ray,rect.v3,rect_normal_vector);
    
    vec2 ul = Calc_ul(rect.v2, intersection, plane_vector2, plane_vector1);
	vec3 new_col = vec3(0.0, 0.0, 0.0);
    vec3 old_col = vec3(0.0, 0.0, 0.0);
    
    if (ul.x>0.0 && ul.x<1.0 && ul.y>0.0 && ul.y<1.0)
    {
        float count=0.0;
        
        for (float i=-1.0;i<1.0;i+=0.33)
        {
            new_col += GetScreenPixelColor(vec2(ul.x+i/iResolution.x,ul.y));
            count = count + 1.0;
        }

        new_col = 3.0*new_col/count;
        old_col = texture(iChannel0, vec2(ul.x,ul.y) ).xyz;
    }
    
    
        new_col =old_col;
        
    fragColor = vec4(new_col,1.0);

gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}