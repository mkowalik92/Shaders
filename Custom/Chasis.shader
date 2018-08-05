Shader "Custom/Chasis"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
	_TintColor("Tint Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Transparency("Transparency", Range(0.0, 1.0)) = 1.0
		_NoiseTex("Noise Texture", 2D) = "white" {}
	_NoiseSpeed("Noise Scroll Speed", vector) = (0.0, 0.2, 0.0, 0.0)
	}
		SubShader
	{
		Tags
	{
		"RenderType" = "Transparent"
		"Queue" = "Transparent"
	}
		LOD 200

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
	{

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 uvNoise : TEXCOORD1;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	sampler2D _NoiseTex;
	float4 _NoiseTex_ST;
	float4 _NoiseSpeed;

	v2f vert(appdata i)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(i.vertex);
		o.uv = TRANSFORM_TEX(i.uv, _MainTex);
		o.uvNoise = TRANSFORM_TEX(i.uv, _NoiseTex);
		o.uvNoise += _NoiseSpeed * _Time.x;
		return o;
	}

	fixed4 _TintColor;
	float _Transparency;

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 textureColor = tex2D(_MainTex, i.uv);
	fixed4 noiseColor = tex2D(_NoiseTex, i.uvNoise);
	return fixed4((fixed3(1.0, 1.0, 1.0) - textureColor.rgb) * noiseColor * _TintColor, _Transparency);
	}
		ENDCG
	}

	}
}
