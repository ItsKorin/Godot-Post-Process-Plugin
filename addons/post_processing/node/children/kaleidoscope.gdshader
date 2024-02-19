shader_type canvas_item;

// CC0: Truchet + Kaleidoscope FTW
//  Bit of experimenting with kaleidoscopes and truchet turned out nice
//  Quite similar to an earlier shader I did but I utilized a different truchet pattern this time

uniform float animate_speed = 0.25;
uniform float resolution = 1.0;

// License: Unknown, author: Unknown, found: don't remember
vec4 alphaBlend(vec4 back, vec4 front) {
  float w = front.w + back.w*(1.0-front.w);
  vec3 xyz = (front.xyz*front.w + back.xyz*back.w*(1.0-front.w))/w;
  return w > 0.0 ? vec4(xyz, w) : vec4(0.0);

}
mat2 ROT(float a){
	return mat2(vec2(cos(a),sin(a)),vec2(-sin(a),cos(a)));
}
float PCOS(float x){
	return 0.5+0.5*cos(x);
}

// License: Unknown, author: Unknown, found: don't remember
vec3 alphaBlend34(vec3 back, vec4 front) {
  return mix(back, front.xyz, front.w);
}

// License: Unknown, author: Unknown, found: don't remember
float hashf(float co) {
  return fract(sin(co*12.9898) * 13758.5453);
}

// License: Unknown, author: Unknown, found: don't remember
float hashv(vec2 p) {
  float a = dot(p, vec2 (127.1, 311.7));
  return fract(sin (a)*43758.5453123);
}

// License: Unknown, author: Unknown, found: don't remember
float tanh_approx(float x) {
  //  Found this somewhere on the interwebs
  //  return tanh(x);
  float x2 = x*x;
  return clamp(x*(27.0 + x2)/(27.0+9.0*x2), -1.0, 1.0);
}

// License: MIT, author: Inigo Quilez, found: https://www.iquilezles.org/www/articles/smin/smin.htm
float pmin(float a, float b, float k) {
  float h = clamp(0.5+0.5*(b-a)/k, 0.0, 1.0);
  return mix(b, a, h) - k*h*(1.0-h);
}

// License: MIT, author: Inigo Quilez, found: https://www.iquilezles.org/www/index.htm
vec3 postProcess(vec3 col, vec2 q) {
  col = clamp(col, 0.0, 1.0);
  col = pow(col, vec3(1.0/2.2));
  col = col*0.6+0.4*col*col*(3.0-2.0*col);
  col = mix(col, vec3(dot(col, vec3(0.33))), -0.4);
  col *=0.5+0.5*pow(19.0*q.x*q.y*(1.0-q.x)*(1.0-q.y),0.7);
  return col;
}

float pmax(float a, float b, float k) {
  return -pmin(-a, -b, k);
}

float pabs(float a, float k) {
  return pmax(a, -a, k);
}

vec2 toPolar(vec2 p) {
  return vec2(length(p), atan(p.y, p.x));
}

vec2 toRect(vec2 p) {
  return vec2(p.x*cos(p.y), p.x*sin(p.y));
}

// License: MIT OR CC-BY-NC-4.0, author: mercury, found: https://mercury.sexy/hg_sdf/
float modMirror1(inout float p, float size) {
  float halfsize = size*0.5;
  float c = floor((p + halfsize)/size);
  p = mod(p + halfsize,size) - halfsize;
  p *= mod(c, 2.0)*2.0 - 1.0;
  return c;
}

float smoothKaleidoscope(inout vec2 p, float sm, float rep) {
  vec2 hp = p;

  vec2 hpp = toPolar(hp);
  float rn = modMirror1(hpp.y, 2.0*PI/rep);

  float sa = PI/rep - pabs(PI/rep - abs(hpp.y), sm);
  hpp.y = sign(hpp.y)*(sa);

  hp = toRect(hpp);

  p = hp;

  return rn;
}

// The path function
vec3 offset(float z) {
  float a = z;
  vec2 p = -0.075*(vec2(cos(a), sin(a*sqrt(2.0))) + vec2(cos(a*sqrt(0.75)), sin(a*sqrt(0.5))));
  return vec3(p, z);
}

// The derivate of the path function
//  Used to generate where we are looking
vec3 doffset(float z) {
  float eps = 0.1;
  return 0.5*(offset(z + eps) - offset(z - eps))/eps;
}

// The second derivate of the path function
//  Used to generate tilt
vec3 ddoffset(float z) {
  float eps = 0.1;
  return 0.125*(doffset(z + eps) - doffset(z - eps))/eps;
}

vec2 cell_df(float r, vec2 np, vec2 mp, vec2 off) {

  vec2 n0 = normalize(vec2(1.0, 1.0));
  vec2 n1 = normalize(vec2(1.0, -1.0));

  np += off;
  mp -= off;
  
  float hh = hashv(np);
  float h0 = hh;

  vec2  p0 = mp;  
  p0 = abs(p0);
  p0 -= 0.5;
  float d0 = length(p0);
  float d1 = abs(d0-r); 

  float dot0 = dot(n0, mp);
  float dot1 = dot(n1, mp);

  float d2 = abs(dot0);
  float t2 = dot1;
  d2 = abs(t2) > sqrt(0.5) ? d0 : d2;

  float d3 = abs(dot1);
  float t3 = dot0;
  d3 = abs(t3) > sqrt(0.5) ? d0 : d3;


  float d = d0;
  d = min(d, d1);
  if (h0 > .85)
  {
    d = min(d, d2);
    d = min(d, d3);
  }
  else if(h0 > 0.5)
  {
    d = min(d, d2);
  }
  else if(h0 > 0.15)
  {
    d = min(d, d3);
  }
  
  return vec2(d, (d0-r));
}

