precision lowp float;

// Attributs (emplacements gérés par Babylon)
attribute vec3 position;
attribute vec2 uv;

#ifdef VERTEXCOLOR
    attribute vec4 color;
    varying vec4 vColor;
#endif

// Sorties vers le fragment shader : uniquement ce qu'il lit.
// L'ancienne version passait 17 varyings, au-delà de la limite WebGPU
// de 16 variables entre étapes.
varying vec2 vUV;

uniform mat4 worldViewProjection;

void main(void) {
    vUV = uv;
    gl_Position = worldViewProjection * vec4(position, 1.0);

    // Vertex color
    #include<vertexColorMixing>
}
