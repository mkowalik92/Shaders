// Square Gradient Shader Example for quads/planes

// Marek Kowalik
// Free to use anywhere. Credit appreciated, but not necessary.
// Made with help from: https://thebookofshaders.com by converting GLSL to HLSL

Shader "Custom/Unlit/square-gradiant-quad-plane"
{
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
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				// Left
				float pct1x = i.uv.x * 2.0;
				// Bottom
				float pct1y = i.uv.y * 2.0;
				// Combine Left and Bottom
				float pct1 = pct1x * pct1y;

				// Right
				float pct2x = (1.0 - i.uv.x) * 2.0;
				// Top
				float pct2y = (1.0 - i.uv.y) * 2.0;
				// Combine with Bottom Left
				pct1 = mul(pct1, pct2x * pct2y);

				float3 color = (pct1, pct1, pct1);
				
				return float4(color, 1.0);
			}
			ENDCG
		}
	}
}
