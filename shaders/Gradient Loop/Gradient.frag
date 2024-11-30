#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform vec4 iMouse;

#define PI 3.1415926535

// https://www.shadertoy.com/view/mdlXzS

float loopRad = 10.0;


float RGB2Luminosity(in vec3 color)
{
    return 0.3*color.r + 0.59*color.g + 0.11*color.b;
}

vec2 Gradient(in sampler2D u_tex, in vec2 st, in vec2 stepSize)
{
    float Gx = 0.0;
    Gx += RGB2Luminosity(texture(u_tex, st - vec2(stepSize.x, -stepSize.y)).rbg);
    Gx += 2.0 * RGB2Luminosity(texture(u_tex, st - vec2(stepSize.x, 0.0)).rbg);
    Gx += RGB2Luminosity(texture(u_tex, st - vec2(stepSize.x, stepSize.y)).rbg);

    Gx -= RGB2Luminosity(texture(u_tex, st + vec2(stepSize.x, -stepSize.y)).rbg);
    Gx -= 2.0 * RGB2Luminosity(texture(u_tex, st + vec2(stepSize.x, 0.0)).rbg);
    Gx -= RGB2Luminosity(texture(u_tex, st + vec2(stepSize.x, stepSize.y)).rbg);

    float Gy = 0.0;
    Gy -= RGB2Luminosity(texture(u_tex, st - vec2(-stepSize.x, stepSize.y)).rbg);
    Gy -= 2.0 * RGB2Luminosity(texture(u_tex, st - vec2(stepSize.x, stepSize.y)).rbg);
    Gy -= RGB2Luminosity(texture(u_tex, st - vec2(stepSize.x, stepSize.y)).rbg);

    Gy += RGB2Luminosity(texture(u_tex, st + vec2(-stepSize.x, stepSize.y)).rbg);
    Gy += 2.0 * RGB2Luminosity(texture(u_tex, st + vec2(stepSize.x, stepSize.y)).rbg);
    Gy += RGB2Luminosity(texture(u_tex, st + vec2(stepSize.x, stepSize.y)).rbg);
    return vec2(Gx, Gy);
}


void mainImage()
{
    vec2 uv = fragCoord / iResolution.xy;
    vec2 kernelStepSize = 1.0 / iResolution.xy;
    

    vec2 grad = Gradient(iChannel0, uv, kernelStepSize);
    //grad = grad/length(grad);

    loopRad = 5.0 * (iMouse.x / iResolution.x - 0.5);

    vec2 grad_tan = vec2(-grad.y, grad.x);

    vec2 loopedSample = uv + loopRad * kernelStepSize * grad * 2.0* sin(2.0 * iTime) + 2.0*loopRad * kernelStepSize *grad_tan * cos(2.0* iTime);
     
    fragColor = texture( iChannel0, loopedSample);
}


