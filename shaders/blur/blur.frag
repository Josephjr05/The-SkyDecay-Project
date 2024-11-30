#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float random(vec2 st) { // borrowed from Book of Shaders
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float movement(vec2 coord) {
  return sin(coord.y + 1.5) * sin(iTime * random(coord)) * 0.025;
}


void mainImage()
{
  vec2 coord = fragCoord/iResolution.xy;
  coord.x -= movement(coord);
  coord.x += 0.1;
  vec4 redVal = texture(iChannel0, coord) * vec4(1.0, 0.0, 0.0, 1.0);
  coord.x -= movement(coord);
  vec4 greenVal = texture(iChannel0, coord) * vec4(0.0, 0.0, 1.0, 1.0);
  coord.x -= movement(coord);
  vec4 blueVal = texture(iChannel0, coord) * vec4(0.0, 1.0, 0.0, 1.0);

  vec4 c = redVal + blueVal + greenVal;

  fragColor = c;
}
