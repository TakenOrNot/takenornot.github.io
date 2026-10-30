precision lowp float;

// Entrées depuis le vertex shader
varying vec2 vUV;

#ifdef VERTEXCOLOR
    varying vec4 vColor;
#endif

uniform sampler2D textureSamplerSmoke;

void main(void) {
    vec4 color4 = vec4(0.0, 0.0, 0.0, 1.0);

    vec4 t = texture2D(textureSamplerSmoke, vUV);
    // seems like babylonjs needs a var called alpha declared in shader when alphablending is set to true
    float alpha = t.a;
    #ifndef ALPHABLEND
        if (alpha < 0.2) discard;
    #endif
    #ifdef VERTEXALPHA
        alpha *= vColor.a;
        if (vColor.a < 0.4) discard;
    #endif

    gl_FragColor = color4 * alpha;

    #include<imageProcessingCompatibility>
}
