precision lowp float;

// Attributs (emplacements gérés par Babylon)
// REM : "normal" et "uv" retirés, ce shader ne s'en sert pas
attribute vec3 position;

// Sorties vers le fragment shader : uniquement ce qu'il lit.
// L'ancienne version passait 16 varyings (17 avec GAMEBTR), au-delà de la
// limite WebGPU de 16 variables entre étapes. Le reste devient local.
varying float clipped;
varying float fogDensity;

uniform mat4 worldViewProjection;
uniform vec3 cameraPosition;
uniform mat4 world;
uniform float flyCam;

const float fogStart = 10.0;
const float maxdist = 25.0;

void main(void) {
    vec4 p = vec4(position, 1.0);

    vec4 pos4 = world * p;
    vec3 pos = vec3(pos4) / pos4.w;

    float isInMapBounds = pos.x < 164.0 && pos.x > -164.0 && pos.z < 82.0 && pos.z > -82.0 ? 1.0 : 0.0;

    float distd = distance(vec2(pos.x, pos.z), vec2(cameraPosition.x, cameraPosition.z));
    fogDensity = (max(0.0, distd - fogStart) / maxdist);

    gl_Position = worldViewProjection * p;

    float overDrawOffset = flyCam == 1.0 ? 5.0 : 14.0;
    clipped = (
        isInMapBounds == 0.0 ||
        position.y < 0.0 ||
        fogDensity > 1.5 ||
        any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
        any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
        ) ? 1.0
        : 0.0;
}
