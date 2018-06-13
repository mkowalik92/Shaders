Shader "Custom/dual-tex-half-slider"
{
	Properties
	{
		_LeftTex ("Left Texture", 2D) = "black" {}
		_RightTex ("Right Texture", 2D) = "white" {}
		_MiddlePoint("Textures' Middle Point", Range(0.0, 1.0)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION; // position (in object coordinates, model/local coordinates)
				float2 uv : TEXCOORD0; //0th set of texture coordinates (0 <-> 1)
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
			};

			sampler2D _LeftTex;
			float4 _LeftTex_ST;
			sampler2D _RightTex;
			float4 _RightTex_ST;
			float _MiddlePoint;


			float less_than (float x, float y)
			{
				return max(sign(y - x), 0.0);
			}

			float greater_than (float x, float y)
			{
				return max(sign(x - y), 0.0);
			}

			float gte (float x, float y)
			{
				return 1.0 - less_than(x, y);
			}
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = TRANSFORM_TEX(i.uv, _LeftTex);
				o.uv2 = TRANSFORM_TEX(i.uv, _RightTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float distanceFromMiddlePoint = abs(_MiddlePoint - i.uv.x);
				float mixFactor = 1.0 - ((_MiddlePoint - i.uv.x) + 0.2) / 0.4;
				return (tex2D(_LeftTex, i.uv) * less_than(i.uv.x, _MiddlePoint) * gte(distanceFromMiddlePoint, 0.2)) + (tex2D(_RightTex, i.uv2) * greater_than(i.uv.x, _MiddlePoint) * gte(distanceFromMiddlePoint, 0.2)) + (lerp(tex2D(_LeftTex, i.uv), tex2D(_RightTex, i.uv2), mixFactor) * less_than(distanceFromMiddlePoint, 0.2));
			}
			ENDCG
		}
	}
}
