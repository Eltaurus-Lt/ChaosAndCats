const int n = 12;
const float a = 3.;
const float pi = 3.141592653589793;
const float lambda = 2.5;
const float nu = .1;


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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    fragColor = vec4(0);
    
    vec2 E = vec2(0);
    
    for(int i = 0; i < n; ++i) {
        vec2 slitCoord = vec2( 0, a * (float(i) - float(n / 2)) );
        fragColor = mix(fragColor, vec4(0,1,0,0), 
                smoothstep( 10., 5., length(fragCoord - phys2px(slitCoord) ) )
            );
        
        float phase = nu * float(iFrame) - length(px2phys(fragCoord) - slitCoord);
        
        E += vec2( cos(phase), sin(phase) );
    }
    
    // vec2 slitCoord = vec2( 0 );      
    // float phase = nu * float(iFrame) - length(px2phys(fragCoord) - slitCoord);
    
    
    //fragColor = coloring(cos( atan(E.y, E.x) ));
    fragColor = coloring(E.x / float(n));
    //fragColor = coloring(length(E) / float(n));
    
}