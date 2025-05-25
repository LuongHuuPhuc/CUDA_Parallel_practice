#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void add(int n, float *x, float *y){
  int index = blockDim.x * blockIdx.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for(int i = index; i < n; i += stride){
    y[i] = x[i] + y[i];
  }
}

int main(void){
  int N = 1 << 20;
  float *x, *y;

  //Allocate Unified Memory (Bo nho thong nhat) -- Bo nho co tren truy cap duoc ca tu CPU va GPU 
  cudaMallocManaged(&x, N * sizeof(float));
  cudaMallocManaged(&y, N * sizeof(float));

  //Khoi tao mang 
  for(int i = 0; i < N; i++){
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  //Chay kernel voi 1 trieu phan tu tren GPU 
  int threadsPerBlock = 256;
  int numBlocks = (N + threadsPerBlock - 1) / threadsPerBlock;
  add <<< numBlocks, threadsPerBlock >>> (N, x, y);

  //Doi cho GPU hoan thanh truoc khi access vao host (CPU)
  cudaDeviceSynchronize();

  //Check loi (Tat ca gia tri dung phai la 3.0f)
  float maxErr = 0.0f;
  for(int i = 0; i < N; i++){
    maxErr = fmax(maxErr, fabs(y[i] - 3.0f));
  }
  std::cout << "Max error: " << maxErr << std::endl;

  cudaFree(x);
  cudaFree(y);
  return 0;
}