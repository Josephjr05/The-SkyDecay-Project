//https://www.shadertoy.com/view/7sySDm

#pragma header
vec2 _uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main


#define PI 3.14159265
#define Degree /180.*PI

uniform float fov = 2.0;
uniform bool invert = false;

float fishEyeCorrection (float fov, vec2 uv) {
    float x = uv.x;
    float y = uv.y;
    float z = 1.0/tan(fov / 2.0);


    float xy_len = length(uv);//sqrt(x*x+y*y);

    //float a = atan(x, y);
    float b = atan(xy_len, z);
    float k = 2.0*b/(xy_len*fov);

    return k;
}

void mainImage( )
{
    // Normalized pixel coordinates (from 0 to 1)
    
    
    vec2 uv = fragCoord/iResolution.xy*2.0 - 1.0;
    
    float aspect = iResolution.x/iResolution.y;
   // uv.y /= aspect;
    float _fov = fov Degree;
    float k = fishEyeCorrection (_fov, uv); 


    vec2 new_uv;
    
         if(invert){
         	new_uv = vec2(uv.x*k, uv.y*k); //less fisheye
    	}else{
         	new_uv = vec2(uv.x/k, uv.y/k); //more fisheye
	}

    vec4 col = texture(iChannel0, (new_uv+1.0) / 2.0);

    if(fov == 0.0)col = texture(iChannel0,_uv);
    // Output to screen
    fragColor = col;
}