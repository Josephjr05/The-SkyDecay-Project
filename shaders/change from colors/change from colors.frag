#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/cd2SDW
// Set the sensitivity
const float sensitivity = 1.5;


void mainImage() {
  // Set the blur weight
  
  vec3 edge = vec3(0.0);

  // Sample the pixels around the current pixel
  vec2 texcoord = fragCoord.xy;
  edge.r = texture(iChannel0, (texcoord + vec2(-1.0, -1.0)) / iResolution.xy).r;
  edge.r -= texture(iChannel0, (texcoord + vec2(1.0, 1.0)) / iResolution.xy).r;
  edge.g = texture(iChannel0, (texcoord + vec2(1.0, -1.0)) / iResolution.xy).g;
  edge.g -= texture(iChannel0, (texcoord + vec2(-1.0, 1.0)) / iResolution.xy).g;
  edge.b = texture(iChannel0, (texcoord + vec2(-1.0, 0.0)) / iResolution.xy).b;
  edge.b -= texture(iChannel0, (texcoord + vec2(1.0, 0.0)) / iResolution.xy).b;

  // Set the output color
  gl_FragColor = vec4(edge * sensitivity, 1.0);
}