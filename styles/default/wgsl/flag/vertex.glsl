precision lowp float;

// Attributs (emplacements gérés par Babylon)
attribute vec3 position;
attribute vec2 uv;

// Sorties vers le fragment shader
varying vec2 vUV;
varying float zOffset1;
varying float zOffset2;
flat varying int flagN;

uniform mat4 worldViewProjection;
uniform float time;
uniform float time2;

void main(void) {
    vec3 p = position;

    // initialisé : sinon valeur indéfinie pour les sommets d'indice <= 21
    int flagNtmp = 0;
    zOffset1 = 0.0;
    zOffset2 = 0.0;

    if (gl_VertexID > 21 && gl_VertexID < 34) {
        float bn1 = floor(position.y / 0.25);
        zOffset1 = (sin(time + bn1) / 10.0);
        p.z = p.z + zOffset1;
        flagNtmp = 1;
    }
    if (gl_VertexID >= 34 && gl_VertexID < 38) {
        flagNtmp = 1;
    }
    if (gl_VertexID > 59 && gl_VertexID < 72) {
        float bn2 = floor(position.y / 0.25);
        zOffset2 = (sin(time2 + bn2) / 10.0);
        p.z = p.z + zOffset2;
        flagNtmp = 2;
    }
    if (gl_VertexID >= 72) {
        flagNtmp = 2;
    }
    flagN = flagNtmp;

    gl_Position = worldViewProjection * vec4(p, 1.0);
    vUV = uv;
}
