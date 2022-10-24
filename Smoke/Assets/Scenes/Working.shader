Shader "Custom/Working"
{
    Properties
    {
        _MainTex("", 2D) = ""
    }

        CGINCLUDE

#include "UnityCG.cginc"

    sampler2D _MainTex;
   
    half4 frag_advect(v2f_img i) : SV_Target
    {
        float3 color = tex2D(_MainTex, i.uv);
        return half4(color, 1);
    }
        ENDCG

        SubShader
    {
        Cull Off ZWrite Off ZTest Always
            Pass
        {
            CGPROGRAM
            #pragma vertex vert_img       
            ENDCG
        }
    }
}

