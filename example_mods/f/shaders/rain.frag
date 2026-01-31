#pragma header

//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20201014 (stegu)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
//

// ALL UNUSED THINGS WERE DELETED FROM ORIGINAL SHADER!!!
// things people keep crying about idk, do note that this was supposed to be in pragma header
// ported by cyachao but who cares lmao, this shader preserves the camera scroll

#define screenCoord openfl_TextureCoordv
uniform vec2 uScreenResolution;
uniform vec4 uCameraBounds;

vec2 screenToWorld(vec2 screenCoord)
{
	vec2 scale = vec2(uCameraBounds.z - uCameraBounds.x, uCameraBounds.w - uCameraBounds.y);
	vec2 offset = vec2(uCameraBounds.x, uCameraBounds.y);
	return screenCoord * scale + offset;
}

vec2 worldToScreen(vec2 worldCoord)
{
	vec2 scale = vec2(uCameraBounds.z - uCameraBounds.x, uCameraBounds.w - uCameraBounds.y);
	vec2 offset = vec2(uCameraBounds.x, uCameraBounds.y);
	return (worldCoord - offset) / scale;
}

vec2 bitmapCoordScale()
{
	return openfl_TextureCoordv / screenCoord;
}

vec2 screenToBitmap(vec2 screenCoord)
{
	return screenCoord * bitmapCoordScale();
}

vec4 sampleBitmapScreen(vec2 screenCoord)
{
	return texture2D(bitmap, screenToBitmap(screenCoord));
}

vec4 sampleBitmapWorld(vec2 worldCoord)
{
	return sampleBitmapScreen(worldToScreen(worldCoord));
}

// common
vec3 mod289(vec3 x) {
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
	return mod289(((x*34.0)+10.0)*x);
}

vec4 taylorInvSqrt(vec4 r) {
	return 1.79284291400159 - 0.85373472095314 * r;
}

float rand(vec2 a) {
	return fract(sin(dot(mod(a, vec2(1000.0)).xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// actual shader
uniform float uScale;
uniform float uIntensity;
uniform float uTime;

float ease(float t) {
	return t * t * (3.0 - 2.0 * t);
}

float rainDist(vec2 p, float scale, float intensity) {
	p *= 0.1;
	p.x += p.y * 0.1;
	p.y -= uTime * 500.0 / scale;
	p.y *= 0.03;
	float ix = floor(p.x);
	p.y += mod(ix, 2.0) * 0.5 + (rand(vec2(ix)) - 0.5) * 0.3;
	float iy = floor(p.y);
	vec2 index = vec2(ix, iy);
	p -= index;
	p.x += (rand(index.yx) * 2.0 - 1.0) * 0.35;
	vec2 a = abs(p - 0.5);
	float res = max(a.x * 0.8, a.y * 0.5) - 0.1;
	bool empty = rand(index) < mix(1.0, 0.1, intensity);
	return empty ? 1.0 : res;
}

void main() {
	vec2 wpos = screenToWorld(screenCoord);
	vec2 origWpos = wpos;
	float intensity = uIntensity;

	vec3 add = vec3(0);
	float rainSum = 0.0;

	const int numLayers = 4;
	float scales[4];
	scales[0] = 1.0;
	scales[1] = 1.8;
	scales[2] = 2.6;
	scales[3] = 4.8;

	for (int i = 0; i < numLayers; i++) {
		float scale = scales[i];
		float r = rainDist(wpos * scale / uScale + 500.0 * float(i), scale, intensity);
		if (r < 0.0) {
			float v = (1.0 - exp(r * 5.0)) / scale * 2.0;
			wpos.x += v * 10.0 * uScale;
			wpos.y -= v * 2.0 * uScale;
			add += vec3(0.1, 0.15, 0.2) * v;
			rainSum += (1.0 - rainSum) * 0.75;
		}
	}

	vec3 color = sampleBitmapWorld(wpos).xyz;

	vec3 rainColor = vec3(0.4, 0.5, 0.8);
	color += add;
	color = mix(color, rainColor, 0.1 * rainSum);

	// alpha 1.0 doesn't really matter for camGame
	gl_FragColor = vec4(color, 1.0);
}
