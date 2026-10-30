precision lowp float;

// Entrées depuis le vertex shader
varying float clipped;
varying float fogDensity;

void main(void) {
    vec4 color4 = vec4(0.0, 0.0, 0.0, 1.0);

    if (clipped > 0.0 || fogDensity >= 1.22) {
        discard;
    }

    gl_FragColor = color4;

    #include<imageProcessingCompatibility>
}
