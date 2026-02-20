#version 300 es
precision highp float;
out vec4 fragColor;

uniform float iTime;
uniform vec2 iResolution;

const int n = 20;
const float a = 3.;
const float pi = 3.141592653589793;
const float lambda = 2.2;
const float nu = 2.;


vec4 quadMix(vec4 colm, vec4 col, float alpha) {
    alpha = smoothstep(0., 1., alpha);
    return mix(vec4(0),
        mix(colm, col, alpha),
        alpha
    );
}

vec4 coloring(float amp) {
    if (amp > .0) {
        return quadMix(vec4(0, 0, 1, 0), vec4(0, 1, 1, 1), amp);
    } else {
        return quadMix(vec4(1, 0, 0, 0), vec4(1.0, .6, 0, 0), -amp);
    }
}

vec2 phys2px(vec2 coord) {
    return lambda * coord + vec2(0, iResolution.y / 2.);
}

vec2 px2phys(vec2 coord) {
    return (coord - vec2(0, iResolution.y / 2.)) / lambda;
}

void main() {
    fragColor = vec4(0);
    
    vec2 E = vec2(0);
    
    for(int i = 0; i < n; ++i) {
        vec2 slitCoord = vec2( 0, a * (float(i) - float(n / 2)) );
        fragColor = mix(fragColor, vec4(0,1,0,0), 
                smoothstep( 10., 5., length(gl_FragCoord.xy - phys2px(slitCoord) ) )
            );
        
        float phase = nu * iTime - length(px2phys(gl_FragCoord.xy) - slitCoord);
        
        E += vec2( cos(phase), sin(phase) );
    }
    
    
    //fragColor = coloring(cos( atan(E.y, E.x) ));
    fragColor = coloring(E.x / float(n));
    //fragColor = coloring(length(E) / float(n));
    
}