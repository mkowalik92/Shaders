Shader "Unlit/fire-cape-lava"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScrollVector ("Scroll Speed/Direction", vector) = (0.0, 20.0, 0.0, 0.0)
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
			float4 _ScrollVector;
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
				o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				o.uv += _ScrollVector * _Time.x;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
