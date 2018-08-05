Shader "Custom/quad-hologram"
{
	Properties
	{
		_ChasisTex ("Chasis", 2D) = "white" {}
		_TriggerTex ("Trigger", 2D) = "white" {}
		_BackTex ("Back", 2D) = "white" {}
		_HomeTex ("Home", 2D) = "white" {}
		_DiscTex ("Disc", 2D) = "white" {}
		_CenterTex ("Center", 2D) = "white" {}
		_TintColor ("Hologram Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags 
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent" 
		}
		LOD 100

		ZWrite Off
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
			
			sampler2D _ChasisTex;
			float4 _ChasisTex_ST;
			sampler2D _CenterTex;
			float4 _CenterTex_ST;
			fixed4 _TintColor;

			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = TRANSFORM_TEX(i.uv, _ChasisTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 chasis = fixed4(1.0, 1.0, 1.0, 0.0) - tex2D(_ChasisTex, i.uv);
				chasis = chasis * _TintColor;
				fixed4 center = fixed4(1.0, 1.0, 1.0, 0.0) - tex2D(_CenterTex, i.uv);
				return fixed4(chasis.rgb * center.rgb, chasis.a + center.a);
			}
			ENDCG
		}
	}
}
