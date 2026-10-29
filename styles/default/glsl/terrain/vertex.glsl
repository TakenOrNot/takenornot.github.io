//version 300 es
                    precision lowp float;
                    //precision mediump float;

                    uniform float minusOneToOneTime;

                    attribute vec3 position;
                    attribute vec3 normal;
                    attribute vec2 uv;

                    //uniform lowp float time;
                    uniform mat4 worldViewProjection;

                    uniform vec3 cameraPosition;

                    //uniform vec3 cameraPos;

                    uniform vec3 lightPos;
                    varying vec3 lightDir;

                    uniform vec2 firewall_pos;

                    uniform mat4 shadow0LightMat;
                    //uniform mat4 shadow1LightMat;

                    

                    //uniform mat4 x;

                    // = inverse transpose of modelViewMatrix
                    // REM: modelViewMatrix is "world" in babylonjs
                    //uniform mat3 normalMatrix;
                    uniform mat4 view;
                    uniform mat4 world;

                    uniform float flyCam;

                    //Varyings
                    varying float clipped;
                    varying vec4 v0PositionFromLight;
                    //varying vec4 v1PositionFromLight;

                    

                    //varying vec3 vNormal;
                    //varying vec3 fPosition;

                    

                    varying float isSnow;

                    

                    //include<clipPlaneVertexDeclaration>

                    varying vec3 pos;
                    
                    //varying vec4 posModel;
                    varying vec3 vPosition;
                    //varying vec3 vPositionW;
                    //varying vec3 vNormal;
                    //varying vec3 vNormalW;
                    varying vec2 vUV;
                    varying vec2 vUV2;
                    //varying vec2 vUV3;
                    varying vec2 vUV4;
                    varying vec3 normalInterp;

                    varying float isInMapBounds;
                    
                    varying float distd;
                    varying float fogDensity;

                    const float fogStart = 10.0;
                    const float maxdist = 25.0;

                    #ifdef GAMEBTR
                        varying lowp float distFromCenterOfFirewall;
                    #endif
                    

                    // varying vec4 positionCS;
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
                    // bumpmapping stuff
                    //uniform sampler2D textureSamplerNorm_rocks;
                    //uniform sampler2D textureSamplerNorm_grass;

                    //uniform lowp sampler2D depth;

                    

                    void main(void) {
                        //noise = cnoise(vec3(100.0*position.y,100.0*position.y,100.0*position.y));
                        vec4 p = vec4(position, 1.0);
                        

                        vPosition = position;
                        //vNormal = normal;
                        vUV = uv;
                        
                        

                        // REM: get back to square ratio (terrain mesh is 2:1 ratio)
                        // TODO ? set this right into terrain's / terrainSpec's meshes UVs data
                        vUV.x = vUV.x * 2.0;
                        
                        vec4 pos4 = world * vec4(position, 1.0);
                        pos = vec3(pos4) / pos4.w;

                        #ifdef GAMEBTR
                            vUV2 = vec2(pos.x/5.0,pos.z/5.0) + minusOneToOneTime;
                            distFromCenterOfFirewall = sqrt(pow(pos.x-firewall_pos.x, 2.0) + pow(pos.z-firewall_pos.y, 2.0));
                        #endif

                        //vPositionW = vec3(world * vec4(position, 1.0));
                        
                        //posModel = world * view * vec4(position, 1.0);
                        
                        normalInterp = vec3(view * vec4(normal, 0));

                        //W = normalize(vec3(world * vec4(normal, 0.0)));
                        /*
                        vec3 snowC = vec3(0.0,1.0,0.0) * pos; // snow direction convertion to worldspace
                        if (dot(vNormal, snowC.xyz) >= -0.8 ) {
                        //    p.xyz += normalInterp * vec3(0.0, 1.0, 0.0);
                        } else {
                            p.xyz -= normalInterp * vec3(0.0, 0.0, 0.0);
                        }
                        */

                        //if (vPosition.y > 2.2) {
                        //    p.xyz += normal * vec3(2.0, 0.0, 2.0);
                        //} 
                        // else if (vPosition.y <= 1.0){
                           // p.xyz -= normal * vec3(0.0, 10.0, 0.0);
                        //}
                        //include<clipPlaneVertex>
                        
                        //isInMapBounds = pos.x < 163.84 && pos.x > -163.84 && pos.z < 81.92 && pos.z > -81.92 ? 1.0 : 0.0;
                        isInMapBounds = pos.x < 164.0 && pos.x > -164.0 && pos.z < 82.0 && pos.z > -82.0 ? 1.0 : 0.0;
                        
                        //if (isInMapBounds == 1.0 && flyCam == 1.0){
                            //distd = sqrt(pow(pos.x-cameraPosition.x, 2.0) + pow(pos.z-cameraPosition.z, 2.0));
                            distd = distance(vec2(pos.x,pos.z),vec2(cameraPosition.x,cameraPosition.z));
                            
                            fogDensity = (max(0.0,distd - fogStart) / maxdist);
                        
                            //fogDensity = ((view * pos4).z - fogStart) / maxdist;
                        //}
                        
                        //if (fogDensity < 1.2){
                        //    gl_Position = worldViewProjection * p;
                        //} else {
                            //gl_Position = 0.0/0.0; 
                        //}

                        
                        
                        v0PositionFromLight = shadow0LightMat * world * p;
	                    //v1PositionFromLight = shadow1LightMat * world * p;
                        
                        // positionCS = gl_Position;

                        //vNormal           = normalMatrix * normal;
                        //vec4 viewPos      = modelViewMatrix * vec4(position, 1.0);
                        //vec4 viewLightPos = viewMatrix * vec4(customPointLightPos, 1.0);
                        //lightVec          = normalize(viewLightPos.xyz - viewPos.xyz);


                        //vec4 pos = world * view * vec4(position, 1.0);
                        // = posModel.xyz;
                        //mat4 x = inverse(transpose(view * world));
                        //fNormal = (x * vec4(normal, 1.0)).xyz;

                        //vec4 viewPos      = modelViewMatrix * vec4(position, 1.0);

                        // REM : need lightPos in view space, else lighting rotates with camera
                        vec4 viewLightPos = view * vec4(lightPos, 1.0);
                        // REM : cant use fPosition.xyz (=posModel) here, wich is position in world * view
                        // because dynamic terrain updates makes it jump slightly
                        // (might be related to interpolation of positions / normals )
                        //lightDir          = normalize(viewLightPos.xyz - fPosition.xyz);
                        lightDir          = vec3(-0.5, 1.0, 0.0);
                        //lightDir          = normalize(lightPos.xyz - fPosition.xyz);
                        //vNormal = normal;

                        // temporary hack until we use some mixmap texture to set climates/biomes
                        isSnow = pos.x < -12.0 && pos.x > -52.0 - (14.0 * clamp((abs(pos.z)-40.0) / 20.0,0.0,1.0)) + (14.0 * (clamp((abs(pos.z)-65.0) / 20.0,0.0,1.0))) && pos.z > 40.0 ? 1.0 : 0.0;
                        
                        //vUV3 = vec2(pos4.x / 2.0,pos4.z);

                        //vUV3 = vec2(0.5 + ((pos.x / 163.0) / 2.0), 0.5 + ((pos.z / 163.0) / 2.0));
                        vUV4 = vec2(pos4.x / 2.0,pos4.z);
                        
                        gl_Position = worldViewProjection * p;

                        //float overDrawOffset = flyCam == 1.0 ? 5.0 : 14.0;
                        float overDrawOffset = flyCam == 1.0 ? 5.0 : 14.0;
                        clipped = (
                            isInMapBounds == 0.0 ||
                            vPosition.y < 0.0 ||
                            fogDensity > 1.5 ||
                            any(lessThan(gl_Position.xyz, -gl_Position.www - overDrawOffset)) ||
                            any(greaterThan(gl_Position.xyz, gl_Position.www + overDrawOffset))
                            ) ? 1.0
                            : 0.0;

                        //if (clipped > 0.0 || fogDensity > 1.2){
                        //    gl_Position = vec4(0.0,0.0,1.0,1.0);
                        //}
                    }