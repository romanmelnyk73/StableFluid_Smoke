// StableFluid: Smoke
using UnityEngine;


public class Smoke : MonoBehaviour
{
    public int resolution = 512;
    public int iterations = 20;
    public float viscosity = 1e-6f;
    public float force = 300;
    public float velocityDissipation = 1.0f;
    public float density = 1.0f;
    public float densityDissipation = 1.0f;
    public float vorticity = 10;
    public float temperature = 10;
    public float temperatureDissipation = 1.0f;
    public float buoyancy = 0.01f;
    public float gravity = 0.01f;
    public float exponent = 200;
    public ComputeShader compute;
    public Shader shader;
    //public Texture2D initial;
    public Vector2 forceOrigin;
    public Vector2 forceVector;
    
    Material material;

    int kernelAdvect;
    int kernelComputeVorticity;
    int kernelVorticityConfinement;
    int kernelApplyBuoyancy;
    int kernelForce;
    int kernelProjectSetup;
    int kernelProject;
    int kernelDiffuse1;
    int kernelDiffuse2;
    int kernelAdvectDensity;
    int kernelDensitySource;
    int kernelAdvectTemperature;
    int kernelTemperatureSource;

    int threadCountX { get { return (resolution + 7) / 8; } }
    int threadCountY { get { return (resolution + 7) / 8; } }

    int resolutionX { get { return threadCountX * 8; } }
    int resolutionY { get { return threadCountY * 8; } }

    
    // Vector field buffers
    RenderTexture texturV1;
    RenderTexture texturV2;
    RenderTexture texturV3;
    RenderTexture texturP1;
    RenderTexture texturP2;
    RenderTexture texturD1;
    RenderTexture texturD2;
    RenderTexture texturT1;
    RenderTexture texturT2;
    RenderTexture texturVC1;
    RenderTexture texturVC2;


    RenderTexture CreateRenderTexture(int componentCount, int width = 0, int height = 0)
    {
        
        var format = RenderTextureFormat.ARGBHalf;
        if (componentCount == 1) format = RenderTextureFormat.RHalf;
        if (componentCount == 2) format = RenderTextureFormat.RGHalf;

        if (width == 0) width = resolutionX;
        if (height == 0) height = resolutionY;

        var rt = new RenderTexture(width, height, 0, format);
        rt.enableRandomWrite = true;
        rt.Create();
        return rt;
    }

    void Start()
    {
     
        //material = new Material(shader);

        InitBuffers();
        InitShader();
    }

    void InitBuffers()
    {
        texturV1 = CreateRenderTexture(2);
        texturV2 = CreateRenderTexture(2);
        texturV3 = CreateRenderTexture(2);
        texturP1 = CreateRenderTexture(1);
        texturP2 = CreateRenderTexture(1);
        texturD1 = CreateRenderTexture(4);
        texturD2 = CreateRenderTexture(4);
        texturT1 = CreateRenderTexture(1);
        texturT2 = CreateRenderTexture(1);
        texturVC1 = CreateRenderTexture(1);
        texturVC2 = CreateRenderTexture(1);

    }

    void InitShader()
    {
        kernelAdvect = compute.FindKernel("Advect");
        kernelComputeVorticity = compute.FindKernel("ComputeVorticity");
        kernelVorticityConfinement = compute.FindKernel("VorticityConfinement");
        kernelApplyBuoyancy = compute.FindKernel("ApplyBuoyancy");
        kernelForce = compute.FindKernel("Force");
        kernelProjectSetup = compute.FindKernel("ProjectSetup");
        kernelProject = compute.FindKernel("Project");
        kernelDiffuse1 = compute.FindKernel("Diffuse1");
        kernelDiffuse2 = compute.FindKernel("Diffuse2");
        kernelAdvectDensity = compute.FindKernel("AdvectDensity");
        kernelDensitySource = compute.FindKernel("DensitySource");
        kernelAdvectTemperature = compute.FindKernel("AdvectTemperature");
        kernelTemperatureSource = compute.FindKernel("TemperatureSource");

        //Advect Velocity
        compute.SetTexture(kernelAdvect, "U_in", texturV1);
        compute.SetTexture(kernelAdvect, "W_out", texturV2);

        //Diffuse Velocity
        compute.SetTexture(kernelDiffuse2, "B2_in", texturV1);

        //Vorticity Computation
        compute.SetTexture(kernelComputeVorticity, "VC_out", texturVC2);
        compute.SetTexture(kernelComputeVorticity, "U_in", texturV1);

        // Vorticity Confinement
        compute.SetTexture(kernelVorticityConfinement, "VC_in", texturVC1);
        compute.SetTexture(kernelVorticityConfinement, "W_in", texturV2);
        compute.SetTexture(kernelVorticityConfinement, "W_out", texturV3);

        //Apply Buoyancy
        compute.SetTexture(kernelApplyBuoyancy, "W_in", texturV3);
        compute.SetTexture(kernelApplyBuoyancy, "T_in", texturT1);
        compute.SetTexture(kernelApplyBuoyancy, "D_in", texturD1);
        compute.SetTexture(kernelApplyBuoyancy, "W_out", texturV2);

        //Add external Force(gauss impulse)
        compute.SetTexture(kernelForce, "W_in", texturV2);
        compute.SetTexture(kernelForce, "W_out", texturV3);

        //Projection Setup
        compute.SetTexture(kernelProjectSetup, "W_in", texturV3);
        compute.SetTexture(kernelProjectSetup, "DivW_out", texturV2);
        compute.SetTexture(kernelProjectSetup, "P_out", texturP1);

        //diffuse P
        compute.SetTexture(kernelDiffuse1, "B1_in", texturV2);

        //Projection
        compute.SetTexture(kernelProject, "W_in", texturV3);
        compute.SetTexture(kernelProject, "P_in", texturP1);
        compute.SetTexture(kernelProject, "U_out", texturV1);

        //Add Density source
        compute.SetTexture(kernelDensitySource, "D_in", texturD1);
        compute.SetTexture(kernelDensitySource, "D_out", texturD2);

        //Advect Density
        compute.SetTexture(kernelAdvectDensity, "D_in", texturD1);
        compute.SetTexture(kernelAdvectDensity, "U_in", texturV1);
        compute.SetTexture(kernelAdvectDensity, "D_out", texturD2);

        //Add Temperature source
        compute.SetTexture(kernelTemperatureSource, "T_in", texturT1);
        compute.SetTexture(kernelTemperatureSource, "T_out", texturT2);

        //Advect Temperature
        compute.SetTexture(kernelAdvectTemperature, "T_in", texturT1);
        compute.SetTexture(kernelAdvectTemperature, "U_in", texturV1);
        compute.SetTexture(kernelAdvectTemperature, "T_out", texturT2);

        compute.SetFloat("ForceExponent", exponent);
        compute.SetFloat("velocityDissipation", velocityDissipation);
        compute.SetFloat("densityAmount", density);
        compute.SetFloat("densityDissipation", densityDissipation);
        compute.SetFloat("temperatureAmount", temperature);
        compute.SetFloat("temperatureDissipation", temperatureDissipation);
        compute.SetFloat("Epsilon", vorticity);
        compute.SetFloat("Buoyancy", buoyancy);
        compute.SetFloat("Weight", gravity);



        // Input point
        Vector2 input = new Vector2( forceOrigin.x , forceOrigin.y);

        compute.SetVector("ForceOrigin", input);

        Renderer rend = GetComponent<Renderer>();
        Material mat = rend.material;
        mat.SetTexture("_MainTex", texturD1);

    }

