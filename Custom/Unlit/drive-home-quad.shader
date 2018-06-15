Shader "Custom/Unlit/circle-prac"
{
	Properties
	{
		_Center ("Circle Center", Vector) = (0.0, 0.0, 0.0, 0.0)
		_Radius ("Radius", float) = 0.1
		_CircleColor ("Circle Color", Color) = (0.0, 0.0, 0.0, 1.0)
		_BackgroundColor ("Background Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }

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

			float gt (float x, float y) {
				return max(sign(x - y), 0.0);
			}

			float lte (float x, float y) 
			{
				return 1.0 - gt(x, y);
			}

			float4 _Center;
			float _Radius;
			fixed4 _CircleColor;
			fixed4 _BackgroundColor;

			float bokeh(float2 uv, float2 center, float size, float blur)
			{
				float distance = sqrt(pow(abs(uv.x - center.x), 2.0) + pow(abs(uv.y - center.y), 2.0));
				float c = smoothstep(size, size*(1.0 - blur), distance);
				c *= lerp(0.6, 1.0, smoothstep(size * 0.8, size, distance));
				return c;
			}

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// Circle in center | * (sin(_Time.z) + 1.0)
				//float distance = sqrt(pow(abs(i.uv.x - _Center.x), 2.0) + pow(abs(i.uv.y - _Center.y), 2.0));
				//return (_BackgroundColor * gt(distance, _Radius)) + (_CircleColor * lte(distance, _Radius));
				float2 center = float2(_Center.x, _Center.y);
				//float c = smoothstep(.1, .09, distance);
				float c = bokeh(i.uv, center + float2(frac(_Time.y), frac(_Time.y)), 0.1 + frac(_Time.y), 0.1);
				fixed3 color = fixed3(1.0, 0.7, 0.3) * c;
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
}
