precision mediump float;

// Attributs (emplacements gérés par Babylon)
// REM : "uv" retiré, il n'était pas utilisé et cassait le pipeline WebGPU
// sur les meshes sans coordonnées de texture
attribute vec3 position;
attribute vec3 normal;

// Sorties vers le fragment shader (uniquement celles qu'il lit)
varying vec4 v0PositionFromLight;
varying vec3 vNormal;
varying vec2 vUV;
varying vec2 vUV2;
varying vec2 vUV4;
varying vec4 positionCS;
varying vec3 pos;
varying float isInMapBoundsStrict;
varying float fogDensity;

#ifdef GAMEBTR
    varying float distFromCenterOfFirewall;
#endif

// Uniforms
uniform float minusPiToPiTime;
uniform float sinTime;
uniform vec3 cameraPosition;
uniform float flyCam;
uniform vec3 cameraPos;
uniform mat4 shadow0LightMat;
uniform vec4 worldPosition;
uniform mat4 worldViewProjection;
uniform float minusOneToOneTime;
uniform mat4 normalMatrix;
uniform vec2 vNormalInfos;
uniform mat4 view;
uniform mat4 world;
uniform vec2 firewall_pos;
uniform float vScale;

const float fogStart = 10.0;
const float maxdist = 30.0;

void main(void) {
    vec3 v = position;
    vec4 p = vec4(position, 1.0);
    vec4 pos4 = world * vec4(v, 1.0);
    pos = vec3(pos4) / pos4.w;

    // cheaper, not as nice, simple sin function
    float displacement = 0.0;
    #ifndef MOBILEDEVICE
        displacement = sin(pos4.z - minusPiToPiTime) * cos(pos4.x - minusPiToPiTime) * 0.025;
    #endif

    v = position + normal * displacement;

    gl_Position = worldViewProjection * vec4(v, 1.0);
    positionCS = gl_Position;

    vNormal = normal;

    vUV = vec2(pos.x / 5.0, pos.z / 5.0) + minusOneToOneTime;
    vUV2 = vec2(pos.x / 10.0, pos.z / 10.0) - minusOneToOneTime;
    vUV4 = vec2(pos4.x / 2.0, pos4.z * vScale);

    isInMapBoundsStrict = pos.x < 163.0 && pos.x > -163.0 && pos.z < 81.0 && pos.z > -81.0 ? 1.0 : 0.0;

    float distd = sqrt(pow(pos.x - cameraPosition.x, 2.0) + pow(pos.z - cameraPosition.z, 2.0));
    fogDensity = max(0.0, distd - fogStart) / maxdist;

    #ifdef GAMEBTR
        distFromCenterOfFirewall = sqrt(pow(pos.x - firewall_pos.x, 2.0) + pow(pos.z - firewall_pos.y, 2.0));
    #endif

    v0PositionFromLight = shadow0LightMat * world * p;
}
