float cuberp(float f1, float f2, float f3, float f4, float t1)
{

    float delta_k = f3 - f2;
    float d_k = 0.5 * (f3 - f1);
    float d_k1 = 0.5 * (f4 - f2);

    float t2 = t1 * t1;
    float t3 = t2 * t1;

    if ((delta_k) == 0 || (sign(d_k) != sign(delta_k) || sign(d_k1) != sign(delta_k)))
    {
        d_k = 0;
        d_k1 = 0;
    }
    
    float a0 = f2;
    float a1 = d_k;
    float a2 = 3 * delta_k - 2 * d_k - d_k1;
    float a3 = d_k + d_k1 - 2 * delta_k;

    return a3 * t3 + a2 * t2 + a1 * t1 + a0;
}

float f1SampleCubic(Texture2D<float> f, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5;
    clamp(t, 0.5, (dim - 0.5));

    int2 k = (int2)t;
    float2 t1 = t - float2(k);

    float f11 = f[k + int2(-1, -1)];
    float f12 = f[k + int2(-1, 0)];
    float f13 = f[k + int2(-1, 1)];
    float f14 = f[k + int2(-1, 2)];

    float f21 = f[k + int2(0, -1)];
    float f22 = f[k];
    float f23 = f[k + int2(0, 1)];
    float f24 = f[k + int2(0, 2)];

    float f31 = f[k + int2(1, -1)];
    float f32 = f[k + int2(1, 0)];
    float f33 = f[k + int2(1, 1)];
    float f34 = f[k + int2(1, 2)];

    float f41 = f[k + int2(2, -1)];
    float f42 = f[k + int2(2, 0)];
    float f43 = f[k + int2(2, 1)];
    float f44 = f[k + int2(2, 2)];

    return cuberp(cuberp(f11, f12, f13, f14, t1.y), cuberp(f21, f22, f23, f24, t1.y),
        cuberp(f31, f32, f33, f34, t1.y), cuberp(f41, f42, f43, f44, t1.y), t1.x);
}

float2 cuberp(float2 f1, float2 f2, float2 f3, float2 f4, float t1)
{

    float2 delta_k = f3 - f2;
    float2 d_k = 0.5 * (f3 - f1);
    float2 d_k1 = 0.5 * (f4 - f2);

    float t2 = t1 * t1;
    float t3 = t2 * t1;

    if ((delta_k.x) == 0 || (sign(d_k.x) != sign(delta_k.x) || sign(d_k1.x) != sign(delta_k.x)))
    {
        d_k.x = 0;
        d_k1.x = 0;
    }
    if ((delta_k.y) == 0 || (sign(d_k.y) != sign(delta_k.y) || sign(d_k1.y) != sign(delta_k.y)))
    {
        d_k.y = 0;
        d_k1.y = 0;
    }

    float2 a0 = f2;
    float2 a1 = d_k;
    float2 a2 = 3 * delta_k - 2 * d_k - d_k1;
    float2 a3 = d_k + d_k1 - 2 * delta_k;

    return a3 * t3 + a2 * t2 + a1 * t1 + a0;
}

float2 f2SampleCubic(Texture2D<float2> f, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5;
    clamp(t, 0.5, (dim - 0.5));

    int2 k = (int2)t;
    float2 t1 = t - float2(k);

    float2 f11 = f[k + int2(-1, -1)];
    float2 f12 = f[k + int2(-1, 0)];
    float2 f13 = f[k + int2(-1, 1)];
    float2 f14 = f[k + int2(-1, 2)];

    float2 f21 = f[k + int2(0, -1)];
    float2 f22 = f[k];
    float2 f23 = f[k + int2(0, 1)];
    float2 f24 = f[k + int2(0, 2)];

    float2 f31 = f[k + int2(1, -1)];
    float2 f32 = f[k + int2(1, 0)];
    float2 f33 = f[k + int2(1, 1)];
    float2 f34 = f[k + int2(1, 2)];

    float2 f41 = f[k + int2(2, -1)];
    float2 f42 = f[k + int2(2, 0)];
    float2 f43 = f[k + int2(2, 1)];
    float2 f44 = f[k + int2(2, 2)];

    return cuberp(cuberp(f11, f12, f13, f14, t1.y), cuberp(f21, f22, f23, f24, t1.y),
        cuberp(f31, f32, f33, f34, t1.y), cuberp(f41, f42, f43, f44, t1.y), t1.x);
}

