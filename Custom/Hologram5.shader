Shader "Unlit/Hologram"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_GridTex ("Grid Texture", 2D) = "white" {}
		_ScrollVector ("Scroll Speed/Direction", vector) = (0.0, 20.0, 0.0, 0.0)
		_ScanTex ("Scan Texture", 2D) = "white" {}
		_ScrollVector ("Scroll Speed/Direction", vector) = (0.0, 20.0, 0.0, 0.0)
		_ScanlineColor ("Scanline Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_HologramColor("Hologram Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Tags 
		{ 
			"RenderType" = "Transparent" 
			"Queue" = "Transparent"
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

			sampler2D _GridTex;
			float4 _GridTex_ST;
			fixed4 _HologramColor;
			
			v2f vert (appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.uv = TRANSFORM_TEX(i.uv, _GridTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_GridTex, i.uv);
				return col + fixed4(_HologramColor.rgb, 0.0);
			}
			ENDCG
		}
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
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				float2 texuv : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _HologramColor;

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.color = i.color;
				o.texuv = TRANSFORM_TEX(float2(i.uv.x, i.uv.y), _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return (i.color * tex2D(_MainTex, i.texuv) + fixed4(_HologramColor.rgb, 0.0));
			}
			ENDCG
		}
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
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				float2 texuv : TEXCOORD1;
			};

			sampler2D _ScanTex;
			float4 _ScanTex_ST;
			float4 _ScrollVector;
			fixed4 _ScanlineColor;

			v2f vert(appdata i)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(i.vertex);
				o.color = i.color;
				o.uv = TRANSFORM_TEX(i.uv, _ScanTex);
				o.uv += _ScrollVector * _Time.x;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color * tex2D(_ScanTex, i.uv) * _ScanlineColor;
			}
			ENDCG
		}
	}
}
