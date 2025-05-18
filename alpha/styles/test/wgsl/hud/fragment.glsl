#version 300 es
precision lowp float;

// Inputs matching vertex outputs
layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 vPosition;
layout(location = 2) in vec2 vUV;
layout(location = 3) in vec3 vNormal;

// Uniforms
uniform vec2 screenSize;
uniform mat4 world;
uniform float energy_value;
uniform float health_value;

// Output
out vec4 fragColor;

            void main(void)
            {
                
                vec4 color4 = vec4(0.0,0.0,0.0,0.0);
                
                
                // HUD test
                
                // vec3 screenPos = vec3(vPosition.xy / vPosition.w,vPosition.y);
                // vec3 screenPos = vPosition;
                
                
                
                vec2 barPos = vec2(-1.0 - (cos(abs(vPosition.z))),0.0);
                vec2 barSize = vec2(0.25 + (0.1 * -(vPosition.z/2.0)), 2.0);
                
                vec2 bar2Pos = vec2(1.0 + (cos(abs(vPosition.z))),0.0);
                vec4 barbgcolor = vec4(0.1,0.1,0.1,0.3);
                //float energy_value = 0.25;
                // float bvalue = -0.05+value * barSize.x;

                    // vec2 pos = ( gl_FragCoord.xy / iResolution.xy ) ;
                    // pos = vTex;
                
                //float angle = atan2(vPosition.x, vPosition.z);
                float gutter = barSize.x / 4.0;
                

                if (vPosition.x >= barPos.x - (barSize.x / 2.0) && vPosition.x <= barPos.x + (barSize.x / 2.0)  &&
                    vPosition.z >= barPos.y - (barSize.y / 2.0) && vPosition.z <= barPos.y + (barSize.y / 2.0))
                    {
                       
                        if (vPosition.z >= barPos.y - (barSize.y / 2.0) + (barSize.y - (energy_value * barSize.y)) && vPosition.x >= barPos.x - (barSize.x / 2.0) + gutter && vPosition.x <= barPos.x + (barSize.x / 2.0) - gutter
                        ){
                            color4 = vec4(1.2 - energy_value, 0.2 + energy_value, 0.0, 0.8) * (0.5 + (0.5 * energy_value)) - (vPosition.z/2.0) + (0.5 * (1.0 -energy_value));
                            //color4 = mix( color4,barbgcolor, ((abs(vPosition.x-(barPos.x)) / 0.15)));
                            //color4 = mix(barbgcolor, color4, 1.0 - ((abs(vPosition.x-(barPos.x))-0.05) / 0.15));
                            
                            color4.w = 0.8;
                            //color4 -= (1.0 - abs(((abs(vPosition.x-(barPos.x))-(barSize.x/4.0)) / (barSize.x/6.0))));
                            color4 = mix(color4, barbgcolor, (1.0 - abs(((abs(vPosition.x-(barPos.x))-(gutter)) / (barSize.x/6.0)))));
                        } else {
                            color4 = vec4(0.1, 0.1, 0.1, 0.3);	
                        }
                        
                    } else if (vPosition.x >= bar2Pos.x - (barSize.x / 2.0) && vPosition.x <= bar2Pos.x + (barSize.x / 2.0) &&
                    vPosition.z >= bar2Pos.y - (barSize.y / 2.0) && vPosition.z <= bar2Pos.y + (barSize.y / 2.0))
                    {
                       
                        if (vPosition.z >= bar2Pos.y - (barSize.y / 2.0) + (barSize.y - (health_value * barSize.y)) && vPosition.x >= bar2Pos.x - (barSize.x / 2.0) + gutter && vPosition.x <= bar2Pos.x + (barSize.x / 2.0) - gutter
                        ){
                            color4 = vec4(1.2 - health_value, 0.2 + health_value, 0.2 + health_value, 0.8) - (vPosition.z/2.0);
                            //color4 = mix(color4,barbgcolor, ((abs(vPosition.x-(bar2Pos.x)) / 0.15)));
                            //color4 = mix(barbgcolor, color4, 1.0 - ((abs(vPosition.x-(bar2Pos.x))-0.05) / 0.15));
                            
                            color4.w = 0.8;
                            //color4 -= 1.0 - abs(((abs(vPosition.x-(bar2Pos.x))-(barSize.x/4.0)) / (barSize.x/6.0)));
                            color4 = mix(color4, barbgcolor, (1.0 - abs(((abs(vPosition.x-(bar2Pos.x))-(gutter)) / (barSize.x/6.0)))));
                        } else {
                            color4 = vec4(0.1 + ((1.0 - health_value)), 0.1, 0.1, 0.3 + (0.3 * (1.0 - health_value)));	
                        }
                        
                    }
                
                
                //vec4 color4 = vec4(0.1,0.0,0.2,0.5);
                fragColor = color4;
            }