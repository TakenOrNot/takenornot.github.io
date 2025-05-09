#version 300 es
precision lowp float;

// Outputs with explicit locations
layout(location = 0) out vec3 pos;
layout(location = 1) out vec3 vPosition;
layout(location = 2) out vec3 vNormal;
layout(location = 3) out vec2 vUV;


// Inputs with explicit locations
in vec3 position;
in vec3 normal;
in vec2 uv;

// Uniforms
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
                        //normalInterp = vec3(view * vec4(normal, 0));
                        //vec4 pos4b = view * world * vec4(position, 1.0);
                        
	                    //v1PositionFromLight = shadow1LightMat * world * p;
                    }