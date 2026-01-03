void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;

    float d = min(iResolution.x, iResolution.y);

    vec3 col = vec3(
        0.5 + 0.25 * sin(2. * iTime),
        0.5 + 0.5 * sin(4. * iTime),
        0.5 + 0.35 * sin(1. * iTime)
    );

    fragColor = vec4(col * smoothstep(d/4., d/2., length(fragCoord - iResolution.xy / 2.)), 1.0);

    if ( iMouse.w > 0.0 ) {
        fragColor += smoothstep(25., 20., length(fragCoord - iMouse.xy) );
    }

}