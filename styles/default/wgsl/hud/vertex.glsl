precision lowp float;

// Attributs (emplacements gérés par Babylon)
attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

// Sorties vers le fragment shader (appariées par nom par Babylon)
varying vec3 pos;
varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vUV;

uniform float time;
uniform mat4 worldViewProjection;
uniform vec3 cameraPos;
uniform mat3 normalMatrix;
uniform mat4 view;
uniform mat4 world;

void main(void) {
    vec4 p = vec4(position, 1.0);
    gl_Position = worldViewProjection * p;

    vPosition = position;
    vNormal = normal;
    vUV = uv;

    vec4 pos4 = world * vec4(position, 1.0);
    pos = vec3(pos4) / pos4.w;
}