float SampleBilinear(Texture2D<float> textur, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5f;
    pos = max(0.5, t);
    pos = min(pos, ((float2)dim - 0.5));

    int2 k = (int2) t;
    float2 f = t - k;

    int2 p1 = int2(k + 1);
    p1 = min(dim - 1, p1);

    float x0 = textur[k] * (1.0 - f.x) + textur[int2(p1.x, k.y)] * f.x;
    float y0 = textur[int2(k.x, p1.y)] * (1.0 - f.x) + textur[p1] * f.x;

    return x0 * (1.0 - f.y) + y0 * f.y;
}


float2 SampleBilinear(Texture2D<float2> textur, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5f;
    pos = max(0.5, t);
    pos = min(pos, ((float2)dim - 0.5));

    int2 k = (int2) t;
    float2 f = t - k;

    int2 p1 = int2(k + 1);
    p1 = min(dim - 1, p1);
    
    float2 x0 = textur[k] * (1.0 - f.x) + textur[int2(p1.x, k.y)] * f.x;
    float2 y0 = textur[int2(k.x, p1.y)] * (1.0 - f.x) + textur[p1] * f.x;

    return x0 * (1.0 - f.y) + y0 * f.y;
}

float4 SampleBilinear(Texture2D<float4> textur, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5f;
    pos = max(0.5, t);
    pos = min(pos, ((float2)dim - 0.5));

    int2 k = (int2) t;
    float2 f = t - k;

    int2 p1 = int2(k + 1);
    p1 = min(dim - 1, p1);

    float4 x0 = textur[k] * (1.0 - f.x) + textur[int2(p1.x, k.y)] * f.x;
    float4 y0 = textur[int2(k.x, p1.y)] * (1.0 - f.x) + textur[p1] * f.x;

    return x0 * (1.0 - f.y) + y0 * f.y;
}

