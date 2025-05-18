precision lowp float;

            // Attributes 
            attribute vec3 position;
            attribute vec3 normal;
            attribute vec2 uv;

            // Uniforms
            uniform mat4 worldViewProjection;
            //uniform mat4 world;

            uniform float time;
            uniform float time2;
            
            //uniform float posYObj1;
            //uniform float posYObj2;

            // Varying
            varying vec2 vUV;
            // REM : cant use flat nor pass integer in webgl 1
            #ifndef WEBGPU
            flat out int flagN;
            #endif

            #ifdef WEBGPU
            layout (location=6) flat out int flagN;
            #endif
            //varying float flagN;

            varying float zOffset1;
            varying float zOffset2;

            void main(void) {
               vec3 p = position;

               

               //vec4 pos4 = world * vec4(position, 1.0);
               //vec3 pos = vec3(pos4) / pos4.w;
               
               // REM : cant use flat nor pass integer in webgl GL 1
               int flagNtmp;
               //float flagNtmp;
               zOffset1 = 0.0;
               zOffset2 = 0.0;
               if (gl_VertexID > 21 && gl_VertexID < 34){
                  
                  //float vPosYObj1 = pos.y - posYObj1;
                  //float bn1 = floor(vPosYObj1 / 0.25);
                  

                  float bn1 = floor(position.y / 0.25);
                  zOffset1 = (sin(time + bn1) / 10.0);
                  
                  p.z = p.z + zOffset1;
                  
                  flagNtmp = 1;
               }
               if (gl_VertexID >= 34 && gl_VertexID < 38){
                  flagNtmp = 1;
               }
               if (gl_VertexID > 59 && gl_VertexID < 72){
                  
                  //float vPosYObj2 = pos.y - posYObj2;
                  //float bn2 = floor(vPosYObj2 / 0.25);
                  //zOffset2 = (sin(time2 + bn2) / 10.0);

                  float bn2 = floor(position.y / 0.25);
                  zOffset2 = (sin(time2 + bn2) / 10.0);

                  p.z = p.z + zOffset2;
                  
                  flagNtmp = 2;
               }
               if (gl_VertexID >= 72){
                  flagNtmp = 2;
               }
               flagN = flagNtmp;

               //vPositionW = worldViewProjection * vec4(p, 1.0);

               gl_Position = worldViewProjection * vec4(p, 1.0);

               vUV = uv;
            }