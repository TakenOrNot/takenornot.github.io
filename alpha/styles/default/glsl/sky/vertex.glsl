precision lowp float;
            attribute vec3 position;
            attribute vec3 normal;
            attribute vec2 uv;
            uniform mat4 worldViewProjection;
            uniform mat4 world;
            uniform vec3 cameraPosition;
            uniform float flyCam;

            varying float clipped;
            
            varying vec4 vPosition;
            varying vec3 vNormal;
            varying vec3 pos;

            //varying float isInMapBounds;
            varying lowp float fogDensity;
            varying lowp float distd;

            const lowp float fogStart = 10.0;
            const lowp float maxdist = 30.0;

            const lowp float overDrawOffset = 14.0;

            void main(void){
                vec4 p = vec4(position,1.);
                
                gl_Position = worldViewProjection * p;
                
                vPosition = p;
                vNormal = normal;
                vec4 pos4 = world * vec4(position, 1.0);
                
                pos = vec3(pos4) / pos4.w;
                
                distd = sqrt(pow(pos.x-cameraPosition.x, 2.0) + pow(pos.z-cameraPosition.z, 2.0));
                fogDensity = (max(0.0,distd - fogStart) / maxdist);
                
                lowp float isInMapBounds = pos.x < 164.0 && pos.x > -164.0 && pos.z < 82.0 && pos.z > -82.0 ? 1.0 : 0.0;

                
                if (flyCam == 1.0){
                    clipped = (
                        fogDensity < 0.5 ||
                        fogDensity > 2.5 ||
                        any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
                        any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
                        ) ? 1.0 : 0.0;
                } else {
                    clipped = (
                        isInMapBounds > 0.0 ||
                        fogDensity > 2.5 ||
                        any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
                        any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
                        ) ? 1.0 : 0.0;
                }
                
                
            }