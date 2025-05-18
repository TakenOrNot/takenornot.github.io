#version 300 es
precision mediump float;

// Outputs (with explicit locations)
layout(location = 0) out vec4 v0PositionFromLight;
layout(location = 1) out float clipped;
layout(location = 2) out vec3 vPosition;
layout(location = 3) out vec3 vNormal;
layout(location = 4) out vec2 vUV;
layout(location = 5) out vec2 vUV2;
layout(location = 6) out vec2 vUV4;
layout(location = 7) out vec4 positionCS;
layout(location = 8) out vec3 screenPos;
layout(location = 9) out vec3 pos;
layout(location = 10) out float displacement;
layout(location = 11) out float isInMapBoundsStrict;
layout(location = 12) out float distd;
layout(location = 13) out float fogDensity;

#ifdef GAMEBTR
    layout(location = 14) out float distFromCenterOfFirewall;
#endif

// Uniforms
uniform float minusPiToPiTime;
uniform float sinTime;
uniform vec3 cameraPosition;
uniform float flyCam;
uniform vec3 cameraPos;
uniform mat4 shadow0LightMat;
uniform vec4 worldPosition;
uniform mat4 worldViewProjection;
uniform float minusOneToOneTime;
uniform mat4 normalMatrix;
uniform vec2 vNormalInfos;
uniform mat4 view;
uniform mat4 world;
uniform vec2 firewall_pos;
uniform float vScale;

in vec3 position;
in vec3 normal;
in vec2 uv;

// Constants (maintained from original)
const float fogStart = 10.0;
const float maxdist = 30.0;




                    void main(void) {
                        
                        
                        vec3 v = position;
                        
                        vec4 p = vec4(position, 1.0);

                        vec4 pos4 = world * vec4(v, 1.0);

                        pos = vec3(pos4) / pos4.w;

                        //vec3 posDT = vec3(pos4.x*10.0, pos4.y, pos4.z*20.0)/ pos4.w;

                        // REM: base noise on pos instead of position for compatibility with dynamic terrain
                        //noise = pnoise( 100.915 * (pos) + vec3( 2.0 * (time/10.0)), vec3( 100.0) );
                        //displacement = 0.1 * noise;
                        //v = position + normal * displacement;
                        
                        // cheaper, not as nice, simple sin function
                        //displacement = sin(pos.z - time) * cos(pos.x - time) * 0.025;
                        displacement = 0.0;
                        #ifndef MOBILEDEVICE
                            displacement = sin(pos4.z - minusPiToPiTime) * cos(pos4.x - minusPiToPiTime) * 0.025;
                        #endif
                        //
                        //v.y += sin(pos.z - time) * 0.05;    
                        
                        v = position + normal * displacement;
                        //v = position;
                        

                        gl_Position = worldViewProjection * vec4(v, 1.0);

                        

                        positionCS = gl_Position;

                        vPosition = position;
                        vNormal = normal;


                        screenPos = vec3(positionCS.xy / positionCS.w,position.y);

                        // normalInterp = normalMatrix * normal;
                        
                        //normalInterp = normalMatrix * vec4(0., 0.,0., 0.);

                        
                        vUV = vec2(pos.x/5.0,pos.z/5.0) + minusOneToOneTime;
                        vUV2 = vec2(pos.x/10.0,pos.z/10.0) - minusOneToOneTime;

                        vUV4 = vec2(pos4.x / 2.0,pos4.z * vScale);

                        //vUV3 = vec2(0.5 + ((pos.x / 163.0) / 2.0), 0.5 + ((pos.z / 163.0) / 2.0));
                        
                        
                        //vUV = vec2(normalMatrix * vec4((uv * 1.0) / 5.0 + time * 1.0 , 1.0, 0.0));
                        
                        // vUV.x = vUV.x / 2.0;
                        
                        
                        //include<clipPlaneVertex>
                        
                        //fFogDistance = ((view * vec4(pos,1.0)).z);
                        
                        //isInMapBounds = pos.x < 163.84 && pos.x > -163.84 && pos.z < 81.92 && pos.z > -81.92 ? 1.0 : 0.0;
                        // isInMapBounds = pos.x < 166.0 && pos.x > -166.0 && pos.z < 84.0 && pos.z > -84.0 ? 1.0 : 0.0;
                        isInMapBoundsStrict = pos.x < 163.0 && pos.x > -163.0 && pos.z < 81.0 && pos.z > -81.0 ? 1.0 : 0.0;
                        //isInMapBoundsStrict = pos.x < 166.0 && pos.x > -166.0 && pos.z < 84.0 && pos.z > -84.0 ? 1.0 : 0.0;
                        
                        //isInMapBounds = pos.x < 200.0 && pos.x > -200.0 && pos.z < 100.0 && pos.z > -100.0 ? 1.0 : 0.0;
                        
                        //if (isInMapBounds == 1.0 && flyCam == 1.0){

                            //fogDensity = clamp(((view * vec4(pos,1.0)).z)/ maxdist,0.0,1.0);
                            //distd = (view * worldPosition).z;
                            distd = sqrt(pow(pos.x-cameraPosition.x, 2.0) + pow(pos.z-cameraPosition.z, 2.0));
                            
                            //fogDensity = (maxdist - distd) / (maxdist - fogStart);
                            fogDensity = max(0.0,distd-fogStart) / maxdist;
                            float overDrawOffset = flyCam == 1.0 ? 14.0 : 100.0;
                            clipped = (
                                fogDensity > 1.5 ||
                                any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
                                any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
                                ) ? 1.0
                                : 0.0;

                            #ifdef GAMEBTR
                                distFromCenterOfFirewall = sqrt(pow(pos.x-firewall_pos.x, 2.0) + pow(pos.z-firewall_pos.y, 2.0));
                            #endif
                        //}
                        
                        
                        v0PositionFromLight = shadow0LightMat * world * p;
	                    //v1PositionFromLight = shadow1LightMat * world * p;
                    }