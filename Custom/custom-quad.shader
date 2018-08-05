Shader "Custom/custom-quad"
{
	Properties
	{
		_Color ("Color", color) = (1.0, 1.0, 1.0, 1.0)
		_StepMultiplier ("Step Multiplier", float) = 10.0
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
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			float plot(float2 uv, float pct)
			{
				return smoothstep(pct - 0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
			}
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				return o;
			}

			float4 _Color;
			float _StepMultiplier;
			
			float4 frag(v2f i) : SV_Target
			{
				//Half of the quad only
				//float y = step((1.0 - ((cos(_Time * _StepMultiplier) * 0.5) + 0.5)) / 2.0, i.uv.x);

				// ((_SinTime.z + 1.0) / 2.0) | ((_SinTime.z * 0.5) + 0.5)
				float y = step(1.0 - ((cos(_Time * _StepMultiplier) * 0.5) + 0.5), i.uv.x);
				float3 color = float3(y, y, y);
				//float pct = plot(i.uv, y);
				//color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);
				return float4(color.x, color.y, color.z, 1.0);
			}
			ENDCG
		}
	}
}
