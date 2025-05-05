
                    precision lowp float;
                    //precision mediump float;
    
                    attribute vec3 position;
                    attribute vec3 normal;
                    attribute vec2 uv;
                    
                    uniform float minusPiToPiTime;
                    uniform float sinTime;
                    uniform vec3 cameraPosition;
                    //uniform lowp float flyCam;
                    uniform float flyCam;

                    uniform vec3 cameraPos;
                    uniform mat4 shadow0LightMat;
                    //uniform mat4 shadow1LightMat;
                    //Varying
                    varying vec4 v0PositionFromLight;
                    //varying vec4 v1PositionFromLight;

                    uniform vec4 worldPosition;

                    uniform mat4 worldViewProjection;
                    //uniform lowp float time;
                    uniform float minusOneToOneTime;
                    //uniform mat3 normalMatrix;
                    uniform mat4 normalMatrix;
                    uniform vec2 vNormalInfos;


                    uniform mat4 view;
                    uniform mat4 world;

                    //include<clipPlaneVertexDeclaration>

                    uniform vec2 firewall_pos;

                    uniform float vScale;

                    varying float clipped;

                    varying vec3 vPosition;
                    varying vec3 vNormal;
                    varying vec2 vUV;
                    varying vec2 vUV2;

                    //varying vec2 vUV3;
                    varying vec2 vUV4;

                    //varying vec4 normalInterp;

                    varying vec4 positionCS;
                    varying vec3 screenPos;

                    varying vec3 pos;
                    //varying vec4 normalInterp;

                    varying lowp float displacement;

                    

                    //float fFogDistance;
                    //varying lowp float isInMapBounds;
                    varying lowp float isInMapBoundsStrict;
                    
                    varying lowp float distd;
                    varying lowp float fogDensity;

                    const lowp float fogStart = 10.0;
                    const lowp float maxdist = 30.0;

                    #ifdef GAMEBTR
                        varying lowp float distFromCenterOfFirewall;
                    #endif

                    //
                    // GLSL textureless classic 3D noise "cnoise",
                    // with an RSL-style periodic variant "pnoise".
                    // Author:  Stefan Gustavson (stefan.gustavson@liu.se)
                    // Version: 2011-10-11
                    //
                    // Many thanks to Ian McEwan of Ashima Arts for the
                    // ideas for permutation and gradient selection.
                    //
                    // Copyright (c) 2011 Stefan Gustavson. All rights reserved.
                    // Distributed under the MIT license. See LICENSE file.
                    // https://github.com/ashima/webgl-noise
                    //
/*
                    vec3 mod289(vec3 x) {
                        return x - floor(x * (1.0 / 289.0)) * 289.0;
                    }

                    vec4 mod289(vec4 x) {
                        return x - floor(x * (1.0 / 289.0)) * 289.0;
                    }

                    vec4 permute(vec4 x) {
                        return mod289(((x*34.0)+1.0)*x);
                    }

                    vec4 taylorInvSqrt(vec4 r) {
                        return 1.79284291400159 - 0.85373472095314 * r;
                    }

                    vec3 fade(vec3 t) {
                        return t*t*t*(t*(t*6.0-15.0)+10.0);
                    }

                    */

                    // Include the Ashima code here!

                    //varying lowp float noise;
                    
                    
                    

                    // not used
                    /*
                    float turbulence( vec3 p ) {
                        float w = 100.0;
                        float t = -.5;
                        for (float f = 1.0 ; f <= 10.0 ; f++ ){
                        float power = pow( 2.0, f );
                        t += abs( pnoise( vec3( power * p ), vec3( 10.0, 10.0, 10.0 ) ) / power );
                        }
                        return t;
                    }
                    */

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