// todo : antialiasing
precision highp float;
uniform float iTime;
uniform float iFrame;
uniform vec2 iResolution;
const float pi = 3.14159265358979;

const float fov = 40.; // width, degrees

const float fovtan = tan(radians(fov) * .5);

mat3 RM(float psi, float theta) {
    float cX = cos(theta);
    float sX = sin(theta);
    float cZ = cos(psi);
    float sZ = sin(psi);
    
    return mat3( 
         cZ, sZ, 0,
        -sZ, cZ, 0,
          0,  0, 1
    ) * mat3(
        1,   0,  0,
        0,  cX, sX,
        0, -sX, cX
    );
}

float integrate() {
  return 0.;
}

float density(vec4 q) {
  float R = q.y;
  //return 1./R;
  const float h = .01;
  float az = abs(q.w - pi/2.);
  if (R < 3.) return 0.;
  if (az > h) return 0.;
  return (1. + (0.612372*log( (sqrt(2.*R)+1.732) / (sqrt(2.*R)-1.732) ) - 2.8115)/sqrt(R) ) / ((R-1.5)*pow(R, 2.)) * (1.-az/h);
}

vec4 rhw(vec4 q, vec4 v) { // w = v̇ (not the covariant w)
  float costheta = cos(q.w);
  float sintheta = sin(q.w);
  float B = ( 1. - q.y );
  float A = 1. / B;
  
  
//  return vec4(
//    0,
//    q.y * (v.w*v.w + pow(v.z*sintheta,2.)),
//    -2.*v.z*(v.y + q.y*v.w*costheta/sintheta)/q.y,
//    -2.*v.y*v.w/q.y + v.z*v.z*costheta*sintheta
//  );
  return vec4(
    A * v.y * v.x,
    .5 * B * ( -pow(v.y*A, 2.) - 2.*q.y*v.w*v.w + pow(v.w/q.y,2.) - 2.*q.y*pow(v.z*sintheta,2.)),
    -2.*v.z*(v.y + q.y*v.w*costheta/sintheta),
    -2.*v.y*v.w + v.z*v.z*costheta*sintheta*q.y
  ) / q.y;
}

vec4 rk4(vec4 q) {
  return vec4(0);
}

vec4 rayMarch(vec4 q0, vec4 v0) {
  const float hdh = .02; // half integration step
  const float da = 1.; // affine parameter
  float A; // accumulated albedo
  //vec3 uduf; // Binet phase variables: u=1/r, u'(φ), φ
  //vec3 duduf;
  //mat3 Mp; // coordinate transform from the propagation plane
  
  // uduf = binetVars(xyz0, exyz, Mp);
  
  vec4 q = q0;
  vec4 v = v0;
  vec4 w; float dl;
  
  for( int i = 0 ; i < 10000; i++) { // discarding inside the photone sphere and further than specified radial distance
    if (q.y > 100. || q.y < 1.5) {
        break;
    }
    w = rhw(q, v);
    q += v * hdh;
    v += w * hdh;
    dl = 2. * hdh; //TODO
    A += density(q)*dl;
    q += v * hdh;
    v += w * hdh;
  }
  
  return vec4(A);
}

vec4 colorize(float A) {
  //return vec4(A);
  //return vec4(A+.55, (A-.1)*(A+.95),1.25 ,1) * A;
  return vec4((A-.1)*(A+.95), 1.5, A+.25,1) * A;
}

vec4 gii(vec4 q) { // diagonal metric tensor
  float A = 1. - 1./q.y;
  return vec4( A, -1./A, -pow(q.y * sin(q.w),2.), -pow(q.y,2.) ); // Schwarzschild
}

void main() {
  vec2 XY = (2. * gl_FragCoord.xy - iResolution.xy) / iResolution.x; // screenspace coordinates
  
  // camera
  //mat3 Mc = RM(0., 1.);
  //vec3 xyz = Mc * vec3(0,0,50); // worldspace cartesian initial location
  vec4 q0 = vec4(iTime, 35, 0, 1.45); // τrφθ
  //vec3 exyz = Mc * normalize(vec3(fovtan * XY, -1)); // worldspace cartesian direction
  vec4 v0 = vec4(-1, normalize( vec3(-1, fovtan * XY * vec2(1,-1) ) )) * inversesqrt(abs(gii(q0)));

  gl_FragColor = colorize(1700.*rayMarch(q0, v0).x); // colorize(1000. * density(vec3(25.*XY,0)));
  //gl_FragColor = vec4(density(vec4(0, length(XY) * 50., 0., pi/2.)));
}