Shader "Custom/Smoke"
{
    Properties
    {
        _MainTex("", 2D) = ""
        _VelocityField("", 2D) = ""
    }

        CGINCLUDE

#include "UnityCG.cginc"

        sampler2D _MainTex;
    float4 _MainTex_TexelSize;

    sampler2D _VelocityField;

    float2 _ForceOrigin;
    float _ForceExponent;

    half4 frag_clear(v2f_img i) : SV_Target
    {
        return half4(1,1,1,1);
    }

        half4 frag_advect(v2f_img i) : SV_Target
    {
        // Time parameters
        float deltaTime = unity_DeltaTime.x;
        float time = _Time.y;

    // Aspect ratio coefficients
    float2 aspect = float2(_MainTex_TexelSize.y * _MainTex_TexelSize.z, 1);
    float2 aspect_inv = float2(_MainTex_TexelSize.x * _MainTex_TexelSize.w, 1);

    // Color advection with the velocity field
    float2 delta = tex2D(_VelocityField, i.uv).xy * aspect_inv * deltaTime;
    float4 color = tex2D(_MainTex, i.uv - delta) * 0.98;

    // Smoke (inject smoke)
    //float4 smoke = float4(0.8, 0.8, 1.0, 0.7);
    float3 dye = saturate(sin(time * float3(2.72, 5.12, 4.98)) + 0.5);
    float4 smoke = float4(dye, 0.7);

    // Blend smoke with the color from the buffer.   
    float2 pos = (i.uv ) * aspect;
    float amp = exp(-_ForceExponent * distance(_ForceOrigin, pos));
    color = lerp(color, smoke, saturate(amp * 100));

     //float4 color = float4(saturate(delta), 0.1, 1.0);

    return color;
    }

        half4 frag_render(v2f_img i) : SV_Target
    {
        half4 color = tex2D(_MainTex, i.uv);

        return color;
    }

        ENDCG

        SubShader
    {
        Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

            Cull Off ZWrite Off ZTest Always
            Blend SrcAlpha OneMinusSrcAlpha

            Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_advect
            ENDCG
        }
            Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_render
            ENDCG
        }
            Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_clear
            ENDCG
        }
    }
}