float SampleCubic(Texture2D<float> f, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5;
    clamp(t, 0.5, (dim - 0.5));

    int2 k = (int2)t;
    float2 t1 = t - float2(k);

    float t1y = t1.y;
    float t2y = t1y * t1y;
    float t3y = t2y * t1y;
    
    //X1
    float f11 = f[k + int2(-1, -1)];
    float f12 = f[k + int2(-1, 0)];
    float f13 = f[k + int2(-1, 1)];
    float f14 = f[k + int2(-1, 2)];
    
    float delta_kx1 = f13 - f12;
    float d_kx1 = 0.5 * (f13 - f11);
    float d_k1x1 = 0.5 * (f14 - f12);

    if ((delta_kx1) == 0 || (sign(d_kx1) != sign(delta_kx1) || sign(d_k1x1) != sign(delta_kx1)))
     {
      d_kx1 = 0;
      d_k1x1 = 0;
     }
    /*if ((delta_kx1.y) == 0 || (sign(d_kx1.y) != sign(delta_kx1.y) || sign(d_k1x1.y) != sign(delta_kx1.y)))
    {
        d_kx1.y = 0;
        d_k1x1.y = 0;
    }*/


    float a0x1 = f12;
    float a1x1 = d_kx1;
    float a2x1 = 3 * delta_kx1 - 2 * d_kx1 - d_k1x1;
    float a3x1 = d_kx1 + d_k1x1 - 2 * delta_kx1;

    float X1 = a3x1 * t3y + a2x1 * t2y + a1x1 * t1y + a0x1;

    //X2
    float f21 = f[k + int2(0, -1)];
    float f22 = f[k];
    float f23 = f[k + int2(0, 1)];
    float f24 = f[k + int2(0, 2)];

    float delta_kx2 = f23 - f22;
    float d_kx2 = 0.5 * (f23 - f21);
    float d_k1x2 = 0.5 * (f24 - f22);

    if ((delta_kx2) == 0 || (sign(d_kx2) != sign(delta_kx2) || sign(d_k1x2) != sign(delta_kx2)))
    {
        d_kx2 = 0;
        d_k1x2 = 0;
    }
    /*if ((delta_kx2.y) == 0 || (sign(d_kx2.y) != sign(delta_kx2.y) || sign(d_k1x2.y) != sign(delta_kx2.y)))
    {
        d_kx2.y = 0;
        d_k1x2.y = 0;
    }
*/

    float a0x2 = f22;
    float a1x2 = d_kx2;
    float a2x2 = 3 * delta_kx2 - 2 * d_kx2 - d_k1x2;
    float a3x2 = d_kx2 + d_k1x2 - 2 * delta_kx2;

    float X2 = a3x2 * t3y + a2x2 * t2y + a1x2 * t1y + a0x2;

    //X3
    float f31 = f[k + int2(1, -1)];
    float f32 = f[k + int2(1, 0)];
    float f33 = f[k + int2(1, 1)];
    float f34 = f[k + int2(1, 2)];

    float delta_kx3 = f33 - f32;
    float d_kx3 = 0.5 * (f33 - f31);
    float d_k1x3 = 0.5 * (f34 - f32);

    if ((delta_kx3) == 0 || (sign(d_kx3) != sign(delta_kx3) || sign(d_k1x3) != sign(delta_kx3)))
    {
        d_kx3 = 0;
        d_k1x3 = 0;
    }
    //if ((delta_kx3.y) == 0 || (sign(d_kx3.y) != sign(delta_kx3.y) || sign(d_k1x3.y) != sign(delta_kx3.y)))
    //{
    //    d_kx3.y = 0;
    //    d_k1x3.y = 0;
    //}


    float a0x3 = f32;
    float a1x3 = d_kx3;
    float a2x3 = 3 * delta_kx3 - 2 * d_kx3 - d_k1x3;
    float a3x3 = d_kx3 + d_k1x3 - 2 * delta_kx3;

    float X3 = a3x3 * t3y + a2x3 * t2y + a1x3 * t1y + a0x3;

    //X4
    float f41 = f[k + int2(2, -1)];
    float f42 = f[k + int2(2, 0)];
    float f43 = f[k + int2(2, 1)];
    float f44 = f[k + int2(2, 2)];

    float delta_kx4 = f43 - f42;
    float d_kx4 = 0.5 * (f43 - f41);
    float d_k1x4 = 0.5 * (f44 - f42);

    if ((delta_kx4) == 0 || (sign(d_kx4) != sign(delta_kx4) || sign(d_k1x4) != sign(delta_kx4)))
    {
        d_kx4 = 0;
        d_k1x4 = 0;
    }
    //if ((delta_kx4.y) == 0 || (sign(d_kx4.y) != sign(delta_kx4.y) || sign(d_k1x4.y) != sign(delta_kx4.y)))
    //{
    //    d_kx4.y = 0;
    //    d_k1x4.y = 0;
    //}


    float a0x4 = f42;
    float a1x4 = d_kx4;
    float a2x4 = 3 * delta_kx4 - 2 * d_kx4 - d_k1x4;
    float a3x4 = d_kx4 + d_k1x4 - 2 * delta_kx4;

    float X4 = a3x4 * t3y + a2x4 * t2y + a1x4 * t1y + a0x4;

    //Yt
    float t1x = t1.x;
    float t2x = t1x * t1x;
    float t3x = t2x * t1x;

    float delta_ky = X3 - X2;
    float d_ky = 0.5 * (X3 - X1);
    float d_k1y = 0.5 * (X4 - X2);

    if ((delta_ky) == 0 || (sign(d_ky) != sign(delta_ky) || sign(d_k1y) != sign(delta_ky)))
    {
        d_ky = 0;
        d_k1y = 0;
    }
    //if ((delta_ky.y) == 0 || (sign(d_ky.y) != sign(delta_ky.y) || sign(d_k1y.y) != sign(delta_ky.y)))
    //{
    //    d_ky.y = 0;
    //    d_k1y.y = 0;
    //}


    float a0y = X2;
    float a1y = d_ky;
    float a2y = 3 * delta_ky - 2 * d_ky - d_k1y;
    float a3y = d_ky + d_k1y - 2 * delta_ky;

    
    return a3y*t3x + a2y * t2x + a1y * t1x + a0y;
}


