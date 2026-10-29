precision lowp float;
                    //precision mediump float;

                    //#extension GL_EXT_shader_texture_lod : enable
                    #extension GL_OES_standard_derivatives : enable
                    
                    // Helper Functions
                    // include<helperFunctions>
// === Inputs from Vertex Shader ===
layout(location = 0) in float vDepthMetric;
layout(location = 1) in float clipped;
layout(location = 2) in vec4 v0PositionFromLight;
layout(location = 3) in vec3 vNormal;
layout(location = 4) in vec3 fPosition;
layout(location = 5) in float isSnow;
layout(location = 6) in vec3 pos;
layout(location = 7) in vec4 posModel;
layout(location = 8) in vec3 vPosition;
layout(location = 9) in vec3 vNormalW;
layout(location = 10) in vec2 vUV;
layout(location = 11) in vec2 vUV2;
layout(location = 12) in vec3 normalInterp;
layout(location = 13) in float isInMapBounds;
layout(location = 14) in float distd;
layout(location = 15) in float fogDensity;


                    #ifdef GAMEBTR
                        layout(location = 16) in float distFromCenterOfFirewall;
                        uniform float firewall_radius;
                    #endif

// === Uniforms ===
uniform float minusOneToOneTime;
uniform float flyCam;
uniform float makeShadows;
uniform float gamma;
uniform float firewall_radius;
uniform vec3 cameraPosition;
uniform vec3 lightPos;
uniform vec2 screenSize;
uniform mat4 world;
uniform mat4 view;



                    

                   

                    // End shadowCalc
// Output
layout(location = 0) out vec4 fragColor;
                    
                    // const float maxMips = 10.0;

                    void main(void) {
                        //define CUSTOM_FRAGMENT_MAIN_BEGIN

                        // Clip plane
                        //include<clipPlaneFragment>


                        //gl_FragDepth = gl_FragCoord.z;


                        //float snowDivider = pos.z + (sin(pos.x) - sin(pos.z / 100.0) + sin(pos.x * 10.0)) < -40.0 ? 1000.0 : 0.0;
                        //bool snowDivider = pos.x > 12.0 && pos.x < 52.0 + (14.0 * clamp((abs(pos.z)-40.0) / 20.0,0.0,1.0)) - (14.0 * (clamp((abs(pos.z)-65.0) / 20.0,0.0,1.0))) && pos.z < -40.0 ? true : false;
                        // vec4 color = vec4(1.0,1.0,1.0,1.0); 
                        //vec3(0.1,0.2,0.4)
                        //vec3 color3 = mix(vec3(0.1,0.2,0.4), vec3(0.5,0.5,0.5), fogDensity);
                        //vec4 color4 = vec4(0.048,0.062,0.172, 1.0); 
                        //vec4 color4 = vec4(fogColor,1.0); 
                        //vec4 color4 = vec4(1.0,1.0,1.0,1.0); 
                        //vec4 color4 = vec4(0.13,0.28,0.38,1.0) * fogDensity; 
                        //vec4 color4 = vec4(0.13,0.28,0.38,1.0);
                        
                        // ultimate fallback color 
                        //vec4 color4 = vec4(gl_FragCoord.z,0.0,0.0,1.0);
                        //vec4 color4 = vec4(vDepthMetric,vDepthMetric,vDepthMetric,1.0);
                        vec4 color4 = vec4(0.0,0.0,0.0,1.0);

                        if (clipped > 0.0 || fogDensity >= 1.22) {
                            //gl_FragDepth = 1.0;
                            

                            //color4 = vec4(1.0,0.0,0.0, 0.0);
                            
                            discard;
                        }

                        
                        
                        
                        /*
                        ifdef ALPHATEST
                            if (color4.a < 0.4){
                                discard;
                            }
                        endif
                        */

                        fragColor = color4;

                        #include<imageProcessingCompatibility>
                        
                        //define CUSTOM_FRAGMENT_MAIN_END
                    }