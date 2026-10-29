precision lowp float;
            uniform mat4 worldView;
            uniform mat4 world;
            uniform float flyCam;
            uniform vec3 sunPos;
            uniform float offset;
            uniform vec3 topColor;
            uniform vec3 bottomColor;
            uniform vec3 fogColor;
            uniform float pseudoBrightness;

            varying float clipped;
            //varying float isInMapBounds;
            varying vec4 vPosition;
            varying vec3 vNormal; 
            varying vec3 pos;
            varying lowp float fogDensity;

            void main(void){
                float alpha = 0.0; 
                float h = 0.0; 
                /*
                if (clipped > 0.0) {
                    discard;
                }
                */
                //vec4 pos4 = world * vec4(vPosition);
                //vec3 pos = vec3(pos4) / pos4.w;
                
                //lowp float isInMapBounds = pos.x < 164.0 && pos.x > -164.0 && pos.z < 82.0 && pos.z > -82.0 ? 1.0 : 0.0;

                vec3 bottomColorRef = bottomColor;
                vec3 topColorRef = topColor;
                
                vec4 finalColor = vec4(1.0,0.0,0.0,1.0);
                //bool flatMode = flyCam  > 0.0;
                if (flyCam  > 0.0){
                    //float pseudoBrightness = clamp((bottomColorRef.r + bottomColorRef.g + bottomColorRef.b) / 1.0, 0.0, 2.0);
                    //float pseudoBrightness = clamp((diffuseColor.r + diffuseColor.g + diffuseColor.b), 0.0, 2.0);
                        //bottomColorRef = bottomColorRef * (2.0 - pseudoBrightness);
                    bottomColorRef = bottomColorRef * (1.0 + (0.5 * clamp((1.0 - pseudoBrightness),0.0,1.0)));
                    //if (isInMapBounds > 0.0){

                    
                        if (fogDensity > 1.015){ 
                            //alpha = clamp(1.0 - (fogDensity - 1.0),0.0,1.0);
                            alpha = 1.0;


                            /*
                            if (fogDensity > 1.5){
                                bottomColorRef = topColorRef;
                                topColorRef = vec3(0.0,0.0,0.0);

                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.5) * 2.0,0.0,1.0)),alpha);
                            } else if (fogDensity > 1.25){

                                //bottomColorRef = vec3(1.0,0.0,0.0);
                                //topColorRef = vec3(0.0,1.0,0.0);
                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.25) * 4.0,0.0,1.0)),alpha);

                            } else if (fogDensity < 1.25){ 

                                //float pseudoBrightness = clamp((diffuseColor.r + diffuseColor.g + diffuseColor.b) / 1.0, 0.0, 2.0);

                                topColorRef = bottomColorRef;
                                // 0.3,0.5,0.6
                                bottomColorRef = fogColor * pseudoBrightness * 2.0;

                                //finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.0)/0.25,0.0,1.0)),alpha);
                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.0)/0.25,0.0,1.0)),alpha);
                                //finalColor = vec4(1.0,0.0,0.0,alpha);
                            } 
                            */

                            if (fogDensity > 1.5){
                                bottomColorRef = topColorRef;
                                topColorRef = vec3(0.0,0.0,0.0);

                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.5),0.0,1.0)),alpha);
                            } else if (fogDensity > 1.1){

                                //bottomColorRef = vec3(1.0,0.0,0.0);
                                //topColorRef = vec3(0.0,1.0,0.0);
                                //bottomColorRef = bottomColorRef * fogColor * (2.0 + pseudoBrightness);
                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.1) / 0.4,0.0,1.0)),alpha);

                            } else {
                                topColorRef = bottomColorRef;
                                bottomColorRef = bottomColorRef + (fogColor * pseudoBrightness);
                                finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.0) / 0.1,0.0,1.0)),alpha);
                            }

                        } else {
                            /*
                            alpha = clamp((fogDensity - 0.7)/0.3,0.0,1.0);
                            //finalColor = vec4(mix(fogColor*5.0,fogColor*5.0, clamp((fogDensity - 1.0) / 0.5,0.0,1.0)),alpha);
                            if (fogDensity > 0.7){
                                finalColor = vec4(mix(fogColor * 2.0, fogColor,1.0 - ((fogDensity - 0.7) / 0.3)), alpha);
                            } else {
                                #ifndef ALPHABLEND
                                    if (alpha > 0.4){
                                        finalColor = vec4((fogColor),alpha);
                                    } else {
                                        discard;
                                    }
                                #endif 
                                
                                #ifdef ALPHABLEND
                                    finalColor = vec4((fogColor),alpha);
                                #endif
                            }
                            */
                            discard;
                        }
                    
                    //}  else {
                        /*
                        if (abs(pos.x) > 164.0 && abs(pos.z) > 82.0) {
                            alpha = sqrt(pow(abs(pos.x)-164.0, 2.0) + pow(abs(pos.z)-82.0, 2.0));
                        } else if (abs(pos.x) > 164.0) {
                            alpha=abs(pos.x)-164.0;
                        } else if (abs(pos.z) > 82.0) {
                            alpha=abs(pos.z)-82.0;
                        }
                        
                        h= alpha/10.0; 
                    
                        finalColor = vec4(mix(bottomColor,topColor,max(pow(max(h,0.0),0.5),0.0)),alpha);
                        */
                    //}
                    
                    
                    //finalColor = vec4(mix(bottomColorRef,topColorRef, clamp((fogDensity - 1.0) / 0.5,0.0,1.0)),alpha);
                    //finalColor = vec4(fogDensity,0.0,0.0,1.0);
                } else {
                    /*
                    if (isInMapBounds > 0.0){ 
                        discard; 
                    } else { 
                        */
                        if (abs(pos.x) > 164.0 && abs(pos.z) > 82.0) {
                            alpha = sqrt(pow(abs(pos.x)-164.0, 2.0) + pow(abs(pos.z)-82.0, 2.0));
                        } else if (abs(pos.x) > 164.0) {
                            alpha=abs(pos.x)-164.0;
                        } else if (abs(pos.z) > 82.0) {
                            alpha=abs(pos.z)-82.0;
                        }
                   // }
                    
                    h = alpha * 0.1; 
                    
                    finalColor = vec4(mix(bottomColor,topColor,max(pow(max(h,0.0),0.5),0.0)),alpha);
                }
                
                //vec3 lightPos = vec3(pos.x,pos.y,pos.z+30.0);
                vec3 lightPos = sunPos;
                vec3 lightDir = normalize(lightPos - pos);
                vec3 viewDir = normalize(-pos);
                //vec3 sunColor = vec3(0.94, 0.6, 0.2);

                vec3 sunColor = vec3(0.5 + (0.3 * pseudoBrightness), fogDensity * pseudoBrightness, fogDensity * pseudoBrightness)/4.0;
                //float sunD = dot(lightDir,viewDir);

                float distSun = sqrt(pow(pos.x-lightPos.x, 2.0) + pow(pos.z-lightPos.z, 2.0));

                /*
                if (sunD > 0.0){
                    //sunColor = pow(sunD,4.0) * (sunColor/4.0);
                    sunColor = pow(sunD,4.0) * sunColor;
                } else {
                    sunColor = vec3(0.0,0.0,0.0);
                }
                */
                //float m = clamp(1.0-((distSun-30.0)/100.0),0.0,1.0) * (pseudoBrightness/2.0);
                //float m = clamp(1.0-(distSun/100.0),0.0,1.0) * (pseudoBrightness/2.0);
                // the farther the sun, the bigger value
                float m = clamp(1.0-(distSun/(200.0)),0.0,1.0);
                float mm = clamp(1.0-(distSun/(4.0)),0.0,1.0);
                float mmm = clamp(1.0-(distSun/(15.0)),0.0,1.0);
                if (distSun < 3.0 - fogDensity){
                    //m = 5.0 + (10.0 * pseudoBrightness);
                    //sunColor = vec3(3.8 - fogDensity, 0.8 * fogDensity , 0.4 * (fogDensity * pseudoBrightness));

                    //sunColor = vec3(1.25 + (0.5 * fogDensity), 0.4 + (0.3 * fogDensity * pseudoBrightness), 0.2 + (1.5 - (fogDensity)) + (0.2 * fogDensity));
                    sunColor = vec3(1.0,1.0,1.0);
                    finalColor = vec4(sunColor.r,sunColor.g,sunColor.b,1.0);

                    //sunColor = ((0.5* pseudoBrightness) + pow(m,100.0)) * sunColor;
                    //finalColor = finalColor + vec4(sunColor.r,sunColor.g,sunColor.b,0.0);
                } else {
                    sunColor = ((0.5* pseudoBrightness)) * sunColor + (vec3(0.6,0.6,0.0) * mm) + (vec3(0.2,0.2,0.0) * mmm);

                    //const float h = 0.1;
                    //sunColor = sunColor * (h*exp(1.0-m));

                    finalColor = finalColor + vec4(sunColor.r,sunColor.g,sunColor.b,0.0);
                }
                
                
                gl_FragColor = finalColor;
                #include<imageProcessingCompatibility>
            }