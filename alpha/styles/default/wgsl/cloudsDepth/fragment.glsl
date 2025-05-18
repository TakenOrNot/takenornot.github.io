precision lowp float;
                    //precision mediump float;

                    //#extension GL_EXT_shader_texture_lod : enable
                    #extension GL_OES_standard_derivatives : enable
                    
                    // Helper Functions
                    // include<helperFunctions>

                    uniform float minusOneToOneTime;

                    varying float clipped;

                    varying vec3 vNormal;
                    varying vec3 fPosition;

                    #ifdef VERTEXCOLOR
                    varying vec4 vColor;
                    #endif

                    uniform vec3 lightPos;
                    varying vec3 lightDir;
                    
                    varying vec3 pos;
                    varying vec3 vPosition;
                    varying vec2 vUV;
                    varying vec2 vUV2;

                    varying vec3 vNormalW;
                    varying vec3 normalInterp;

                    
                    varying vec4 v0PositionFromLight;

                    varying float fogDensity;

                    #ifdef GAMEBTR
                        varying lowp float distFromCenterOfFirewall;
                        uniform float firewall_radius;
                    #endif

                    varying vec4 posModel;

                    varying float isSnow;
                    
                    uniform float flyCam;
                    uniform float makeShadows;
                    uniform float gamma;
                    
                    uniform vec3 cameraPosition;
                    uniform vec2 screenSize;
                    uniform mat4 world;

                    uniform mat4 view;

                   uniform sampler2D textureSamplerSmoke;

                    // End shadowCalc
                    
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

                        /*
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

                        vec4 t = texture2D(textureSamplerSmoke, vUV);
                        // seems like babylonjs needs a var called alpha declared in shader when alphablending is set to true
                        float alpha = t.a;
                        #ifndef ALPHABLEND
                            if (alpha < 0.2) discard;
                        #endif
                        #ifdef VERTEXALPHA
                            //alpha *= vColor.a;
                            alpha *= vColor.a;
                            if (vColor.a < 0.4) discard;
                        #endif
                        //color4 = t;
                        //color4 = t * vColor.a / 2.0;
                        //color4 *= alpha;
                        gl_FragColor = color4 * alpha;

                        #include<imageProcessingCompatibility>
                        
                        //define CUSTOM_FRAGMENT_MAIN_END
                    }