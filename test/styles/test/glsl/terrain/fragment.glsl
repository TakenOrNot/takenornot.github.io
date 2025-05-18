#version 300 es

// extension GL_OES_standard_derivatives : enable
precision lowp float;
// WORKING
// Uniforms
// uniform float minusOneToOneTime;
uniform vec3 lightPos;
uniform float flyCam;
uniform float gamma;
uniform vec2 screenSize;
uniform mat4 world;
uniform mat4 view;
uniform vec3 bottomColor;
uniform vec3 diffuseColor;
uniform float pseudoBrightness;
uniform float makeShadows;
uniform float shadowUVXoffset;
uniform vec3 fogColor;
uniform sampler2D textureSamplerPerlin;
uniform sampler2D textureSamplerGrass;
uniform sampler2D textureSamplerNorm_grass;
uniform sampler2D textureSamplerNorm_rocks;

#ifdef SHADOW0
    uniform sampler2D shadow0Sampler;
    uniform vec3 shadow0Params;
    uniform sampler2D shadowSamplerClouds;
#endif

#ifdef GAMEBTR
    uniform float firewall_radius;
    uniform float minusOneToOneTime; // Must be declared since it's used in GAMEBTR block
#endif

// Inputs (changed from varying to in)
in float clipped;
in vec3 lightDir;
in vec3 pos;
in vec3 vPosition;
in vec2 vUV;
in vec2 vUV2;
in vec2 vUV4;
in vec3 normalInterp;
in float fogDensity;
in float isSnow;
in vec4 v0PositionFromLight;

#ifdef GAMEBTR
    in float distFromCenterOfFirewall;
#endif

// Output
out vec4 fragColor;

// Constants
const vec3 ambientColor = vec3(0.0);
const vec3 specColor = vec3(0.9, 0.9, 0.7);
const vec3 colorSand = vec3(0.6, 0.54, 0.29);
const float groundStartY = 0.8;

const vec2 uv_offset_size = vec2(1.0, 1.0);
const vec2 waves_size = vec2(0.05, 0.05);
const lowp float aspect_Ratio = 1.0;

#include<shadowCalc.glsl>

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
  // Changed texture2D -> texture for GLSL 300 es
  lowp float tpn=texture(textureSamplerPerlin,vUV*2.).x,tpn4=texture(textureSamplerPerlin,vUV*25.).x;
  float colorM=0.;
  vec3 nrmMapGrass=texture(textureSamplerNorm_grass,vUV*15.).xyz,color3grass=texture(textureSamplerGrass,vUV*15.).xyz;
  vec2 nvUV=vec2(vUV.x*2.,vUV.y);
  vec3 nrmMapRocks=texture(textureSamplerNorm_rocks,nvUV*10.).xyz;
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
      vec2 texture_based_offset=texture(textureSamplerPerlin,offset_texture_uvs).xy;
      texture_based_offset=texture_based_offset*2.-1.;
      vec2 adjusted_uv=vUV2*.5;
      adjusted_uv.y*=1.;
      vec2 nvUV=adjusted_uv+texture_based_offset*waves_size;
      tpn=texture(textureSamplerPerlin,nvUV).x;
      color4.x+=clamp((distFromCenterOfFirewall-firewall_radius)/10.*10.,0.,10.);
      color4.y+=tpn*clamp((distFromCenterOfFirewall-firewall_radius)/10.,0.,1.);
    }
  
#endif

  fragColor = color4;
  
#include<imageProcessingCompatibility>

}