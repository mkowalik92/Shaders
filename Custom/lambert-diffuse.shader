Shader "Custom/Lit/lambert-diffuse"
{
	Properties
	{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Diffuse ("Diffuse Magnitude", Range(0.0, 1.0)) = 1.0
	}
	Subshader
	{
		Tags { "LightMode" = "ForwardBase" }

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 color : COLOR0;
			};

			float4 _Color;
			float _Diffuse;
			float4 _LightColor0;

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);

				//Lambertian reflection
				float3 surfaceNorm = normalize(mul(i.normal, (float3x3)unity_WorldToObject)); //Surface's normal vector
				float3 lightDirNorm = normalize(_WorldSpaceLightPos0.xyz); //Normalized light direction vector
				float NdotL = max(0.0, dot(surfaceNorm, lightDirNorm));
				fixed4 lambRef = _Color * NdotL * _LightColor0 * _Diffuse;
				o.color = lambRef;

				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}

			ENDCG
		}
	}
}