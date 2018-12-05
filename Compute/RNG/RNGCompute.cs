using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RNGCompute : MonoBehaviour
{
    public Material computeMaterial;

    private ComputeShader fillWithRedShader;
    private int kernelIndex;

    void Start()
    {
        fillWithRedShader = (ComputeShader)Resources.Load(MyStrings.WavePractice);
        kernelIndex = fillWithRedShader.FindKernel(MyStrings.FillWithRandom);

        RenderTexture tempTex = new RenderTexture(256, 256, 0);
        tempTex.enableRandomWrite = true;
        tempTex.Create();

        fillWithRedShader.SetTexture(kernelIndex, MyStrings.outputTexture, tempTex);
        fillWithRedShader.Dispatch(kernelIndex, 256, 256, 1);

        computeMaterial.mainTexture = tempTex;
    }
}
