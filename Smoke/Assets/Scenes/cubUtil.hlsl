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
    //clamp(t, 0.5, (dim - 0.5));
    clamp(t, 1.1, (float2(dim)-2.1));

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
    //clamp(t, 0.5, (dim - 0.5));
    clamp(t, 1.1, (float2(dim) - 2.1));

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
    //pos = max(0.5, t);
    //pos = min(pos, ((float2)dim - 0.5));
    //clamp(t, 1.5, (dim - 1.5));

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
    //pos = max(0.5, t);
    //pos = min(pos, ((float2)dim - 0.5));
    //clamp(t, 1.5, (dim - 1.5));

    int2 k = (int2) t;
    float2 f = t - k;

    int2 p1 = int2(k + 1);
    p1 = min(dim - 1, p1);
    
    float2 x0 = textur[k] * (1.0 - f.x) + textur[int2(p1.x, k.y)] * f.x;
    float2 y0 = textur[int2(k.x, p1.y)] * (1.0 - f.x) + textur[p1] * f.x;

    return x0 * (1.0 - f.y) + y0 * f.y;
}

void f2neighbors(Texture2D<float2> textur_in, uint2 ind, uint2 dim, out float2 R, out float2 L, out float2 T, out float2 B)
{
    R = textur_in[max(0, ind - int2(1, 0))];
    L = textur_in[min(dim - 1, ind + int2(1, 0))];

    B = textur_in[max(0, ind - int2(0, 1))];
    T = textur_in[min(dim - 1, ind + int2(0, 1))];
}


void f1bnd(RWTexture2D<float> txtur_out, uint2 ind, float scal, uint2 dim)
{
    if (ind.x == 1) txtur_out[int2(0, ind.y)] = scal;
    if (ind.y == 1) txtur_out[int2(ind.x, 0)] = scal;
    if (ind.x == dim.x - 2) txtur_out[int2(dim.x - 1, ind.y)] = scal;
    if (ind.y == dim.y - 2) txtur_out[int2(ind.x, dim.y - 1)] = scal;

    //return txtur_out;
}

void f2bnd(RWTexture2D<float2> txtur_out, uint2 ind, float2 vec, uint2 dim)
{
    if (ind.x == 1) txtur_out[int2(0, ind.y)] = vec;
    if (ind.y == 1) txtur_out[int2(ind.x, 0)] = vec;
    if (ind.x == dim.x - 2) txtur_out[int2(dim.x - 1, ind.y)] = vec;
    if (ind.y == dim.y - 2) txtur_out[int2(ind.x, dim.y - 1)] = vec;
}
