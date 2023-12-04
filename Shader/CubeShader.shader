Shader "Custom/CubeShader"
{
    Properties
    {
        _ColorPrimary ("Primary Color", Color) = (1,1,1,1)
        _ColorSecondary("Secondary Color", Color) = (1,1,1,1)
        _ColorTertiary ("Tertiary Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _ColorPrimary;
        fixed4 _ColorSecondary;
        fixed4 _ColorTertiary;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
             fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _ColorPrimary;
             o.Albedo = c.xyz;

            float deltaTime = 1.0;
            float currPos = (_Time.y % deltaTime) / deltaTime;
            if (abs(IN.worldPos.y + 0.5 - currPos) < 0.02)
            {
                o.Albedo = _ColorTertiary;
            } 
            else if (floor(_Time.y / deltaTime) % 2 == 0)
            {
                if (IN.worldPos.y + 0.5 - currPos < 0.0)
                {
                    o.Albedo = _ColorSecondary;
                }

            }
            else
            {
                c = tex2D (_MainTex, IN.uv_MainTex) * _ColorSecondary;
                o.Albedo = c.xyz;
                if (IN.worldPos.y + 0.5 - currPos < 0.0)
                {
                    o.Albedo = _ColorPrimary;
                }
            }

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"	
}