    void Update()
    {
        var dt = Time.deltaTime;
        //float dt = 0.1f;
        var dx = 1.0f;
        // / resolutionY;

        // Common variables
        compute.SetFloat("DeltaTime", dt);

        // Advection
        compute.Dispatch(kernelAdvect, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturV2, texturV1);

        //Vorticity Computation
        compute.Dispatch(kernelComputeVorticity, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturVC2, texturVC1);


        // Diffuse setup
        var difalpha = dx * dx / (viscosity * dt);
        compute.SetFloat("Alpha", difalpha);
        compute.SetFloat("Beta", 4 + difalpha);
        

        // Jacobi iteration
        for (var i = 0; i < iterations; i++)
        {
            compute.SetTexture(kernelDiffuse2, "X2_in", texturV2);
            compute.SetTexture(kernelDiffuse2, "X2_out", texturV3);
            compute.Dispatch(kernelDiffuse2, threadCountX, threadCountY, 1);

            compute.SetTexture(kernelDiffuse2, "X2_in", texturV3);
            compute.SetTexture(kernelDiffuse2, "X2_out", texturV2);
            compute.Dispatch(kernelDiffuse2, threadCountX, threadCountY, 1);
        }

        //Add force vector
        Vector2 fV = forceVector;
        compute.SetVector("ForceVector", fV);

        // Add Vorticity Confinement
        compute.Dispatch(kernelVorticityConfinement, threadCountX, threadCountY, 1);

        // Add Buoyancy Force
        compute.Dispatch(kernelApplyBuoyancy, threadCountX, threadCountY, 1);

        // Add external force
        compute.Dispatch(kernelForce, threadCountX, threadCountY, 1);

        // Projection setup
        compute.Dispatch(kernelProjectSetup, threadCountX, threadCountY, 1);

        // Jacobi iteration
        compute.SetFloat("Alpha", -dx * dx);
        compute.SetFloat("Beta", 4);

        for (var i = 0; i < iterations; i++)
        {
            compute.SetTexture(kernelDiffuse1, "X1_in", texturP1);
            compute.SetTexture(kernelDiffuse1, "X1_out", texturP2);
            compute.Dispatch(kernelDiffuse1, threadCountX, threadCountY, 1);
            //Graphics.CopyTexture(texturP2, texturP1);

            compute.SetTexture(kernelDiffuse1, "X1_in", texturP2);
            compute.SetTexture(kernelDiffuse1, "X1_out", texturP1);
            compute.Dispatch(kernelDiffuse1, threadCountX, threadCountY, 1);
        }

        // Projection finish
        compute.Dispatch(kernelProject, threadCountX, threadCountY, 1);

        //Add Temperature Source
        compute.Dispatch(kernelTemperatureSource, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturT2, texturT1);

        //Advect Temperature
        compute.Dispatch(kernelAdvectTemperature, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturT2, texturT1);

        //Add Density Source
        compute.Dispatch(kernelDensitySource, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturD2, texturD1);

        //Advect Density
        compute.Dispatch(kernelAdvectDensity, threadCountX, threadCountY, 1);
        Graphics.CopyTexture(texturD2, texturD1);
        //Graphics.Blit(texturD2, texturD1);

    }
    void OnDestroy()
    {
        Destroy(texturV1);
        Destroy(texturV2);
        Destroy(texturV3);
        Destroy(texturP1);
        Destroy(texturP2);
        Destroy(texturD1);
        Destroy(texturD2);
        Destroy(texturT1);
        Destroy(texturT2);
        Destroy(texturVC1);
        Destroy(texturVC2);

    }
}
