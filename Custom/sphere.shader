Shader "Custom/Unlit/sphere"
{
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Diffuse("Diffuse Magnitude", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		Tags { "LightMode" = "ForwardBase" "RenderType"="Opaque" }

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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR0;
			};

			float4 _Color;
			float _Diffuse;
			float4 _LightColor0;
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
				o.vertex.xy += i.normal.xy * (sin(worldPos.y + _Time.w * 2.0) * 0.5 + 0.5);
				o.vertex.z += i.normal.z * frac(_SinTime.w) + 1.0;

				//o.vertex.y += cos(worldPos.x + _Time.w);
				//o.vertex.x += sin(_Time.w) * 0.5 + 0.5;
				o.uv = i.uv;
				float3 surfaceNorm = normalize(mul(i.normal, (float3x3)unity_WorldToObject)); //Surface's normal vector
				float3 lightDirNorm = normalize(_WorldSpaceLightPos0.xyz); //Normalized light direction vector
				float NdotL = max(0.0, dot(surfaceNorm, lightDirNorm));
				fixed4 lambRef = _Color * NdotL * _LightColor0 * _Diffuse;
				o.color = lambRef;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}