float2 SampleCubic(Texture2D<float2> f, float2 pos, uint2 dim)
{
    float2 t = pos - 0.5;
    clamp(t, 0.5, (dim - 0.5));
    /*clamp(t.x, 0.5 , (dim.x - 0.5));
    clamp(t.y, 0.5, (dim.y - 0.5));
   */

    int2 k = (int2)t;
    float2 t1 = t - float2(k);

    float t1y = t1.y;
    float t2y = t1y * t1y;
    float t3y = t2y * t1y;

    //X1
    float2 f11 = f[k + int2(-1, -1)];
    float2 f12 = f[k + int2(-1, 0)];
    float2 f13 = f[k + int2(-1, 1)];
    float2 f14 = f[k + int2(-1, 2)];

    float2 delta_kx1 = f13 - f12;
    float2 d_kx1 = 0.5 * (f13 - f11);
    float2 d_k1x1 = 0.5 * (f14 - f12);

    if ((delta_kx1.x) == 0 || (sign(d_kx1.x) != sign(delta_kx1.x) || sign(d_k1x1.x) != sign(delta_kx1.x)))
    {
        d_kx1.x = 0;
        d_k1x1.x = 0;
    }
    if ((delta_kx1.y) == 0 || (sign(d_kx1.y) != sign(delta_kx1.y) || sign(d_k1x1.y) != sign(delta_kx1.y)))
    {
        d_kx1.y = 0;
        d_k1x1.y = 0;
    }


    float2 a0x1 = f12;
    float2 a1x1 = d_kx1;
    float2 a2x1 = 3 * delta_kx1 - 2 * d_kx1 - d_k1x1;
    float2 a3x1 = d_kx1 + d_k1x1 - 2 * delta_kx1;

    float2 X1 = a3x1 * t3y + a2x1 * t2y + a1x1 * t1y + a0x1;

    //X2
    float2 f21 = f[k + int2(0, -1)];
    float2 f22 = f[k];
    float2 f23 = f[k + int2(0, 1)];
    float2 f24 = f[k + int2(0, 2)];

    float2 delta_kx2 = f23 - f22;
    float2 d_kx2 = 0.5 * (f23 - f21);
    float2 d_k1x2 = 0.5 * (f24 - f22);

    if ((delta_kx2.x) == 0 || (sign(d_kx2.x) != sign(delta_kx2.x) || sign(d_k1x2.x) != sign(delta_kx2.x)))
    {
        d_kx2.x = 0;
        d_k1x2.x = 0;
    }
    if ((delta_kx2.y) == 0 || (sign(d_kx2.y) != sign(delta_kx2.y) || sign(d_k1x2.y) != sign(delta_kx2.y)))
    {
        d_kx2.y = 0;
        d_k1x2.y = 0;
    }


    float2 a0x2 = f22;
    float2 a1x2 = d_kx2;
    float2 a2x2 = 3 * delta_kx2 - 2 * d_kx2 - d_k1x2;
    float2 a3x2 = d_kx2 + d_k1x2 - 2 * delta_kx2;

    float2 X2 = a3x2 * t3y + a2x2 * t2y + a1x2 * t1y + a0x2;

    //X3
    float2 f31 = f[k + int2(1, -1)];
    float2 f32 = f[k + int2(1, 0)];
    float2 f33 = f[k + int2(1, 1)];
    float2 f34 = f[k + int2(1, 2)];

    float2 delta_kx3 = f33 - f32;
    float2 d_kx3 = 0.5 * (f33 - f31);
    float2 d_k1x3 = 0.5 * (f34 - f32);

    if ((delta_kx3.x) == 0 || (sign(d_kx3.x) != sign(delta_kx3.x) || sign(d_k1x3.x) != sign(delta_kx3.x)))
    {
        d_kx3.x = 0;
        d_k1x3.x = 0;
    }
    if ((delta_kx3.y) == 0 || (sign(d_kx3.y) != sign(delta_kx3.y) || sign(d_k1x3.y) != sign(delta_kx3.y)))
    {
        d_kx3.y = 0;
        d_k1x3.y = 0;
    }


    float2 a0x3 = f32;
    float2 a1x3 = d_kx3;
    float2 a2x3 = 3 * delta_kx3 - 2 * d_kx3 - d_k1x3;
    float2 a3x3 = d_kx3 + d_k1x3 - 2 * delta_kx3;

    float2 X3 = a3x3 * t3y + a2x3 * t2y + a1x3 * t1y + a0x3;

    //X4
    float2 f41 = f[k + int2(2, -1)];
    float2 f42 = f[k + int2(2, 0)];
    float2 f43 = f[k + int2(2, 1)];
    float2 f44 = f[k + int2(2, 2)];

    float2 delta_kx4 = f43 - f42;
    float2 d_kx4 = 0.5 * (f43 - f41);
    float2 d_k1x4 = 0.5 * (f44 - f42);

    if ((delta_kx4.x) == 0 || (sign(d_kx4.x) != sign(delta_kx4.x) || sign(d_k1x4.x) != sign(delta_kx4.x)))
    {
        d_kx4.x = 0;
        d_k1x4.x = 0;
    }
    if ((delta_kx4.y) == 0 || (sign(d_kx4.y) != sign(delta_kx4.y) || sign(d_k1x4.y) != sign(delta_kx4.y)))
    {
        d_kx4.y = 0;
        d_k1x4.y = 0;
    }


    float2 a0x4 = f42;
    float2 a1x4 = d_kx4;
    float2 a2x4 = 3 * delta_kx4 - 2 * d_kx4 - d_k1x4;
    float2 a3x4 = d_kx4 + d_k1x4 - 2 * delta_kx4;

    float2 X4 = a3x4 * t3y + a2x4 * t2y + a1x4 * t1y + a0x4;

    //Yt
    float t1x = t1.x;
    float t2x = t1x * t1x;
    float t3x = t2x * t1x;

    float2 delta_ky = X3 - X2;
    float2 d_ky = 0.5 * (X3 - X1);
    float2 d_k1y = 0.5 * (X4 - X2);

    if ((delta_ky.x) == 0 || (sign(d_ky.x) != sign(delta_ky.x) || sign(d_k1y.x) != sign(delta_ky.x)))
    {
        d_ky.x = 0;
        d_k1y.x = 0;
    }
    if ((delta_ky.y) == 0 || (sign(d_ky.y) != sign(delta_ky.y) || sign(d_k1y.y) != sign(delta_ky.y)))
    {
        d_ky.y = 0;
        d_k1y.y = 0;
    }


    float2 a0y = X2;
    float2 a1y = d_ky;
    float2 a2y = 3 * delta_ky - 2 * d_ky - d_k1y;
    float2 a3y = d_ky + d_k1y - 2 * delta_ky;


    return a3y * t3x + a2y * t2x + a1y * t1x + a0y;
}

