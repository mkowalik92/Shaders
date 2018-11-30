// Simple volumetric rendering using raymarching
// Practicing with Alan Zucconi tutorials and implementing more signed distance functions

Shader "Unlit/RaymarchingPractice"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
		_Center ("Center", Vector) = (0.0, 0.0, 0.0)
		_SphereRadius ("Sphere Radius", Float) = 0.5
		_TorusDimensions ("Torus Major:Minor Radius", Vector) = (0.33, 0.17, 0.0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			#define STEPS 64
			#define STEP_SIZE 0.01

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 Pos : SV_POSITION; // Clip space
				float3 wPos : TEXCOORD1; // World position
				//float2 uv : TEXCOORD0;
				//float4 vertex : SV_POSITION;
			};

			float3 _Center;
			float _SphereRadius;
			float2 _TorusDimensions;

			//sampler2D _MainTex;
			//float4 _MainTex_ST;

			bool sphereHit (float3 position)
			{
				return distance(position, _Center) < _SphereRadius;
			}

			bool torusHit (float3 position)
			{
				float2 q = float2(distance(position.xy, _Center.xz) - _TorusDimensions.x, position.z);
				return distance(q, _Center.xz) < _TorusDimensions.y;
			}

			bool raymarchHit (float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++)
				{
					if (torusHit(position)) return true;
					position += direction * STEP_SIZE;
				}
				return false;
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.Pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//fixed4 col = tex2D(_MainTex, i.uv);
				float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
				if (raymarchHit(i.wPos, viewDirection))
				{
					return fixed4(1.0, 0.0, 0.0, 1.0);
				}
				else
				{
					return fixed4(1.0, 1.0, 1.0, 1.0);
				}
				//return col;
			}
			ENDCG
		}
	}
}
