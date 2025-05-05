
                    precision lowp float;
                    //precision mediump float;
                    
                    //#extension GL_EXT_shader_texture_lod : enable
                    #extension GL_OES_standard_derivatives : enable
                    
                    //uniform float minusPiToPiTime;
                    //uniform float time;
                    uniform float minusOneToOneTime;
                    uniform float sinTime;
                    //uniform float timeLoopReverse;

                    uniform float firewall_radius;

                    uniform float useDepthRenderer;

                    uniform float flyCam;
                    uniform vec3 cameraPosition;
                    uniform float cameraMinZ;
                    uniform float cameraMaxZ;
                    //uniform float cameraPositionY;
                    uniform float waterDepthMult;
                    uniform float maxZminZDif;

                    //uniform vec4 worldPosition

                    //uniform vec2 screenSize;

                    uniform lowp sampler2D textureSamplerDepth;
                    //uniform sampler2D textureSampler;

                    uniform mat4 world;

                    varying float clipped;

                    varying vec2 vUV;
                    varying vec2 vUV2;
                    //varying vec2 vUV3;
                    varying vec2 vUV4;
                    varying vec4 positionCS;
                    varying vec3 screenPos;
                    varying vec3 vPosition;
                    varying vec3 vNormal;

                    varying vec3 pos;
                    //varying vec4 normalInterp;

                    // varying float displacement;

                    //varying lowp float noise;
                    
                    //varying lowp float isInMapBounds;
                    varying lowp float isInMapBoundsStrict;
                    varying lowp float fogDensity;
                    #ifdef GAMEBTR
                        varying lowp float distFromCenterOfFirewall;
                    #endif

                    //varying float waterDepthMult = cameraMaxZ/30.0;

                    varying vec4 v0PositionFromLight;
	                //varying vec4 v1PositionFromLight;

                    //varying lowp float noise;

                    uniform float makeShadows;
                    uniform float gamma;


                    uniform float shadowUVXoffset;

                    #ifdef SHADOW0
                        uniform sampler2D shadow0Sampler;
                        uniform vec3 shadow0Params;
                        uniform sampler2D shadowSamplerClouds;

                       //uniform float shadowUVXoffset;
                        // uniform sampler2D shadow1Sampler;
                        //uniform vec3 shadow1Params;
                    #endif
                    // uniform sampler2D shadow1Sampler;
                    //uniform vec3 shadow1Params;

                    //${shaders.shadowCalc}

                    // Start shadowCalc
                    #define inline
                    float computeShadow(sampler2D shadowSampler, sampler2D shadowSamplerClouds, vec4 vPositionFromLight, float darkness, float mapSize, float bias, float flyCam)
                    {
                      vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
                      depth = 0.5 * depth + vec3(0.5) - bias;
                      vec2 uv = depth.xy;
                      if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0)
                      {
                        return 0.0;
                      }
                    // Poisson Sampling
                      float visibility = 1.0;
                        /*
                      vec2 poissonDisk[17];
                      poissonDisk[0] = vec2(-0.4603522, 0.05781902);
                      poissonDisk[1] = vec2(0.1833183, 0.4220227);
                      poissonDisk[2] = vec2(-0.2228013, -0.6742273);
                      poissonDisk[3] = vec2(-0.8902604, -0.342863);
                      poissonDisk[4] = vec2(0.1578987, -0.4475621);
                      poissonDisk[5] = vec2(-0.2421872, 0.7753323);
                      poissonDisk[6] = vec2(-0.9265682, 0.1625161);
                      poissonDisk[7] = vec2(-0.6603307, -0.6752099);
                      poissonDisk[8] = vec2(-0.6548247, 0.4931313);
                      poissonDisk[9] = vec2(-0.06184207, 0.09442283);
                      poissonDisk[10] = vec2(0.6546733, 0.2202921);
                      poissonDisk[11] = vec2(0.3896068, 0.9182476);
                      poissonDisk[12] = vec2(0.4748246, -0.1856116);
                      poissonDisk[13] = vec2(0.7957902, 0.5994635);
                      poissonDisk[14] = vec2(0.6307233, -0.6544659);
                      poissonDisk[15] = vec2(0.9017051, -0.1625006);
                      poissonDisk[16] = vec2(0.3083053, -0.919605);
                    // Computation
                        
                      #ifndef SHADOWFULLFLOAT
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[0] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[1] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[2] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[3] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[4] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[5] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[6] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[7] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[8] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[9] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[10] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[11] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[12] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[13] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[14] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[15] * mapSize)) < depth.z) visibility -= 0.0588235;
                          if (unpack(texture2D(shadowSampler, uv + poissonDisk[16] * mapSize)) < depth.z) visibility -= 0.0588235;
                      #else
                      
                          if (texture2D(shadowSampler, uv + poissonDisk[0] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[1] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[2] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[3] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[4] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[5] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[6] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[7] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[8] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[9] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[10] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[11] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[12] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[13] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[14] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[15] * mapSize).x < depth.z) visibility -= 0.0588235;
                          if (texture2D(shadowSampler, uv + poissonDisk[16] * mapSize).x < depth.z) visibility -= 0.0588235;
                      //#endif
                      */
                        float shad = texture2D(shadowSampler, uv).x;
                        // for exponential filtering :
                        /*
                        float s = 0.05;
                        if (depth.z >= shad){
                            s = 0.0;
                        } 
                        */
                        float s = 0.0;
                        //if (depth.z >= shad){
                        //    s = 0.06;
                        //} else {
                        //if (shad > 0.0){

                        
                            // REM : TODO : offset should be inverse proportionnal to xgame.vis
                            float offset = 0.002 - (0.0005 * flyCam);
                            vec2 offset1 = vec2(offset, offset);
                            vec2 offset2 = vec2(-offset, offset);
                            vec2 offset3 = vec2(offset, -offset);
                            vec2 offset4 = vec2(-offset, -offset);
                            
                            vec2 offset5 = vec2(offset, 0.0);
                            vec2 offset6 = vec2(0.000, offset);
                            vec2 offset7 = vec2(-offset, 0.0);
                            vec2 offset8 = vec2(0.0, -offset);
                        
                            float shad1 = texture2D(shadowSampler, uv + offset1).x;
                            float shad2 = texture2D(shadowSampler, uv + offset2).x;
                            float shad3 = texture2D(shadowSampler, uv + offset3).x;
                            float shad4 = texture2D(shadowSampler, uv + offset4).x;
                            float shad5 = texture2D(shadowSampler, uv + offset5).x;
                            float shad6 = texture2D(shadowSampler, uv + offset6).x;
                            float shad7 = texture2D(shadowSampler, uv + offset7).x;
                            float shad8 = texture2D(shadowSampler, uv + offset8).x;
                            
                            if (depth.z >= shad || depth.z >= shad1 || depth.z >= shad2 || depth.z >= shad3 || depth.z >= shad4 || depth.z >= shad5 || depth.z >= shad6 || depth.z >= shad7 || depth.z >= shad8){
                                //s = 0.05;
                                s = 0.1 - (((shad + shad1 + shad2 + shad3 + shad4 + shad5 + shad6 + shad7 + shad8) / 9.0) * 0.1);
                            
                                
                            } 

                            //uv= vec2((vUV3.x) + shadowUVXoffset,(vUV3.y));
                            
                            uv = vec2(0.5 + (vUV4.x / 163.0) + shadowUVXoffset,0.5 + (vUV4.y/163.));
                            float cloudShad = texture2D(shadowSamplerClouds,uv).x;
                            float cloudShad1 = texture2D(shadowSamplerClouds,uv + offset1).x;
                            float cloudShad2 = texture2D(shadowSamplerClouds,uv + offset2).x;
                            float cloudShad3 = texture2D(shadowSamplerClouds,uv + offset3).x;
                            float cloudShad4 = texture2D(shadowSamplerClouds,uv + offset4).x;
                            float cloudShad5 = texture2D(shadowSamplerClouds,uv + offset5).x;
                            float cloudShad6 = texture2D(shadowSamplerClouds,uv + offset6).x;
                            float cloudShad7 = texture2D(shadowSamplerClouds,uv + offset7).x;
                            float cloudShad8 = texture2D(shadowSamplerClouds,uv + offset8).x;

                            if (cloudShad > 0.5 || cloudShad1 > 0.5 || cloudShad2 > 0.5 || cloudShad3 > 0.5 || cloudShad4 > 0.5 || cloudShad5 > 0.5 || cloudShad6 > 0.5 || cloudShad7 > 0.5 || cloudShad8 > 0.5){
                                //s += (cloudShad / 9.0)*.5;
                                //s += clamp((cloudShad - 0.49), 0.0, 0.02);
                                //s += 1.0;
                                s += (((cloudShad + cloudShad1 + cloudShad2 + cloudShad3 + cloudShad4 + cloudShad5 + cloudShad6 + cloudShad7 + cloudShad8) / 9.0) * (0.02 + (0.02 * flyCam)));
                            }
                        //}
                        //}
                        
                        //visibility = 1.0 - (texture2D(shadowSampler, uv).x * 0.05);

                      #ifdef OVERLOADEDSHADOWVALUES
                         // return  mix(1.0, min(1.0, visibility + darkness), vOverloadedShadowIntensity.x);
                      #else
                            // 1 + 0.95
                          //return  min(1.0, visibility + darkness);
                        return s;
                      #endif
                    }

                    // End shadowCalc

                    const float bFlat = 0.0;
                    const vec3 lightPos = vec3(-1000.0,1000.0,-10.0);
                    const vec3 ambientColor = vec3(0.0, 0.0, 0.0);
                    //const vec3 diffuseColor = vec3(0.5, 0.5, 0.4);
                    
                    //uniform vec3 diffuseColor;
                    uniform vec3 diffuseColorClamped;
                    uniform float pseudoBrightness;
                    //const vec3 specColor  = vec3(0.9, 0.4, 0.1);
                    const vec3 specColor = vec3(0.2, 0.7, 0.7);
                    //const vec3 specColor = diffuseColor;

                    const float offset = 1.0;

                    //const vec3 vLightPosition = vec3(-2000.0,1000.0,-4000.0);

                    const float depthMaxDistance = 0.149;

                    const float maxDepth = 1.0;
                    

                    //const vec3 depthGradientShallow = vec3(0.043, 0.45, 0.4);
                    //const vec3 depthGradientShallow = vec3(0.412, 0.722, 0.557);
                    //const vec3 depthGradientShallow = vec3(0.231, 0.729, 0.596) * 2.0;
                    const vec3 depthGradientShallow = vec3(0.462, 1.458, 1.192);
                    //const vec3 depthGradientDeep = vec3(0.043, 0.29, 0.306) / 10.0;
                    const vec3 depthGradientDeep = vec3(0.0, 0.0, 0.0596);

                    const lowp float tile_factor = 5.0;
                    const lowp float aspect_Ratio = 1.0;

                    uniform sampler2D textureSamplerPerlin;
                    const vec2 uv_offset_size = vec2(1.0, 1.0);
                    const vec2 waves_size = vec2(0.05, 0.05);

                    
                    const lowp float time_scale = 0.02;

                    // const float maxMips = 10.0;

                    uniform sampler2D textureSamplerPerlinNorm;

                    uniform vec3 fogColor;
                    uniform vec3 bottomColor;

                    //include<clipPlaneFragmentDeclaration>


                    void main(void) {
                        
                        //define CUSTOM_FRAGMENT_MAIN_BEGIN

                        // Clip plane
                        //include<clipPlaneFragment>
                        //vec4 ppos = positionCS;

                        //if (clipped > 0.0) {
                        //    discard;
                        //}
                        // small waves normal
                        //vec3 nrmmap = texture2DLodEXT(textureSamplerPerlinNorm, (nvUV), maxMips * (fogDensity * 3.0)).rgb;
                        //vec3 nrmmap = texture2D(textureSamplerPerlinNorm, (nvUV)).rgb;
                        vec3 nrmmap = texture2D(textureSamplerPerlinNorm, (vUV)).rgb;
                        // big waves normal
                        //nrmmap = nrmmap * texture2DLodEXT(textureSamplerPerlinNorm, (xxvUV * 0.5), maxMips * (fogDensity * 3.0)).rgb;
                        //nrmmap = nrmmap * texture2D(textureSamplerPerlinNorm, (xxvUV * 0.5)).rgb;
                        nrmmap = nrmmap * texture2D(textureSamplerPerlinNorm, (vUV2)).rgb;
                        //vec4 waterColor10 = vec4(fogColor, 1.0);
                        //vec4 waterColor10 = vec4(0.5,0.5,0.6, 1.0);
                        vec4 waterColor10 = vec4(0.0,0.0,0.0, 1.0);
                        //vec4 waterColor10 = vec4(mix(vec3(1.0,1.0,1.0), vec3(0.0,0.0,0.0), clamp(fogDensity - 1.0 / 1.0,0.0,1.0)),1.0);
                        // if (pos.x < 163.84+0.5 && pos.x > -163.84-0.5 && pos.z < 81.92+0.5 && pos.z > -81.92-0.5){
                        //if (pos.x < 163.84 && pos.x > -163.84 && pos.z < 81.92 && pos.z > -81.92){
                        //if (isInMapBounds > 0.0){    
                        //if (fogDensity <= 1.05){

                        vec3 waterColor9 = vec3(0.048,0.062,0.172);

                        float alpha = 1.0; 
                        
                        lowp float tpn3 = 0.0;
                        
                        //float s = time / 70.0;
                            
                        float s = minusOneToOneTime;
                        //float s = time / 70.0;
                        /*
                        vec3 p1 = pos;
                        vec3 p2 = pos;
                            
                        #ifdef GL_OES_standard_derivatives
                            p1 = dFdx(pos);
                            p2 = dFdy(pos);
                        #endif
                            
                        //vec3 normal = mix(normalize(normalInterp), normalize(cross(p1, p1)), bFlat);
                        */
                        //vec2 xvUV = vUV - s;
                        //vec2 xxvUV = vUV + s;
                            
                        vec2 xvUV = vUV;
                        vec2 xxvUV = vUV;
                        
                        //lowp float tile_factor2 = 1.0;
                        //vec2 adjusted_uv = xvUV * tile_factor2;
                        //vec2 nvUV = adjusted_uv;
                        
                        
                        
                        //normalInterp2 = normalInterp * tpn3;
                        
                        //vec3 normal = mix(normalize(normalInterp), normalize(cross(dFdx(pos), dFdy(pos))), bFlat);
                        
                        //vec3 normal = (vNormal * 0.5) + (normalInterp * 0.5);
                        
                        // vertex normal, already displaced in vertex shader
                        vec3 normal = vNormal;
                        //float xfogDensity = fogDensity > 0.1 ? fogDensity : 0.1 + (0.2 * flyCam);
                        //float xfogDensity = max(0.2, fogDensity) + (0.2 * flyCam); 
                        //float xfogDensity = fogDensity > 0.1 ? fogDensity + (((fogDensity - 0.1) *  5.0) * flyCam) : 0.2 + (0.1 * flyCam);
                        //float xfogDensity = max(0.6 + (0.3 * flyCam),min(1.4, fogDensity + ((fogDensity - 0.05) * 8.0)));
                        float xfogDensity = 0.6;
                        //vec3 new_normal = mat3(world) * normal * (nrmmap*(xfogDensity));
                        vec3 new_normal = vNormal * (nrmmap*(xfogDensity));
                        //vec3 normal = new_normal; 
                        
                        //vec3 vNormal2 = normalize( cross(dFdx(pos), dFdy(pos)) );

                                //vec3 vNormalW = normalize(vec3(world * vec4(vNormal2, 0.0)));
                                //vec3 viewDirectionW = normalize(cameraPosition - vPosition);



                                // Light
                                //vec3 lightVectorW = normalize(vLightPosition - vPosition);
                                // diffuse
                                //float ndl = max(0., dot(vNormalW, lightVectorW));

                                // Specular
                                //vec3 angleW = normalize(viewDirectionW + lightVectorW);
                                //float specComp = max(0., dot(vNormalW, angleW));
                                //specComp = pow(specComp, max(1., 64.)) * 2.;

                                //vec3 newnormal = mat3(world) * normalize(normalInterp) * (tpn3*0.5+0.5);
                        
                                //vec3 normal = mix(normalize(normalInterp), normalize(cross(dFdx(pos), dFdy(pos))), bFlat);
                        
                               // normal = mat3(world) * normal * (tpn3*0.5+0.5);
                        
                                vec3 lightDir = normalize(lightPos - pos);

                                //float lambertian = max(dot(lightDir,vec3(noise,noise,noise)), -1.0);
                            
                                //lowp float lambertian = max(dot(lightDir,new_normal), -0.15);
                                // more cartoonish look
                                //lowp float lambertian = max(dot(lightDir,new_normal), 0.15);
                            
                                lowp float lambertian = max(dot(lightDir,new_normal), 0.15);    
                            
                                float specular = 0.0;
                                //float lambertian2 = 0.0;
                                /*
                                if(lambertian > 0.0) {
                                    vec3 viewDir = normalize(-pos);
                                    vec3 halfDir = normalize(lightDir + viewDir);
                                    float specAngle = max(dot(halfDir, normal), 0.0);
                                    specular = pow(specAngle, 16.0);

                                    lambertian2 = lambertian /2.0;
                                } else {
                                    lambertian2 = 0.0;
                                }
                                */
                                //vec3 viewDir = normalize(-pos);
                                
                                // TODO ? use POI.position.x, lightPosition.y, POI.position.z
                                // instead of cameraPosition
                                // to get a light position that makes more sense (doesnt rotate with arcRotateCamera)
                                vec3 viewDir = normalize(cameraPosition - pos);
                                vec3 halfDir = normalize(lightDir + viewDir);
                                //lowp float specAngle = max(dot(halfDir, new_normal), 0.0);
                                float smoothness = 2.5;
                                //lowp float specAngle = acos(dot(normalize(lightDir - viewDir), new_normal));
                                lowp float specAngle = acos(dot(normalize(lightDir - viewDir), new_normal));
                                float exp = specAngle/smoothness;
                                
                                specular = pow(-exp, 8.0);
                                //specular = (1.0 - pow(-exp,exp)) + 1.5;
                            
    
                        
                        //lambertian2 = lambertian;
                        //Position on the screen
                        //vec2 screenPos = positionCS.xy / positionCS.w;

                        // vec2 offsetedScreenPos = (vec2(screenPos.x + offset, screenPos.y + offset) / 2.0);
                        
                        float existingDepthLinear = 0.54;
                        
                        // float Linear01Depth2 = 0.53;
                        /*
                        if (useDepthRenderer > 0.0){
                            existingDepthLinear = abs(texture2D(depth, offsetedScreenPos).r);
                        } 
                        
                        */
                        //else {
                        //    existingDepthLinear = 0.54;
                            //waterDepthMult = 1.0;
                        //}
                        //float Linear01Depth = 1.0 / ((1.0-far/near) * z + far/near);

                        //float Linear01Depth = 1.0 / ((1.0-cameraMaxZ/cameraMinZ) * existingDepthLinear + (cameraMaxZ/cameraMinZ));



                        //float ld = ((2.0 * 1.0) / (30.0 + 1.0 - existingDepthLinear * (30.0 - 1.0)));

                        // Part 4 : https://www.gamasutra.com/view/feature/1515/messing_with_tangent_space.php?print=1

                        //float existingDepthLinear = texture2D(depth, offsetedScreenPos).r + ( pow(cameraPositionY, 2.0) + pow(vPosition.z,2.0) / (cameraMaxZ-cameraMinZ) );


                        vec3 baseColor = vec3(1.0,1.0,1.0);

                        //float mt = (distc / cameraPositionY);
                        
                        // remap frag screen space coords to ndc (-1 to +1)
                            vec2 ndc = (positionCS.xy / positionCS.w) / 2.0 + 0.5;
                            float linearWaterDepth = 0.5;
                            float wdepth = 0.8;
                            existingDepthLinear = texture2D(textureSamplerDepth, vec2(ndc.x, ndc.y)).r;

                            // REM: webgpu z buffer range from -1 to 1 (≠ webgl 0 to 1)
                            //existingDepthLinear = (existingDepthLinear + 1.0) /2.0)

                            //existingDepthLinear = cameraMinZ * cameraMaxZ / (cameraMaxZ + existingDepthLinear * (cameraMinZ - cameraMaxZ));

                            //existingDepthLinear = existingDepthLinear > 0.0 ? existingDepthLinear : 0.54;
                            
                            if (useDepthRenderer > 0.0) {

                                if (flyCam > 0.0 && isInMapBoundsStrict > 0.0 || flyCam == 0.0){

                                    // grab depth value (0 to 1) at ndc for object behind water
                                    //existingDepthLinear = texture2D(depth, vec2(ndc.x, ndc.y)).r;
                                
                                    // get depth of water plane
                                    linearWaterDepth = (positionCS.z + cameraMinZ) / (cameraMaxZ + cameraMinZ);

                                    //ifdef WEBGPU
                                    //    existingDepthLinear = 0.54;
                                    //    linearWaterDepth = 0.525;
                                    
                                    // calculate water depth scaled to camMaxZ since camMaxZ >> camMinZ
                                    float waterDepth = cameraMaxZ*(existingDepthLinear - linearWaterDepth);
                                    // get water depth as a ratio of maxDepth
                                    //float wdepth = clamp((waterDepth/maxDepth), 0.0, 1.0) * waterDepthMult;

                                    //float wmult = flyCam > 0.0 ? 3.0 : 3.0;
                                    float wmult = 1.0;
                                    wdepth = clamp((waterDepth/maxDepth), 0.0, 1.0) * wmult;

                                } 
                            
                            } else {
                                existingDepthLinear = 0.54;
                                //linearWaterDepth = 0.525;
                                //vec2 tmpUV = vec2(((vUV3.x/163.0)) + 0.5, (vUV3.y/163.0) - 0.5);
                                //wdepth = (1.0 - texture2D(textureSamplerDepth, tmpUV).r * 6.5);
                                //linearWaterDepth = 1.0 - wdepth;

                                //existingDepthLinear=.54;
                                wdepth=1.-texture2D(textureSamplerDepth,vec2(vUV4.x/163.+.5,vUV4.y/163.-.5)).x*6.5;
                                

                                if (isInMapBoundsStrict == 0.0){
                                    
                                    wdepth = 0.5;
                                }

                                linearWaterDepth= 1.-wdepth;
                            }

                            // ifdef WEBGPU
                            //    existingDepthLinear = 0.54;
                            //    linearWaterDepth = 0.525;
                            //    wdepth = 0.78;
                            // endif
                            //float wdepth = clamp((waterDepth/maxDepth), 0.0, 1.0);
                            // mix water colors based on depth
                            baseColor = mix(depthGradientShallow, depthGradientDeep, wdepth);

                            //baseColor = vec3(0.0,1.0,0.0);
                            

                            if (flyCam > 0.0 && isInMapBoundsStrict == 0.0){
                                float mapLimitGlow = 0.0;
                                if (abs(pos.x) > 164.0 && abs(pos.z) > 82.0) {
                                    mapLimitGlow = sqrt(pow(abs(pos.x)-164.0, 2.0) + pow(abs(pos.z)-82.0, 2.0));
                                } else if (abs(pos.x) > 164.0) {
                                    mapLimitGlow=abs(pos.x)-164.0;
                                } else if (abs(pos.z) > 82.0) {
                                    mapLimitGlow=abs(pos.z)-82.0;
                                }



                                baseColor.r += isInMapBoundsStrict > 0.0 ? 0.0 : max(3.0 - min(mapLimitGlow,3.0),0.0);
                                //baseColor.g -= isInMapBoundsStrict > 0.0 ? 0.0 : 1.0 - fogDensity;
                                baseColor.b += isInMapBoundsStrict > 0.0 ? 0.0 :  max(3.0 - min(mapLimitGlow,3.0),0.0);

                                //baseColor = isInMapBoundsStrict > 0.0 ? baseColor : baseColor/10.0;
                            }
                            
                            
                            
                            // existingDepthLinear = depthOfObjectBehindWater;
                        
                        
                        //depthDifference = 10.0;

                        //float depthDifference = (ld - linearizedWatergroundDepth);
                        
                        //vec3 waterColor9 = flyCam > 0.0 ? vec3(1.0,1.0,1.0) : vec3(0.048,0.062,0.172);
                        
                        //vec3 tmpDiffuse = diffuseColor;
                        //float pseudoBrightness = clamp((diffuseColor.r + diffuseColor.g + diffuseColor.b) / 1.0, 0.0, 0.5);
                        // float alpha = 1.0;
                        //if (existingDepthLinear > 1.0) {
                            //discard;
                        //    gl_FragColor = vec4(1.012,0.216,0.251, 1.0);
                        //} else {
                            //vec2 uv = vUV;
                        /*
                        #ifdef GAMEBTR
                            lowp float tpn = 0.0;
                            lowp float tpn2 = 0.0;
                            //lowp float tpn3 = 0.0;

                            // World values
                            //vec3 vPositionW = vec3(world * vec4(vPosition, 1.0));

                                
                            //float dod = waterDepthDifference01 / 2.0;
                            //vec4 waterColor5 = vec4(0.4 - dod, 0.55 - dod, 0.6 - dod,1.0) + waterColor;

                            //waterColor9 = vec3(waterColor5.x,waterColor5.y,waterColor5.z);
                                
                            vec2 offset_texture_uvs = vUV * uv_offset_size;
                            //offset_texture_uvs += time * time_scale;
                            offset_texture_uvs += minusOneToOneTime;
                            //vec2 texture_based_offset = texture2DLodEXT(textureSamplerPerlin, offset_texture_uvs, maxMips * (fogDensity * 3.0)).rg;
                            vec2 texture_based_offset = texture2D(textureSamplerPerlin, offset_texture_uvs).rg;
                            texture_based_offset = texture_based_offset * 2.0 - 1.0;
                                
                            vec2 adjusted_uv = vUV * 0.5;
                            adjusted_uv.y *= aspect_Ratio;
                                
                            vec2 nvUV = adjusted_uv + texture_based_offset * waves_size;
                            //vec2 nvUV2 = vec2(vUV.x + (timeLoopReverse), vUV.y + (timeLoopReverse));
                                
                            //tpn = texture2DLodEXT(textureSamplerPerlin, (nvUV), maxMips * (fogDensity * 3.0)).r;
                            tpn = texture2D(textureSamplerPerlin, (nvUV)).r;
                        #endif
                        */
                        //if (existingDepthLinear < 1.0) {     
                            //vec3 color = vec3(1,1,1);
                            
                            
                           
                           
                           
                            /*
                            if (useDepthRenderer > 0.0){
                                Linear01Depth2 = (positionCS.w-cameraMinZ) / maxZminZDif;
                            }
                            */
                            //existingDepthLinear = Linear01Depth;

                            //float linearizedWatergroundDepth = ( distc  / ((cameraMaxZ-cameraMinZ) + (4.0 + pos.y)));

                            //float linearizedWatergroundDepth = (ppos.z / cameraMaxZ);

                            float depthDifference = existingDepthLinear - linearWaterDepth;

                            
                            //if (depthDifference < 0.0){
                            //    depthDifference = 1.0;
                            //}
                            //vec2 newUV = vUV;


                            //vec4 textCol = texture2D(textureSampler, newUV);

                            
                           float waterDepthDifference01 = clamp((depthDifference / depthMaxDistance) * waterDepthMult, 0.0,1.0) ;



                            //vec3 waterColor = mix(depthGradientShallow, depthGradientDeep, waterDepthDifference01 * 11.0);
                            

                            
                           
                            //float waterDepthDifference01 = 0.5;
                            
                           
                            vec3 waterColor = baseColor;
                            
                            //vec3 waterColor = vec3(waterDepthDifference01, 0.0, 0.0);

                            float shoreStart = 0.0;
                            float shoreEnd = 0.15;
                            

                            bool isShore = waterDepthDifference01 >= shoreStart && waterDepthDifference01 <= shoreEnd;
                            bool isFoam = waterDepthDifference01 <= 0.4 && (waterDepthDifference01 < shoreStart || waterDepthDifference01 > shoreEnd);
                            // Deepest seas
                            bool isElse = waterDepthDifference01 > 0.5;
                            // bool isElse = !isShore && !isFoam;

                            // vec3 waterColor9 = vec3(0.0,0.5-waterDepthDifference01,0.5+waterDepthDifference01);
                           
                           
                            // waterColor9 = vec3(waterColor.x,waterColor.y,waterColor.z);
                            
                            //tmpDiffuse.r = clamp(tmpDiffuse.r, 0.043, 1.0);
                            //tmpDiffuse.g = clamp(tmpDiffuse.g, 0.29, 1.0);
                            //tmpDiffuse.b = clamp(tmpDiffuse.b, 0.306, 1.0);
                           
                            //float pseudoBrightness = (diffuseColor.r + diffuseColor.g + diffuseColor.b) / 1.0;
                            //waterColor9 = vec3(waterColor.x,waterColor.y,waterColor.z) * ((1.0 - (diffuseColor.b/105.0))) * pseudoBrightness;
                            
                            waterColor9 = vec3(waterColor.x,waterColor.y,waterColor.z) * pseudoBrightness;
                            //waterColor9.x = clamp(waterColor9.x, 0.043, 0.231);
                            //waterColor9.y = clamp(waterColor9.y, 0.29, 0.729);
                            //waterColor9.z = clamp(waterColor9.z, 0.306, 0.596);
                            //waterColor9.x = clamp(waterColor9.x, 0.043, 2.0);
                            //waterColor9.y = clamp(waterColor9.y, 0.29, 2.0);
                            //waterColor9.z = clamp(waterColor9.z, 0.306, 2.0);
                           
                            //if (isElse){

                                //waterColor9 = flyCam > 0.0 ? vec3(0.06,0.3,0.32) : waterColor9;
                                //alpha = flyCam > 0.0 ? 0.0 : 1.0;
                            //} else {


                            lowp float tpn = 0.0;
                                    lowp float tpn2 = 0.0;
                                    //lowp float tpn3 = 0.0;

                                    // World values
                                    //vec3 vPositionW = vec3(world * vec4(vPosition, 1.0));

                                    
                                    //float dod = waterDepthDifference01 / 2.0;
                                    //vec4 waterColor5 = vec4(0.4 - dod, 0.55 - dod, 0.6 - dod,1.0) + waterColor;

                                    //waterColor9 = vec3(waterColor5.x,waterColor5.y,waterColor5.z);
                                    
                                    vec2 offset_texture_uvs = vUV * uv_offset_size;
                                    //offset_texture_uvs += time * time_scale;
                                    offset_texture_uvs += minusOneToOneTime;
                                    //vec2 texture_based_offset = texture2DLodEXT(textureSamplerPerlin, offset_texture_uvs, maxMips * (fogDensity * 3.0)).rg;
                                    vec2 texture_based_offset = texture2D(textureSamplerPerlin, offset_texture_uvs).rg;
                                    texture_based_offset = texture_based_offset * 2.0 - 1.0;
                                    
                                    vec2 adjusted_uv = vUV * 0.5;
                                    adjusted_uv.y *= aspect_Ratio;
                                    
                                    vec2 nvUV = adjusted_uv + texture_based_offset * waves_size;
                                    //vec2 nvUV2 = vec2(vUV.x + (timeLoopReverse), vUV.y + (timeLoopReverse));
                                    
                                    //tpn = texture2DLodEXT(textureSamplerPerlin, (nvUV), maxMips * (fogDensity * 3.0)).r;
                                    tpn = texture2D(textureSamplerPerlin, (nvUV)).r;



                            if (!isElse){
                                //ifndef GAMEBTR
                               
                                    
                                //endif
                                

                                if (isShore){
                                    
                                    //tpn = texture2D(textureSamplerPerlin, (nvUV * 20.0) ).r;
                                    
                                    //tpn = pnoise( 75.0 * pos / 5.0 + vec3( 2.0 * (time/10.0)), vec3( 100.0) );
                                    
                                    
                                    //tpn = texture2D(textureSamplerPerlin, (nvUV * 20.0) ).r;
                                    float addF = -(1.0 - clamp((1.0 * (shoreEnd / (shoreEnd - waterDepthDifference01))),0.0,1.0));
                                    addF = 0.0;
                                    waterColor9 = vec3(waterColor9.x + addF,waterColor9.y + addF,waterColor9.z + addF);
                                    
                                    if (tpn > 0.5){
                                        
                                        addF = (1.0 - clamp((waterDepthDifference01/(shoreEnd / 2.0)),0.0,1.0)) * 0.2;
                                        //addF = addF /3.0;
                                        waterColor9 = vec3(waterColor9.x + addF,waterColor9.y + addF,waterColor9.z + addF);
                                    } // else {
                                        //addF = 1.0 - clamp((1.0 * (0.0125 / (0.05 - waterDepthDifference01))),0.0,1.0);
                                        //addF = addF/2.0;
                                        //waterColor9 = vec3(waterColor9.x + addF,waterColor9.y + addF,waterColor9.z + addF);
                                    // }
                                    /*
                                    if (waterDepthDifference01 < 0.025 ){
                                        waterColor9 -= 0.2;
                                    }
                                    */
                                    //waterColor9 = mix(vec3(0.5,0.44,0.19) - lambertian * tmpDiffuse, waterColor9, clamp(waterDepthDifference01 / 0.0175,0.0,1.0));
                                    // vec3(0.18,0.165,0.06 vec3(0.25,0.22,0.08) vec3(0.375,0.33,0.12)
                                    
                                    // fake transparency from dark brown to water color
                                    //waterColor9 = mix(vec3(0.25,0.22,0.08), waterColor9, clamp(waterDepthDifference01 / 0.0175,0.0,1.0));
                                    
                                    // interesting red outline
                                    //waterColor9 = mix(vec3(1.5,0.44,0.58), waterColor9, clamp(waterDepthDifference01 / 0.0175,0.0,0.75));
                                    //waterColor9 = mix(vec3(0.7,1.44,0.58), waterColor9, clamp(waterDepthDifference01 / 0.0175,0.0,1.0));
                                    //ifdef ALPHATEST
                                    //ifndef ALPHABLEND
                                    #ifdef ALPHABLEND
                                        alpha = clamp(waterDepthDifference01 / 0.0175,0.0,1.0);
                                        waterColor9 = mix(vec3(0.9,1.0,1.0) * pseudoBrightness, waterColor9, alpha);
                                        //if (waterDepthDifference01 > 0.01){
                                            //alpha = clamp(waterDepthDifference01 / 0.0175,0.0,1.0);
                                        //} 
                                        
                                    #endif
                                    
                                    /*ifndef ALPHABLEND
                                        waterColor9 = waterColor9/2.0;
                                    endif*/
                                    

                                } /* else if (isFoam){
                                    //tpn = texture2D(textureSamplerPerlin, (nvUV * 20.0) ).r;
                                    //tpn = pnoise( 100.915 * pos/10.0 + vec3( 2.0 * (time/10.0)), vec3( 100.0) );
                                    
                                    //if (tpn > 0.65){
                                    //    float addF = (tpn/2.0) * (1.0 / (0.3 / (0.075 - waterDepthDifference01)));
                                        //waterColor9 = (waterColor9 + ((addF))) + lambertian2 * diffuseColor + specular * specColor;
                                    //}

                                }
                                else {
                                    
                                    //lowp float tile_factor2 = 3.0;
                                    //adjusted_uv = vUV * tile_factor2;
                                    //nvUV = adjusted_uv + texture_based_offset * waves_size;
                                    //tpn = texture2D(textureSamplerPerlin, (nvUV * 20.0) ).r;
                                    //tpn2 = texture2D(textureSamplerPerlin, nvUV).r;
                                    //tpn = pnoise( 75.0 * pos / 15.0 + vec3( -2.0 * (time/10.0)), vec3( 100.0) );
                                    //tpn2 = pnoise( 750.0 * (pos) / 15.0 + vec3( -2.0 * (time/15.0)), vec3( 50.0) );

                                    //if (tpn > 0.7 || tpn2 > 0.725){

                                    //    waterColor9 = (waterColor9) + lambertian2 * diffuseColor + specular * specColor;    
                                    //}
                                    
                                    

                                }
                                */


                                //waterColor9 = vec3(waterColor9.x,waterColor9.y + (clamp(tpn/(20.0),-0.0,0.02)* (0.05-waterDepthDifference01)) + (clamp(tpn2/20.0,-0.05,0.02)* (0.05-waterDepthDifference01)),waterColor9.z + (clamp(tpn/20.0,-0.05,0.02)* (0.05-waterDepthDifference01)) + (clamp(tpn2/20.0,-0.05,0.02)* (0.05-waterDepthDifference01)));
                                //float tpn3 = pnoise( 1500.0 * (pos) /700.0 + vec3( -1.15 * (time/4.0)), vec3( 50.0) );
                                
                                
                                //waterColor9 += (tpn3/20.0) - (0.2 * (abs(pos.z) / 163.0));
                                
                                //waterColor9 += lambertian2/8.0 * diffuseColor + specular * specColor;
                                
                                //waterColor9 += lambertian * diffuseColor + specular * specColor;

                            }
                            //else {
                            //    alpha = 1.0;
                            //}
                            

                            //waterColor9 = vec3(vPosition.y,vPosition.y,vPosition.y);

                            //waterColor9 = waterColor9 + (tpn3/70.0) + ((lambertian * 0.1) * diffuseColor + specular * specColor);



                            //waterDepthDifference01 *= cameraMaxZ/30.0;
                            //waterColor9 = vec3(0.0,0.5-waterDepthDifference01,0.5+waterDepthDifference01);

                            //gl_FragColor = vec4(waterColor9,depthDifference*1000.0);
                            

                            //gl_FragColor = vec4(waterColor9 + ((lambertian * 0.1) * diffuseColor + specular * specColor), alpha);
                        //}
                        
                        float s1 = 0.0;
                        #ifdef SHADOW0
                        if (makeShadows > 0.0){
                            // Shadow Calculation
                            s1 = computeShadow(shadow0Sampler, shadowSamplerClouds, v0PositionFromLight, shadow0Params.x, shadow0Params.y, shadow0Params.z, flyCam);
                                
                            //waterColor9 -= s1;
                        }
                        #endif    
                            
                            
                            
                            
                            
                            
                            //waterColor9 = mix(((waterColor9 + lambertian * tmpDiffuse + specular * specColor) / 2.0) -s1, (fogColor + tmpDiffuse)/2.0, clamp(fogDensity * 1.25, 0.0,1.0));
                            //waterColor9 = mix(((waterColor9 + lambertian * tmpDiffuse + specular * specColor) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0));
                            
                            
                            
                            //alpha = clamp((fogDensity - 0.7)/0.3,0.0,1.0);
                            //finalColor = vec4(mix(fogColor*5.0,fogColor*5.0, clamp((fogDensity - 1.0) / 0.5,0.0,1.0)),alpha);
                            /*if (fogDensity > 0.9){
                                // waterColor9 = mix(vec3(mix(fogColor * 2.0 + (0.5 * pseudoBrightness), fogColor,1.0 - ((fogDensity - 0.9) / 0.1))),mix(((waterColor9 + lambertian * tmpDiffuse + specular * specColor) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0)), 1.0 - ((fogDensity - 0.7) / 0.3));
                                waterColor9 = mix(vec3(mix(fogColor * 2.0, fogColor,1.0 - ((fogDensity - 0.7) / 0.3))),mix(((waterColor9 + lambertian * tmpDiffuse + specular * specColor) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0)), 1.0 - ((fogDensity - 0.7) / 0.3));
                                waterColor9 += ((fogDensity - 0.9) / 0.1) * pseudoBrightness * 0.25;
                                //waterColor9 = mix(fogColor * 2.0 + (0.5 * pseudoBrightness), waterColor9, 1.0 - ((fogDensity - 0.9) / 0.2));
                            } else 
                            
                            */
                            //if (flyCam  > 0.0){

                            // PROBLEM HERE WITH WEBGPU (?)
                            #ifndef WEBGPU
                                if (flyCam > 0.0 && fogDensity > 0.7){
                                    waterColor9 = mix(vec3(mix(fogColor * (pseudoBrightness * (5.0 - ((pseudoBrightness - 0.5)/0.5))), fogColor,1.0 - ((fogDensity - 0.7) / 0.3))),mix(((waterColor9 + lambertian * diffuseColorClamped + specular * specColor) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0)), 1.0 - ((fogDensity - 0.7) / 0.3));
                                    waterColor9 += clamp(((fogDensity - 0.98) / 0.1) * (pseudoBrightness * (1.5 - ((pseudoBrightness - 0.4)/0.5) )),0.0,1.0) / 2.0;
                                    //waterColor9 += pow(pseudoBrightness,4.0 + (4.0 * (1.0 - (fogDensity - 0.7) / 0.3)));
                                    
                                } else {
                                     waterColor9 = mix(((waterColor9 + lambertian * diffuseColorClamped + specular * specColor) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0));
                                     
                                }
                            #endif
                            //}
                            
                            #ifdef WEBGPU
                                if (flyCam > 0.0 && fogDensity > 0.7){
                                    waterColor9 = mix(vec3(mix(fogColor * (pseudoBrightness * (5.0 - ((pseudoBrightness - 0.5)/0.5))), fogColor,1.0 - ((fogDensity - 0.7) / 0.3))),mix(((waterColor9 + lambertian * diffuseColorClamped) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0)), 1.0 - ((fogDensity - 0.7) / 0.3));
                                    waterColor9 += clamp(((fogDensity - 0.98) / 0.1) * (pseudoBrightness * (1.5 - ((pseudoBrightness - 0.4)/0.5) )),0.0,1.0) / 2.0;
                                    //waterColor9 += pow(pseudoBrightness,4.0 + (4.0 * (1.0 - (fogDensity - 0.7) / 0.3)));
                                    
                                } else {
                                     waterColor9 = mix(((waterColor9 + lambertian * diffuseColorClamped) / 2.0) -s1, fogColor, clamp(fogDensity * 1.25, 0.0,1.0));
                                     
                                }
                            #endif
                            
                            //waterColor9.x = clamp(waterColor9.x, 0.1, 1.0);
                            //waterColor9.y = clamp(waterColor9.y, 0.1, 1.0);
                            //waterColor9.z = clamp(waterColor9.z, 0.15, 1.0);
                            // REM : VISUAL HIERARCHY
                            //waterColor9 = waterColor9 / 2.0;
                            
                            //waterColor9 = mix(waterColor9, fogColor, fogDensity * 2.0);
                            // apply gamma correction
                            // float gamma = 0.8;
                            //waterColor9.x -= 0.05;
                            //waterColor9.y -= 0.05;
                            //waterColor9.z -= 0.05;

                            waterColor9 = pow(waterColor9, vec3(1.0/gamma));

                            #ifdef GAMEBTR
                                if (distFromCenterOfFirewall > firewall_radius){
                                    waterColor9.r += clamp(((distFromCenterOfFirewall - firewall_radius) / 10.0) * 10.0, 0.0, 10.0);
                                    waterColor9.g += tpn * clamp(((distFromCenterOfFirewall - firewall_radius) / 10.0), 0.0, 1.0);
                                }
                            #endif
                            
                            /*
                            if (fogDensity > 0.9){
                                waterColor9 = mix(vec3(1.0,1.0,1.0), vec3(0.98,0.89,1.0), clamp((fogDensity - 0.9) / 0.1,0.0,1.0));
                            }
                            */
                            
                            /*
                            if (fogDensity <= 1.0){ 
                                waterColor10 = vec4(waterColor9,1.0);
                            } else if (fogDensity > 1.0 && fogDensity < 1.2){
                                vec3 mixColor = mix(fogColor, vec3(1.0,1.0,1.0), (fogDensity - 1.0) / 0.1);
                                waterColor10 = vec4(mix(mixColor, bottomColor,(fogDensity - 1.0) / 0.1), 1.0);
                            } else if  (fogDensity >= 1.2){
                                discard;
                            }*/
                            
                            waterColor10 = vec4(waterColor9,alpha);
                            
                            if (nrmmap.g > 0.6 + (0.2 * (1.0 - fogDensity))){
                                waterColor10 = vec4(waterColor9.x * (1.0 + ((nrmmap.g/4.0) * pseudoBrightness) * flyCam),waterColor9.y * (1.0 + ((nrmmap.g/4.0) * pseudoBrightness) * flyCam),waterColor9.z * (1.0 + ((nrmmap.g/4.0) * pseudoBrightness) * flyCam),alpha);

                            } else if (nrmmap.g < 0.3){
                                waterColor10 = vec4(waterColor9.x - (((nrmmap.g /20.0) * fogDensity) * flyCam),waterColor9.y - (((nrmmap.g /20.0) * fogDensity) * flyCam),waterColor9.z - (((nrmmap.g /20.0) * fogDensity) * flyCam),alpha);
                            }
                            
                            // ifdef WEBGPU
                                //waterColor10 = vec4(waterColor10.x -s1, waterColor10.y -s1, waterColor10.z -s1, alpha); 
                            // endif
                            // cheap fog
                            /*
                            if (flyCam == 1.0){


                                //float distb = sqrt(abs(pos.x)*abs(cameraPosition.x) + abs(pos.z)*abs(cameraPosition.z));
                                //float distc = sqrt((pow(cameraPositionY,2.0) + pow(distb,2.0)));

                                //float distd = sqrt(pow(pos.x-cameraPosition.x, 2.0) + pow(pos.z-cameraPosition.z, 2.0));




                                //float fogDensity = abs(distd) / maxdist;



                                //vec3 fogColor = vec3(0.0,0.99,0.99);

                                //waterColor9 += vec3(0.0,fogDensity,fogDensity);

                                //vec4 waterColor10 = mix(vec4(waterColor9,1.0),vec4(fogColor,1.0),fogDensity);

                                //waterColor9 += vec3(fogDensity*fogColor.x, fogDensity*fogColor.y, fogDensity*fogColor.z);
                                
                                // waterColor10 = vec4(waterColor9.x,waterColor9.y+fogDensity,waterColor9.z+fogDensity,1.0-fogDensity);
                                
                                //waterColor10 = vec4(waterColor9.x,waterColor9.y+fogDensity,waterColor9.z+fogDensity,alpha);
                                waterColor10 = vec4(waterColor9.x,waterColor9.y,waterColor9.z,alpha);

                                
                                
                                //waterColor10 = vec4(texture2DLodEXT(textureSamplerPerlin, (nvUV), maxMips * (fogDensity * 3.0)).rgb, alpha);
                                
                                //waterColor10 = vec4(fogDensity * 3.0,fogDensity * 3.0,fogDensity * 3.0,alpha);

                            }
                            */
                            
                            /*} else { // endif fogDensity <= 1.05
                                // from skybottom (skyboxcolors array 0.98,0.89,1.0) to skytop (lightcolors array 0.49, 0.44, 0.41)
                                //vec3(0.49, 0.44, 0.41) +  vec3(0.98,0.89,1.0) 
                                //waterColor10 = vec4(mix(vec3(0.98,0.89,1.0), vec3(0.148, 0.44, 1.41), clamp((fogDensity - 1.0) / 0.5,0.0,1.0)),1.0);
                                //waterColor10 = vec4(mix(vec3(0.98,0.89,1.0), vec3(0.148, 0.44, 1.41), clamp((fogDensity - 1.0) / 0.5,0.0,1.0)),clamp(1.0-(fogDensity - 1.0) / 0.5,0.0,1.0));
                                
                                //waterColor10 = vec4(0.0,0.0,0.0,0.0);
                                discard;
                                
                            }*/
                            
                        //    } else {
                        //         waterColor10 = vec4(1.0,0.0,0.0,1.0);
                        //    }

                            

                            gl_FragColor = waterColor10;

                            #include<imageProcessingCompatibility>
                            
                            //define CUSTOM_FRAGMENT_MAIN_END
                    }