//float2 SampleCubic(Texture2D<float2> f, float2 pos, uint2 dim)
//{
//    double2 t = pos - 0.5;
//    t = max(0.5, t);
//    t = min(t, ((float2)dim - 0.5));
//
//    int2 k = (int2)t;
//
//    float2 f1 = f[k];
//    float2 f2 = f[k + 1];
//    float2 f0 = f[k - 1];
//    float2 f3 = f[k + 2];
//
//    double2 t1 = abs(t - float2(k));
//    double2 t2 = t1 * t1;
//    double2 t3 = t2 * t1;
//
//    float2 delta_k = f2 - f1;
//    float2 d_k = 0.5 * (f2 - f0);
//    float2 d_k1 = 0.5 * (f3 - f1);
//
//    if ((delta_k.x) == 0)
//    {
//        d_k.x = 0;
//        d_k1.x = 0;
//    }
//
//    if ((delta_k.y) == 0)
//    {
//        d_k.y = 0;
//        d_k1.y = 0;
//    }
//    if (sign(d_k.x) != sign(delta_k.x))
//    {
//        d_k.x = -d_k.x;
//    }
//    if (sign(d_k.y) != sign(delta_k.y))
//    {
//        d_k.y = -d_k.y;
//    }
//
//    if (sign(d_k1.x) != sign(delta_k.x))
//    {
//        d_k1.x = -d_k1.x;
//    }
//    if (sign(d_k1.y) != sign(delta_k.y))
//    {
//        d_k1.y = -d_k1.y;
//    }
//
//    /*if ((delta_k.x) == 0 || (sign(d_k.x) != sign(delta_k.x) || sign(d_k1.x) != sign(delta_k.x)))
//   {
//       d_k.x = 0;
//       d_k1.x = 0;
//   }
//
//    if ((delta_k.y) == 0 || (sign(d_k.y) != sign(delta_k.y) || sign(d_k1.y) != sign(delta_k.y)))
//    {
//        d_k.y = 0;
//        d_k1.y = 0;
//    }*/
//
//    float2 a0 = f1;
//    float2 a1 = d_k;
//    float2 a2 = 3 * delta_k - 2 * d_k - d_k1;
//    float2 a3 = d_k + d_k1 - 2 * delta_k;
//
//    float2 result = a3 * t3 + a2 * t2 + a1 * t1 + a0;
//
//    if ((delta_k.x) != 0) {
//        float mnx = min(f2.x, f1.x);
//        float mxx = max(f1.x, f2.x);
//
//        result.x = max(result.x, mnx);
//        result.x = min(result.x, mxx);
//    }
//
//    if ((delta_k.y) != 0) {
//        float mny = min(f2.y, f1.y);
//        float mxy = max(f1.y, f2.y);
//
//        result.y = max(result.y, mny);
//        result.y = min(result.y, mxy);
//    }
//
//
//    return result;
//}
