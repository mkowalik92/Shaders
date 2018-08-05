Shader "Unlit/prac"
{
	Properties
	{
		_MainTex ("Grid Pattern", 2D) = "white" {}
		_SecondaryTex ("Overlay Texture", 2D) = "white" {}
		_TintColor ("Tint Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SecGrid ("Grid Pattern 2", 2D) = "white" {}
		_Transparency ("Transparency", Range(0.0, 1.0)) = 1.0
	}
	SubShader
	{
		

		Pass
		{
			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texuv : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				o.color = i.color;
				o.texuv = TRANSFORM_TEX(float2(i.uv.x, i.uv.y), _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color * tex2D(_MainTex, i.texuv);
			}
			ENDCG
		}
		Pass
		{
			Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texuv : TEXCOORD1;
			};

			sampler2D _SecondaryTex;
			sampler2D _SecGrid;
			float4 _SecGrid_ST;

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				o.color = i.color;
				o.texuv = TRANSFORM_TEX(float2(i.uv.x, i.uv.y), _SecGrid);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color * (tex2D(_SecondaryTex, i.uv) * tex2D(_SecGrid, i.texuv));
			}
			ENDCG
		}
		Pass
		{
			Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

			
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			};

			float _Transparency;
			fixed4 _TintColor;


			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = i.uv;
				o.color = i.color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(i.color.r * _TintColor.r, i.color.g * _TintColor.g, i.color.b * _TintColor.b, _Transparency);
			}
			ENDCG
		}
	}
}
