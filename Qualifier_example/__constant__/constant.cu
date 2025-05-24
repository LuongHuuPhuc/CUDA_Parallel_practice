#include <stdio.h>
#include <cuda_runtime.h>

#define N  18

__constant__ int factor; //Bien constant tren device

//Kernel nhan moi phan voi constant 
__global__ void multiplyConstant(int *out, int *in){
  int idx = threadIdx.x;
  if(idx < N){
    out[idx] = in[idx] * factor;
  }
}

int main(void){
  int h_in[N], h_out[N];
  int *d_in, *d_out;
  int h_factor = 5;
  cudaEvent_t start_time = nullptr, end_time = nullptr; 
  float elapsed_time = 0.0f;

  //Khoi tao du lieu dau vao
  for(int i = 0; i < N; i++){
    h_in[i] =  i + 1;
  }
  
  //Cap phat bo nho tren device
  cudaMalloc((void**)&d_in, sizeof(int) * N);
  cudaMalloc((void**)&d_out, sizeof(int) * N);

  //Sao chep du lieu tu host sang device 
  cudaMemcpy(d_in, h_in, sizeof(int) * N, cudaMemcpyHostToDevice);
  cudaMemcpyToSymbol(factor, &h_factor, sizeof(int)); //Gan gia tri cho bien constant

  cudaEventCreate(&start_time);
  cudaEventCreate(&end_time);
  cudaEventRecord(start_time, 0);

  //Goi kernel    
  multiplyConstant <<< 1, N >>> (d_out, d_in);
  
  cudaEventRecord(end_time, 0);
  cudaEventSynchronize(end_time);
  cudaEventElapsedTime(&elapsed_time, start_time, end_time);
  cudaEventDestroy(start_time);
  cudaEventDestroy(end_time);

  //Sao chep ket qua ve host 
  cudaMemcpy(h_out, d_out, sizeof(int) * N, cudaMemcpyDeviceToHost);

  printf("Ket qua nhan voi h_factor = %d:\n", h_factor);
  for(int i = 0; i < N; i++){
    printf("%d * %d = %d\n", h_in[i], h_factor, h_out[i]);
  }
  printf("Thoi gian thuc thi tren Kernel: %.10f\n", elapsed_time);

  cudaFree(d_in);
  cudaFree(d_out);
  return 0;
}
