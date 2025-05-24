#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define N (500 * 1000 * 1000) //1e9

//Thuv hien tren Kernel
__global__ void vectorAddGPU(const float *A, const float *B, float *C, int n){
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if(i < n){
    C[i] = A[i] + B[i];
  }
}

int main(void){
  float *A, *B, *C;
  float *d_A, *d_B, *d_C;
  
  A = new float[N]; //Mang dong A chua N phan tu 
  B = new float[N];
  C = new float[N];

  for(int i = 0; i < N; i++){
    A[i] = 1.0f;
    B[i] = 2.0f;
  }

  cudaMalloc(&d_A, N * sizeof(float));
  cudaMalloc(&d_B, N * sizeof(float));
  cudaMalloc(&d_C, N * sizeof(float));

  cudaMemcpy(d_A, A, sizeof(float) * N, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, sizeof(float) * N, cudaMemcpyHostToDevice);

  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  //Call ham kernel de thuc thi tren GPU
  vectorAddGPU<<<numBlocks, blockSize>>>(d_A, d_B, d_C, N);
  cudaEventRecord(stop);
  cudaMemcpy(d_C, C, sizeof(float), cudaMemcpyHostToDevice);

  cudaEventSynchronize(stop);
  float milliseconds = 0.0f;
  cudaEventElapsedTime(&milliseconds, start, stop);

  std::cout << "GPU time: " << milliseconds / 1000.0f << " seconds\n";

  delete[] A;
  delete[] B;
  delete[] C;

  cudaFree(d_A);
  cudaFree(d_B);  
  cudaFree(d_C);

  return 0;
}