vec2 truchet_df(float r, vec2 p) {
  vec2 np = floor(p+0.5);
  vec2 mp = fract(p+0.5) - 0.5;
  return cell_df(r, np, mp, vec2(0.0));
}

vec4 plane(vec3 ro, vec3 rd, vec3 pp, vec3 off, float aa, float n) {
  float h_ = hashf(n);
  float h0 = fract(1777.0*h_);
  float h1 = fract(2087.0*h_);
  float h2 = fract(2687.0*h_);
  float h3 = fract(3167.0*h_);
  float h4 = fract(3499.0*h_);

  float l = length(pp - ro);

  vec3 hn;
  vec2 p = (pp-off*vec3(1.0, 1.0, 0.0)).xy;
  p *= ROT(0.5*(h4 - 0.5)*TIME);
  float rep = 2.0*round(mix(5.0, 30.0, h2));
  float sm = 0.05*20.0/rep;
  float sn = smoothKaleidoscope(p, sm, rep);
  p *= ROT(2.0*PI*h0+0.025*TIME);
  float z = mix(0.2, 0.4, h3);
  p /= z;
  p+=0.5+floor(h1*1000.0);
  float tl = tanh_approx(0.33*l);
  float r = mix(0.30, 0.45, PCOS(0.1*n));
  vec2 d2 = truchet_df(r, p);
  d2 *= z;
  float d = d2.x;
  float lw =0.025*z; 
  d -= lw;
  
  vec3 col = mix(vec3(1.0), vec3(0.0), smoothstep(aa, -aa, d));
  col = mix(col, vec3(0.0), smoothstep(mix(1.0, -0.5, tl), 1.0, sin(PI*100.0*d)));
//  float t0 = smoothstep(aa, -aa, -d2.y-lw);
  col = mix(col, vec3(0.0), step(d2.y, 0.0));
  //float t = smoothstep(3.0*lw, 0.0, -d2.y);
//  float t = smoothstep(aa, -aa, -d2.y-lw);
  float t = smoothstep(aa, -aa, -d2.y-3.0*lw)*mix(0.5, 1.0, smoothstep(aa, -aa, -d2.y-lw));
  return vec4(col, t);
}

vec3 skyColor(vec3 ro, vec3 rd) {
  float d = pow(max(dot(rd, vec3(0.0, 0.0, 1.0)), 0.0), 20.0);
  return vec3(d);
}


vec3 color(vec3 ww, vec3 uu, vec3 vv, vec3 ro, vec2 p){
  float lp = length(p);
  vec2 np = p + 1.0/vec2(1920.0*resolution,1080.0*resolution) ;
  float rdd = (2.0+1.0*tanh_approx(lp));
//  float rdd = 2.0;
  vec3 rd = normalize(p.x*uu + p.y*vv + rdd*ww);
  vec3 nrd = normalize(np.x*uu + np.y*vv + rdd*ww);

   float planeDist = 1.0-0.25;
   int furthest = 6;
   int fadeFrom = max(furthest-5, 0);

  float fadeDist = planeDist*float(furthest - fadeFrom);
  float nz = floor(ro.z / planeDist);

  vec3 skyCol = skyColor(ro, rd);


  vec4 acol = vec4(0.0);
  float cutOff = 0.95;
  bool cutOut = false;

  // Steps from nearest to furthest plane and accumulates the color 
  for (int i = 1; i <= furthest; ++i) {
    float pz = planeDist*nz + planeDist*float(i);

    float pd = (pz - ro.z)/rd.z;

    if (pd > 0.0 && acol.w < cutOff) {
      vec3 pp = ro + rd*pd;
      vec3 npp = ro + nrd*pd;

      float aa = 3.0*length(pp - npp);

      vec3 off = offset(pp.z);

      vec4 pcol = plane(ro, rd, pp, off, aa, nz+float(i));

      float nz1 = pp.z-ro.z;
      float fadeIn = smoothstep(planeDist*float(furthest), planeDist*float(fadeFrom), nz1);
      float fadeOut = smoothstep(0.0, planeDist*0.1, nz1);
      pcol.xyz = mix(skyCol, pcol.xyz, fadeIn);
      pcol.w *= fadeOut;
      pcol = clamp(pcol, 0.0, 1.0);

      acol = alphaBlend(pcol, acol);
    } else {
      cutOut = true;
      break;
    }

  }

  vec3 col = alphaBlend34(skyCol, acol);
// To debug cutouts due to transparency  
//  col += cutOut ? vec3(1.0, -1.0, 0.0) : vec3(0.0);
  return col;
}
vec3 effect(vec2 p, vec2 q) {
  float tm  = TIME*animate_speed;
  vec3 ro   = offset(tm);
  vec3 dro  = doffset(tm);
  vec3 ddro = ddoffset(tm);

  vec3 ww = normalize(dro);
  vec3 uu = normalize(cross(normalize(vec3(0.0,1.0,0.0)+ddro), ww));
  vec3 vv = normalize(cross(ww, uu));

  vec3 col = color(ww, uu, vv, ro, p);
  
  return col;
}
void fragment(){



  vec2 q = FRAGCOORD.xy/(1.0 / SCREEN_PIXEL_SIZE).xy;
  vec2 p = -1. + 2. * q;
  p.x *= (1.0 / SCREEN_PIXEL_SIZE).x/(1.0 / SCREEN_PIXEL_SIZE).y;
  
  vec3 col = effect(p, q);
  col *= smoothstep(0.0, 4.0, TIME);
  col = postProcess(col, q);
 
  COLOR = vec4(col, 1.0);
}