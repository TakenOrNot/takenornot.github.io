#version 300 es

// Set precision explicitly for float and int
precision mediump float;
precision mediump int;

// === Inputs with explicit locations matching vertex shader ===
layout(location = 0) in vec2 vUV;
layout(location = 1) in vec2 vUV2;
layout(location = 2) in vec2 vUV4;
layout(location = 3) in vec4 vPosPack;
layout(location = 4) in vec4 vFogPack;
layout(location = 5) in vec4 vLightShadow;
layout(location = 6) in vec4 v0PositionFromLight;
layout(location = 7) in vec3 vPosition;
layout(location = 8) in vec3 normalInterp;

#ifdef GAMEBTR
    layout(location = 9) in float distFromCenterOfFirewall;
    uniform float firewall_radius;
#endif

// === Unpacked Variables ===
float clipped = vFogPack.w;
float fogDensity = vFogPack.z;
float isSnow = vPosPack.w;

uniform vec3 lightPos;
vec3 lightDir = vLightShadow.xyz;

vec3 pos = vPosPack.xyz;

// UV coordinates from vertex shader
vec2 localUV = vUV;
vec2 localUV2 = vUV2;
vec2 localUV4 = vUV4;

// === Uniforms ===
uniform float minusOneToOneTime;
uniform float flyCam;
uniform float gamma;
uniform vec2 screenSize;
uniform mat4 world;
uniform mat4 view;

// Texture samplers
uniform sampler2D textureSamplerPerlin;
const vec2 uv_offset_size = vec2(1.0, 1.0);
const vec2 waves_size = vec2(0.05, 0.05);
const lowp float aspect_Ratio = 1.0;

uniform sampler2D textureSamplerGrass;
uniform sampler2D textureSamplerNorm_grass;
uniform sampler2D textureSamplerNorm_rocks;

// Material properties
uniform vec3 bottomColor;
const float bFlat = 0.0;
const vec3 ambientColor = vec3(0.0, 0.0, 0.0);
uniform vec3 diffuseColor;
uniform float pseudoBrightness;
const vec3 specColor = vec3(0.9, 0.9, 0.7);
const vec3 colorSand = vec3(0.6, 0.54, 0.29);

// Shadow properties
uniform float makeShadows;
uniform float shadowUVXoffset;

#ifdef SHADOW0
    uniform sampler2D shadow0Sampler;
    uniform vec3 shadow0Params;
    uniform sampler2D shadowSamplerClouds;
#endif

// Fog properties
uniform vec3 fogColor;

// Output
out vec4 fragColor;


#define inline

