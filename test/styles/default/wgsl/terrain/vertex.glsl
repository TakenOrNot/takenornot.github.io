#version 300 es

// Set precision explicitly for float and int
precision mediump float;  // Medium precision for floats
precision mediump int;    // Medium precision for integers

// === Output variables with explicit locations ===
layout(location = 0) out vec2 vUV;             // UV coordinates
layout(location = 1) out vec2 vUV2;            // Second UV set
layout(location = 2) out vec2 vUV4;            // Third UV set
layout(location = 3) out vec4 vPosPack;        // xyz = pos, w = isSnow
layout(location = 4) out vec4 vFogPack;        // x=isInMapBounds, y=distd, z=fogDensity, w=clipped
layout(location = 5) out vec4 vLightShadow;    // xyz = lightDir, w = unused
layout(location = 6) out vec4 v0PositionFromLight; // shadow coordinates
layout(location = 7) out vec3 vPosition;      // World space position
layout(location = 8) out vec3 normalInterp;   // Transformed normal

#ifdef GAMEBTR
    layout(location = 9) out float distFromCenterOfFirewall;
#endif


// === Input variables ===
in vec3 position;  // Vertex position
in vec3 normal;    // Vertex normal
in vec2 uv;        // UV coordinates

// === Uniforms ===
uniform float minusOneToOneTime;
uniform mat4 worldViewProjection;
uniform vec3 cameraPosition;
uniform vec3 lightPos;
uniform vec2 firewall_pos;
uniform mat4 shadow0LightMat;
uniform mat4 view;
uniform mat4 world;
uniform float flyCam;

void main(void) {
    vec4 p = vec4(position, 1.0);

    // Process UV coordinates
    vec2 localUV = uv;
    localUV.x *= 2.0; // Adjust UV for aspect ratio
    vPosition = position;
    
    // World position calculation
    vec4 pos4 = world * p;
    vec3 posWorld = vec3(pos4) / pos4.w;

    // Process other variables
    vec2 localUV2 = vec2(0.0);
    float distFromCenter = 0.0;
    #ifdef GAMEBTR
        localUV2 = vec2(posWorld.x / 5.0, posWorld.z / 5.0) + minusOneToOneTime;
        distFromCenter = sqrt(pow(posWorld.x - firewall_pos.x, 2.0) + pow(posWorld.z - firewall_pos.y, 2.0));
        distFromCenterOfFirewall = distFromCenter;
    #endif

    // Calculate normal and other per-vertex values
    normalInterp = normalize(vec3(view * vec4(normal, 0.0))); // Transform normal to view space

    // === Explicitly Convert Booleans to Floats ===
    float isInMapBounds = (posWorld.x < 164.0 && posWorld.x > -164.0 && posWorld.z < 82.0 && posWorld.z > -82.0) ? 1.0 : 0.0;

    // Fix for isSnow expression:
    float isSnow = (float(posWorld.x < -12.0) * float(posWorld.x > -52.0 - (14.0 * clamp((abs(posWorld.z) - 40.0) / 20.0, 0.0, 1.0)))) + 
               (14.0 * clamp((abs(posWorld.z) - 65.0) / 20.0, 0.0, 1.0)) > 0.0 && (posWorld.z > 40.0) ? 1.0 : 0.0;

    // Calculate distance to camera and fog density
    float distd = distance(vec2(posWorld.x, posWorld.z), vec2(cameraPosition.x, cameraPosition.z));
    float fogDensity = max(0.0, distd - 10.0) / 25.0;

    // Light position and shadow matrix calculations
    v0PositionFromLight = shadow0LightMat * world * p;

    // Light direction (in view space)
    vec3 lightDir = vec3(-0.5, 1.0, 0.0);

    // Final vertex position in screen space
    vec2 localUV4 = vec2(pos4.x / 2.0, pos4.z);
    gl_Position = worldViewProjection * p;

    // Fix for clipped calculation:
    float overDrawOffset = (flyCam == 1.0) ? 5.0 : 14.0;
    float clipped = (isInMapBounds == 0.0 || position.y < 0.0 || fogDensity > 1.5 || 
                    any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
                    any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))) ? 1.0 : 0.0;

    // Assign values to output variables
    vUV = localUV;
    vUV2 = localUV2;
    vUV4 = localUV4;
    vPosPack = vec4(posWorld, isSnow);
    vFogPack = vec4(isInMapBounds, distd, fogDensity, clipped);
    vLightShadow = vec4(lightDir, 0.0);
}