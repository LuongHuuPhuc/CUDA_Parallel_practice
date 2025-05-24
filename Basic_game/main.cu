#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

/**
 * \note The nen can ca bien dich cho C++ cho CPU
 * \note nvcc (NVIDIA CUDA Compiler driver) khong phai la compiler C++ thuan
 * No chi la trinh dieu phoi (driver) de giup phan tach phan code GPU va code CPU, 
 * chuyen cac ham __global__, __device__,... thanh PTX (Parallel Thread Execution) 
 * hoac SASS (native Assembly cho GPU)
 * \note Phan CPU se duoc compile bang cl.exe/gcc (Vi co ban chuong trinh van nam tren CPU)
 * \note Sau do link 2 phan lai voi nhau
 */

//__global__ = chay tren GPU, goi tu CPU (host)
__global__ void hello_from_gpu(void){
  printf("Hello from GPU, thread: %d\n", threadIdx.x);
}

int main(void){
  hello_from_gpu<<<1, 10>>>(); //1 blocks, 10 threads

  cudaDeviceSynchronize();

  std::cout << "Hello from CPU !" << std::endl;
  return 0;
}