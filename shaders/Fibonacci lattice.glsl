#version 300 es
precision highp float;
out vec4 fragColor;
uniform int iFrame;
uniform vec2 iResolution;
const float goldenAngle = 2.4;

void main() {
  int frame = 1*iFrame;
  vec2 uv = 2.*gl_FragCoord.xy / iResolution.xy - 1.;
  
  float col = 0.;
  float r, R;

  for (int i = 0; i <= frame; ++i) {
    R = .2 / sqrt( float(frame) );
    if ( frame <= 1 ) {
      r = 0.;
    } else {
      r = .9 * sqrt( float(i - 1) / float(frame - 1) );
  	}
  
    float phi = float(i) * goldenAngle;
    vec2 xy = r * vec2( cos(phi), sin(phi) );
    
    col += smoothstep( 3.*R, R, length(uv - xy) );
  }
  
  fragColor = vec4(vec3(col*col),1);
}