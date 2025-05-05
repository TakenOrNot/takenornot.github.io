precision lowp float;

                    attribute vec3 position;
                    attribute vec3 normal;
                    attribute vec2 uv;

                    uniform lowp float time;
                    uniform mat4 worldViewProjection;

                    uniform vec3 cameraPos;
                    //uniform mat4 shadow0LightMat;
                    //uniform mat4 shadow1LightMat;
                    //Varying
                    //varying vec4 v0PositionFromLight;
                    //varying vec4 v1PositionFromLight;
                    

                    // = inverse transpose of modelViewMatrix
                    // REM: modelViewMatrix is "world" in babylonjs
                    uniform mat3 normalMatrix;
                    uniform mat4 view;
                    uniform mat4 world;

                    varying vec3 pos;
                    varying vec3 vPosition;
                    varying vec3 vNormal;
                    varying vec2 vUV;
                    // varying vec3 normalInterp;
                    varying vec4 pos4b;
                    

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