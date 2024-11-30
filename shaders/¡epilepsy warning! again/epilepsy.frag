#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/mdSXWw

void mainImage()
{
//video input
vec2 uv = fragCoord.xy / iResolution.xy;
vec3 video = texture(iChannel0, uv).rgb; //<insert link here, temprorary unavaliable>

//acid glitching effect
vec3 color = vec3(0.0);
color.r = sin(video.r * 3.1415 + iTime);
color.g = cos(video.g * 20.3 - iTime);
color.b = sin(video.b *5.0 + iTime);

//uv.y = sin((uv.y + uv.x)*0.8 + iTime);
//add x color movements
color.r += tan((uv.x * 30.9)+ iTime);
color.g += cos((uv.y * 1000.9));
color.b += cos((uv.x * uv.y)*0.1 - iTime);

//add some x and y movements -_-
//uv.x = tan((uv.y + uv.x)*8.0 + iTime);
//uv.x = tan((uv.y + uv.x)*2.0 + iTime);
//uv.y = tan((uv.x * iTime)/0.8);

fragColor = vec4(color, 1.0);
gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;

}








