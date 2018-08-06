Shader "Custom/Button"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Transparency("Transparency", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Tags 
		{ 
			//"RenderType" = "Opaque"
			"RenderType"="Transparent" 
			"Queue" = "Transparent+1" 
		}
		LOD 200

		ZWrite Off
		//ZTest Less
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				return o;
			}

			fixed4 _TintColor;
			float _Transparency;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 textureColor = tex2D(_MainTex, i.uv);
				//return fixed4(textureColor.rgb, _Transparency);

				return fixed4((fixed3(1.0, 1.0, 1.0) - textureColor.rgb) * _TintColor, _Transparency);
			}
			ENDCG
		}
		//Pass
		//{
		//	Cull Front
		//	CGPROGRAM
		//	#pragma vertex vert
		//	#pragma fragment frag

		//	#include "UnityCG.cginc"

		//	struct appdata
		//	{
		//		float4 vertex : POSITION;
		//		float2 uv : TEXCOORD0;
		//	};

		//	struct v2f
		//	{
		//		float4 vertex : SV_POSITION;
		//		float2 uv : TEXCOORD0;
		//	};

		//	sampler2D _MainTex;
		//	float4 _MainTex_ST;

		//	v2f vert(appdata i)
		//	{
		//		v2f o;
		//		o.vertex = UnityObjectToClipPos(i.vertex);
		//		o.uv = TRANSFORM_TEX(i.uv, _MainTex);
		//		return o;
		//	}

		//	fixed4 _TintColor;
		//	float _Transparency;

		//	fixed4 frag(v2f i) : SV_Target
		//	{
		//		fixed4 textureColor = tex2D(_MainTex, i.uv);
		//		return fixed4(textureColor.rgb, _Transparency);
		//		//return fixed4((fixed3(1.0, 1.0, 1.0) - textureColor.rgb) * _TintColor, _Transparency);
		//	}
		//	ENDCG
		//}
	}
}
