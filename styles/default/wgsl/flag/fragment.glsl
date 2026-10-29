precision lowp float;
    
        // Helper Functions
        #include<helperFunctions>
                    
    	// Inputs from vertex shader
        layout(location = 0) in vec2 vUV;
        layout(location = 1) in float zOffset1;
        layout(location = 2) in float zOffset2;
        layout(location = 3) flat in int flagN;
        //varying float flagN;

    	uniform sampler2D textureSampler;

        const vec4 colorBlue = vec4(0.0,0.5,1.0, 1.0);
        const vec4 colorRed = vec4(0.85, 0.1, 0.0, 1.0);

        // Output
        layout(location = 0) out vec4 fragColor;

    	void main(void) {
            vec4 c = vec4(0.0, 1.0, 0.0, 1.0);
    	    vec4 t = texture2D(textureSampler, vUV);
            // seems like babylonjs needs a var called alpha declared in shader when alphablending is set to true
            float alpha = t.a;
            #ifndef ALPHABLEND
                if (t.a < 0.4) discard;
            #endif
            // REM : cant use flat nor pass integer in webgl GL 1
            // so, as we get interpolated values, dont check == 1 or 1.0
            // but add some room so interpolated value matches
            // maybe just try use a bool (?)
            if (flagN == 1) {
                if (t.g > 0.5){
                    c = t;
                } else {
                // t.b = 255.0;
                // t = vec4(mix(vec3(t.r, t.g, t.b), vec3(0.0, 0.0, 255.0), 0.5), t.a);
                    c = vec4(colorBlue.r, colorBlue.g, colorBlue.b, t.a);
                    
                }
                c.rgb += zOffset1 *2.0;
            } else if (flagN == 2) {
                if (t.g > 0.5){
                    c = t;
                } else {
                    //t.r = 255.0;
                    c = vec4(colorRed.r, colorRed.g, colorRed.b, t.a);
                    
                }
                c.rgb += zOffset2 *2.0;
                // t = vec4(mix(vec3(t.r, t.g, t.b), vec3(255.0, 0.0, 0.0), 0.5), t.a);
            } else {
                c = t;
            }
            fragColor = c;
    	}