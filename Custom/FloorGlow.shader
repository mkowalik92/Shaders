Shader "Custom/FloorGlow" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader{
			Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }

			Lighting Off
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Pass{

		//Wrapper CGPROGRAM -> ENDCG
		CGPROGRAM

		#pragma vertex vert // tells that the code contains a vertex program in the given function named vert
		#pragma fragment frag // tells that the code contains a fragment program in the given function frag
		#include "UnityCG.cginc" // include the header that contains declarations and functions

		sampler2D _MainTex;
		// vertex to fragment structure - info passed to from the vertex to the fragment program
		struct v2f {
		float4 vertex : SV_POSITION;
		float2 uv : TEXCOORD0;
		/*fixed3 color : COLOR0;*/
		};

		struct appdata_t {
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			//float4 color : COLOR;
		};


		v2f vert(appdata_t i)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(i.vertex);
			float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
			o.vertex.y += sin(worldPos.y + _Time.w) * 0.5 + 0.5;
			o.uv = i.uv;

			//o.color = v.normal * 0.5 + 0.5;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.vertex);
			//col.a = 1 - i.texcoord.y * sin(1.7*_Time.w)*3;
			return col;
		}
		ENDCG

		}
		
	}
}
