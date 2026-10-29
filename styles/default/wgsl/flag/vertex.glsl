// === Input variables ===
layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 uv;

layout(location = 0) out vec2 vUV;
layout(location = 1) out float zOffset1;
layout(location = 2) out float zOffset2;
layout(location = 3) flat out int flagN;

uniform mat4 worldViewProjection;
uniform float time;
uniform float time2;

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