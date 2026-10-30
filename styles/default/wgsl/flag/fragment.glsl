precision lowp float;

// Helper Functions
#include<helperFunctions>

// Entrées depuis le vertex shader
varying vec2 vUV;
varying float zOffset1;
varying float zOffset2;
flat varying int flagN;

uniform sampler2D textureSampler;

const vec4 colorBlue = vec4(0.0, 0.5, 1.0, 1.0);
const vec4 colorRed = vec4(0.85, 0.1, 0.0, 1.0);

void main(void) {
    vec4 c = vec4(0.0, 1.0, 0.0, 1.0);
    vec4 t = texture2D(textureSampler, vUV);
    // seems like babylonjs needs a var called alpha declared in shader when alphablending is set to true
    float alpha = t.a;
    #ifndef ALPHABLEND
        if (t.a < 0.4) discard;
    #endif

    if (flagN == 1) {
        if (t.g > 0.5) {
            c = t;
        } else {
            c = vec4(colorBlue.r, colorBlue.g, colorBlue.b, t.a);
        }
        c.rgb += zOffset1 * 2.0;
    } else if (flagN == 2) {
        if (t.g > 0.5) {
            c = t;
        } else {
            c = vec4(colorRed.r, colorRed.g, colorRed.b, t.a);
        }
        c.rgb += zOffset2 * 2.0;
    } else {
        c = t;
    }
    gl_FragColor = c;
}
