#version 300 es
precision lowp float;

// Uniforms
uniform float minusOneToOneTime;
uniform mat4 worldViewProjection;
uniform vec3 cameraPosition;
// uniform vec3 lightPos;
uniform vec2 firewall_pos;
uniform mat4 shadow0LightMat;
uniform mat4 view;
uniform mat4 world;
uniform float flyCam;

// Attributes
in vec3 position;
in vec3 normal;
in vec2 uv;

// Varyings
out float clipped;
out vec4 v0PositionFromLight;
out float isSnow;
out vec3 pos;
out vec3 vPosition;
out vec2 vUV;
out vec2 vUV2;
out vec2 vUV4;
out vec3 normalInterp;
out float isInMapBounds;
out float distd;
out float fogDensity;
out vec3 lightDir;

#ifdef GAMEBTR
    out float distFromCenterOfFirewall;
#endif

// Constants
const float fogStart = 10.0;
const float maxdist = 25.0;

void main(void) {
    vec4 p = vec4(position, 1.0);
    
    // Pass through position and UV data
    vPosition = position;
    vUV = uv * vec2(2.0, 1.0); // Correct UV scaling
    
    // World position calculation
    vec4 pos4 = world * p;
    pos = pos4.xyz / pos4.w;
    
    // GAMEBTR specific calculations
    #ifdef GAMEBTR
        vUV2 = vec2(pos.x/5.0, pos.z/5.0) + minusOneToOneTime;
        distFromCenterOfFirewall = distance(pos.xz, firewall_pos);
    #endif
    
    // Normal transformation to view space
    normalInterp = mat3(view) * normal;
    
    // Map bounds check
    isInMapBounds = (pos.x < 164.0 && pos.x > -164.0 && pos.z < 82.0 && pos.z > -82.0) ? 1.0 : 0.0;
    
    // Fog calculation
    distd = distance(pos.xz, cameraPosition.xz);
    //fogDensity = clamp((max(0.0, distd - fogStart) / maxdist), 0.0, 1.0);
    fogDensity = (max(0.0,distd - fogStart) / maxdist);
    
    // Shadow position calculation
    v0PositionFromLight = shadow0LightMat * pos4;
    
    // Light direction (simplified fixed direction)
    lightDir = normalize(vec3(-0.5, 1.0, 0.0));
    
    // Snow region detection
    //float snowXMin = -52.0 - (14.0 * clamp((abs(pos.z)-40.0)/20.0, 0.0, 1.0));
    //float snowXMax = -12.0 + (14.0 * clamp((abs(pos.z)-65.0)/20.0, 0.0, 1.0));
    //isSnow = (pos.x < snowXMax && pos.x > snowXMin && pos.z > 40.0) ? 1.0 : 0.0;
    // temporary hack until we use some mixmap texture to set climates/biomes
    isSnow = pos.x < -12.0 && pos.x > -52.0 - (14.0 * clamp((abs(pos.z)-40.0) / 20.0,0.0,1.0)) + (14.0 * (clamp((abs(pos.z)-65.0) / 20.0,0.0,1.0))) && pos.z > 40.0 ? 1.0 : 0.0;

    // Additional UV calculations
    vUV4 = pos4.xz * 0.5;
    
    // Final position calculation
    gl_Position = worldViewProjection * p;
    
    // Clipping logic
    float overDrawOffset = flyCam == 1.0 ? 5.0 : 14.0;
    clipped = (
        isInMapBounds == 0.0 ||
        vPosition.y < 0.0 ||
        fogDensity > 1.5 ||
        any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
        any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
    ) ? 1.0 : 0.0;
}