float computeShadow(sampler2D shadowSampler, sampler2D shadowSamplerClouds, vec4 vPositionFromLight,float darkness,float mapSize,float bias,float flyCam)
{
  vec3 depth=vPositionFromLight.xyz/vPositionFromLight.w;
  depth=.5*depth+vec3(.5)-bias;
  vec2 uv=depth.xy;
  if(uv.x<0.||uv.x>1.||uv.y<0.||uv.y>1.)
    return 0.;
 
  float shad = texture2D(shadowSampler, uv).x;
                        // for exponential filtering :
                        /*
                        float s = 0.05;
                        if (depth.z >= shad){
                            s = 0.0;
                        } 
                        */
                        float s = 0.0;
                        //if (depth.z >= shad){
                        //    s = 0.06;
                        //} else {
                        //if (shad > 0.0){

                        
                            // REM : TODO : offset should be inverse proportionnal to xgame.vis
                            float offset = 0.002 - (0.0005 * flyCam);
                            vec2 offset1 = vec2(offset, offset);
                            vec2 offset2 = vec2(-offset, offset);
                            vec2 offset3 = vec2(offset, -offset);
                            vec2 offset4 = vec2(-offset, -offset);
                            
                            vec2 offset5 = vec2(offset, 0.0);
                            vec2 offset6 = vec2(0.000, offset);
                            vec2 offset7 = vec2(-offset, 0.0);
                            vec2 offset8 = vec2(0.0, -offset);
                        
                            float shad1 = texture2D(shadowSampler, uv + offset1).x;
                            float shad2 = texture2D(shadowSampler, uv + offset2).x;
                            float shad3 = texture2D(shadowSampler, uv + offset3).x;
                            float shad4 = texture2D(shadowSampler, uv + offset4).x;
                            float shad5 = texture2D(shadowSampler, uv + offset5).x;
                            float shad6 = texture2D(shadowSampler, uv + offset6).x;
                            float shad7 = texture2D(shadowSampler, uv + offset7).x;
                            float shad8 = texture2D(shadowSampler, uv + offset8).x;
                            
                            if (depth.z >= shad || depth.z >= shad1 || depth.z >= shad2 || depth.z >= shad3 || depth.z >= shad4 || depth.z >= shad5 || depth.z >= shad6 || depth.z >= shad7 || depth.z >= shad8){
                                //s = 0.05;
                                s = 0.1 - (((shad + shad1 + shad2 + shad3 + shad4 + shad5 + shad6 + shad7 + shad8) / 9.0) * 0.1);
                            
                                
                            } 

    //uv= vec2(vUV3.x/163.+.5 + shadowUVXoffset,((vUV3.y/163.)-.5));
    //float vUVx
    //if (vUV3.x/163. + shadowUVXoffset < 0.){
    //    vUVx = 1.0 - (vUV3.x/163. + shadowUVXoffset)
    //}
    //uv= vec2((vUV3.x/163.) + shadowUVXoffset,((vUV3.y/163.)));
    //uv= vec2((vUV3.x) + shadowUVXoffset,(vUV3.y));
    uv = vec2(0.5 + (localUV4.x / 163.0) + shadowUVXoffset,0.5 + (localUV4.y/163.));
    float cloudShad = texture2D(shadowSamplerClouds,uv).x;
                            float cloudShad1 = texture2D(shadowSamplerClouds,uv + offset1).x;
                            float cloudShad2 = texture2D(shadowSamplerClouds,uv + offset2).x;
                            float cloudShad3 = texture2D(shadowSamplerClouds,uv + offset3).x;
                            float cloudShad4 = texture2D(shadowSamplerClouds,uv + offset4).x;
                            float cloudShad5 = texture2D(shadowSamplerClouds,uv + offset5).x;
                            float cloudShad6 = texture2D(shadowSamplerClouds,uv + offset6).x;
                            float cloudShad7 = texture2D(shadowSamplerClouds,uv + offset7).x;
                            float cloudShad8 = texture2D(shadowSamplerClouds,uv + offset8).x;

                            if (cloudShad > 0.5 || cloudShad1 > 0.5 || cloudShad2 > 0.5 || cloudShad3 > 0.5 || cloudShad4 > 0.5 || cloudShad5 > 0.5 || cloudShad6 > 0.5 || cloudShad7 > 0.5 || cloudShad8 > 0.5){
                                //s += (cloudShad / 9.0)*.5;
                                //s += clamp((cloudShad - 0.49), 0.0, 0.02);
                                //s += 1.0;
                                s += (((cloudShad + cloudShad1 + cloudShad2 + cloudShad3 + cloudShad4 + cloudShad5 + cloudShad6 + cloudShad7 + cloudShad8) / 9.0) * (0.05 + (0.05 * flyCam)));
                            }
    

  
    

    
    
    #ifdef OVERLOADEDSHADOWVALUES

    
    #else

    return s;
    
    #endif

}
void main()
{
  vec3 color3=mix(vec3(.1,.2,.4),vec3(.5),fogDensity);
  vec4 color4=vec4(color3,1);
  if(clipped>0.||fogDensity>1.22)
    {
      color4=vec4(1,0,0,0);
      discard;
    }
  lowp float groundStartY=.8;
  
#ifdef MOBILEDEVICE

  groundStartY=1.;
  
#endif

  float s1=0.;
  
#ifdef SHADOW0
  if (makeShadows > 0.0){  
  //s1= makeShadows > 0.0 ? computeShadow(shadow0Sampler,v0PositionFromLight,shadow0Params.x,shadow0Params.y,shadow0Params.z,flyCam);
  s1= computeShadow(shadow0Sampler,shadowSamplerClouds,v0PositionFromLight,shadow0Params.x,shadow0Params.y,shadow0Params.z,flyCam);
  }
#endif

  vec3 normal=normalize(normalInterp);
  lowp float tpn=texture2D(textureSamplerPerlin,vUV*2.).x,tpn4=texture2D(textureSamplerPerlin,vUV*25.).x;
  float colorM=0.;
  vec3 nrmMapGrass=texture2D(textureSamplerNorm_grass,vUV*15.).xyz,color3grass=texture2D(textureSamplerGrass,vUV*15.).xyz;
  vec2 nvUV=vec2(vUV.x*2.,vUV.y);
  vec3 nrmMapRocks=texture2D(textureSamplerNorm_rocks,nvUV*10.).xyz;
  if(isSnow>.5||vPosition.y<=1.5+.01*sin(pos.x*50.)-.01*sin(pos.z*50.))
    {
      if(vPosition.y<=1.3)
        colorM=vPosition.y<=1.1?
          .1:
          (clamp(2.*(1.-vPosition.y/1.3),0.,1.)-clamp((1.3-vPosition.y)/.3,0.,1.))/2.;
      vec3 new_normal=mat3(world)*normal*(vec3(0)*.5+.5);
      normal=new_normal;
    }
  else if(vPosition.y>1.5+.01*sin(pos.x*50.)-.01*sin(pos.z*50.)&&vPosition.y<=2.3+.01*sin(pos.x*50.)-.01*sin(pos.z*50.))
    {
      vec3 new_normal=mat3(world)*normal*nrmMapGrass;
      if(isSnow<.5)
        normal=new_normal;
    }
  else if(vPosition.y>=2.15+.01*sin(pos.x*50.)-.01*sin(pos.z*50.)&&vPosition.y-3.8+sin(pos.x*5.)*sin(pos.z*5.)/4.<0.)
    {
      vec3 nrmMap=nrmMapRocks,new_normal=mat3(world)*normal*nrmMap;
      lowp float TMPdifLight=dot(new_normal,lightDir),TMPhLambert=TMPdifLight*.5+.5;
      nrmMap.y=TMPhLambert<.5?
        nrmMap.y*TMPhLambert:
        nrmMap.y*.25;
      new_normal=mat3(world)*normal*nrmMap;
      normal=new_normal*5.;
    }
  vec3 viewDir=vec3(0,1,0);
  if(fogDensity<1.22)
    if(vPosition.y>groundStartY)
      {
        lowp float difLight=dot(normal,lightDir),hLambert=difLight*.5+.5;
        float ndl=dot(normal,lightDir),specComp=dot(normal,normalize(viewDir+lightDir));
        specComp/=50.;
        ndl=ndl*.5+.5;
        lowp float sinPosX50=sin(pos.x*50.),sinPosZ50=sin(pos.z*50.);
        if(fogDensity<1.)
          {
            if(vPosition.y<1.5+.01*sinPosX50-.01*sinPosZ50||isSnow>.5)
              {
                color3=colorSand;
                if(isSnow<.5)
                  {
                    if(vPosition.y>1.4)
                      color3-=vec3(clamp(-1.4+vPosition.y,0.,.1));
                    else if(vPosition.y<1.2)
                      color3-=vec3(clamp(1.2-vPosition.y-.1,0.,.1)),color3=mix(vec3(.375,.33,.12),color3,clamp((vPosition.y-1.)/.05-.5,0.,1.));
                    color3-=clamp(tpn-.5,0.,.5)+tpn4*colorM;
                  }
                color3*=.2666;
                if(flyCam<.5)
                  ndl+=.05;
                if(ndl>.75)
                  color3*=1.25;
                else if(ndl>.5)
                  color3*=1.1;
                if(isSnow>.5)
                  color3.x=color3.y-.05-.15*clamp(1.-(vPosition.y-1.)/.1,0.,1.),color3.y=color3.y-.075*clamp(1.-(vPosition.y-1.)/.1,0.,1.),color3.z=color3.y+.05,color3*=2.5,color3+=.2*clamp((vPosition.y-2.)/4.,0.,1.)+.1*clamp((vPosition.y-2.)/4.,0.,1.)*hLambert,color3-=tpn4/40.;
              }
            else if(isSnow<.5&&vPosition.y>1.5+.01*sinPosX50-.01*sinPosZ50&&vPosition.y<=2.3+.01*sinPosX50-.01*sinPosZ50)
              {
                float shadowness=clamp((1.-hLambert)*(1.-fogDensity*3.)*(2.-pseudoBrightness),0.,1.);
                if(vPosition.y>2.)
                  color3grass-=clamp(((vPosition.y-2.)/.3+.01*sinPosX50-.01*sinPosZ50)*.1,0.,1.)*shadowness;
                color3grass=(vec3(color3grass.x+.75*clamp(tpn-.5,0.,.5)+.05*tpn4+.4*clamp(tpn-.5,0.,.5),color3grass.y+.45+.2*clamp(tpn-.5,0.,.5),color3grass.z-.1-.2*clamp(tpn-.5,0.,.5))-clamp(.1+(1.7-vPosition.y)/.2*(.1*shadowness),.1,1.))*.37;
                color3grass.x-=.05;
                color3grass.y-=.05;
                color3grass.z-=.1;
                if(flyCam<.5)
                  ndl+=.05;
                if(ndl>.75)
                  color3grass*=1.5;
                else if(ndl>.5)
                  color3grass*=1.25;
                color3=color3grass;
              }
            else if(isSnow<.5&&vPosition.y>=2.15+.01*sinPosX50-.01*sinPosZ50)
              {
                color3=vec3(.0625+.2*(1.-hLambert),.04,.1+.06*(1.+2.*(.75-hLambert)));
                color3.x=clamp(color3.x+.15*normal.z*hLambert,.05,1.);
                color3.y=clamp(color3.y+.05*normal.z*hLambert,.02,1.);
                color3.z=clamp(color3.z+.9*normal.z*hLambert,.22,1.);
                vec3 colorMt=vec3(.1-.05*(1.-clamp((vPosition.y-2.15)/.75,0.,1.))-.05*clamp(1.-(vPosition.y-2.15)/.75,0.,1.),.1+.05*clamp(1.-(vPosition.y-2.15)/.25*tpn4,0.,1.),.1-.05*(1.-clamp((vPosition.y-2.15)/.75,0.,1.))-.05*clamp(1.-(vPosition.y-2.15)/.75,0.,1.));
                color3=vec3(.4,.4,.5);
                color3.z+=.1*(1.-hLambert)*pseudoBrightness;
                if(ndl<.5)
                  color3*=.9,colorMt*=.7;
                color3-=1.-max(min((vPosition.y-3.8+sin(pos.x*5.)*sin(pos.z*5.)/4.)/.1,1.),0.);
                color3=mix(colorMt,color3,1.-clamp(1.-(vPosition.y-3.8+sin(pos.x*5.)*sin(pos.z*5.)/4.)/.5,0.,1.));
              }
            color3=vec3(mix(color3-s1+ndl*diffuseColor+vec3(specComp)*specColor,fogColor,clamp(fogDensity,0.,1.)));
            color4=vec4(pow(color3,vec3(1./gamma)),1);
          }
        else
          {
            if(fogDensity<1.22)
              color3=vec3(mix(fogColor,bottomColor*diffuseColor*.5+.2*(2.-pseudoBrightness),(fogDensity-1.)/.22))*(1.+(fogDensity-1.)/.22);
            color4=vec4(pow(color3,vec3(1./gamma)),1);
          }
      }
    else
      {
        
#ifdef MOBILEDEVICE

        discard;
        
#endif

      }
  else
     discard;
  
#ifdef GAMEBTR

  if(distFromCenterOfFirewall>firewall_radius)
    {
      lowp float tpn=0.;
      vec2 offset_texture_uvs=vUV2*uv_offset_size;
      offset_texture_uvs+=minusOneToOneTime;
      vec2 texture_based_offset=texture2D(textureSamplerPerlin,offset_texture_uvs).xy;
      texture_based_offset=texture_based_offset*2.-1.;
      vec2 adjusted_uv=vUV2*.5;
      adjusted_uv.y*=1.;
      vec2 nvUV=adjusted_uv+texture_based_offset*waves_size;
      tpn=texture2D(textureSamplerPerlin,nvUV).x;
      color4.x+=clamp((distFromCenterOfFirewall-firewall_radius)/10.*10.,0.,10.);
      color4.y+=tpn*clamp((distFromCenterOfFirewall-firewall_radius)/10.,0.,1.);
    }
  
#endif

  fragColor=color4;
  
#include<imageProcessingCompatibility>

}