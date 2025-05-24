#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define THREADS_PER_BLOCK 1
#define NUMBLOCKS 1

//Ham chay duoc ca tren GPU va CPU
__host__ __device__ int add(int a, int b){
  return a + b;
}

__global__ void addKernel(int *device_result, int a, int b){
  *device_result = add(a, b); //Goi tren GPU
}

int main(void){
  int a = 10, b = 20;

  int cpu_result = add(a, b); //Goi tren CPU
  printf("Result call on CPU: %d\n", cpu_result);

  //Neu khai bao la int device_result thi day chi la bien thuong, neu ham can truyen con tro vao thi phai lay dia chi cua bien do: &device_result
  int *device_result; //*device_result (dereference pointer): Gia tri cua con tro tai dia chi do
  int host_result;
  cudaMalloc((void**)&device_result, sizeof(int));
  addKernel <<< NUMBLOCKS, THREADS_PER_BLOCK >>> (device_result, a, b); //Truyen vao con tro device_result
  cudaMemcpy(&host_result, device_result, sizeof(int), cudaMemcpyDeviceToHost);
  printf("Result call on GPU: %d\n", host_result);

  cudaFree(device_result);
  return 0;
}