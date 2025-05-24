#include <stdio.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define ELEMENTS  1000
#define THREADS_PER_BLOCK  8

cudaEvent_t start_time = nullptr;
cudaEvent_t end_time = nullptr;
float elapsed_time = 0.0f;

// 1. __constant__ memmory: bo nho hang so chi doc, danh cho moi thread (cap phat boi CPU)
__constant__ int constMultiplier; //uninitialized of Data (BSS)

// 2. __device__: chi thi cho biet ham nay chay tren GPU va chi GPU goi duoc (ham con GPU)
__device__ int square(int x){
  return x * x;
}

//Cac ham nay mac dinh chay o CPU 
__host__ void startTimer(void){
  cudaEventCreate(&start_time);
  cudaEventCreate(&end_time);
  cudaEventRecord(start_time, 0);
}

__host__ float elapsedTimer(void){
  cudaEventRecord(end_time, 0);
  cudaEventSynchronize(end_time); //Dam bao kernel da chay xong

  cudaEventElapsedTime(&elapsed_time, start_time, end_time);
  cudaEventDestroy(start_time);
  cudaEventDestroy(end_time);

  return elapsed_time;
}

// 3. __global__: Ham goi tu CPU nhung thuc thi tren GPU 
__global__ void processArray(int *arr){
  //4. __shared__ memory: Bo nho chia se giua cac thread trong cung 1 block
  __shared__ int temp[THREADS_PER_BLOCK];

  /**
   * @brief Tinh chi so toan cuc (global index) cua thread trong toan bo luoi (grid)
   * @param threadIdx - Chi so cua thread trong block (vd: tu 0 den 255 neu co 256 thread trong block)
   * @param blockIdx - Chi so cua block trong grid (vd: tu 0 den 3 neu co 4 blocks trong 1 grid)
   * @param blockDim - So thread trong moi block
   */
  //Idx: vi tri thread trong toan bo chuong trinh 
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

  if(idx < ELEMENTS){
    int val = arr[idx];

    //Goi ham device va nhan voi hang so constant 
    temp[threadIdx.x] = square(val) * constMultiplier; //Gan cho moi thread trong block 

    //Dong bo cac thread trong block truoc khi gui ket qua ve 
    __syncthreads();

    arr[idx] = temp[threadIdx.x];
  }
}

int main(void){
  int count_elements = 0;
  int host_arr[ELEMENTS];
  int *device_arr;

  //Khoi tao mang 
  for(int i = 0; i < ELEMENTS; i++){
    host_arr[i] = i;
  }

  //Cap phat bo nho tren GPU 
  cudaMalloc(&device_arr, sizeof(int) * ELEMENTS);
  cudaMemcpy(device_arr, host_arr, sizeof(int) * ELEMENTS, cudaMemcpyHostToDevice);

  //Sao chep hang so vao __constant__ memory
  int multiplier = 2;
  cudaMemcpyToSymbol(constMultiplier, &multiplier, sizeof(int));

  //Tinh so block va goi kernel 
  int numBlocks = (ELEMENTS + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;

  startTimer();
  processArray <<< numBlocks, THREADS_PER_BLOCK >>>(device_arr);
  elapsedTimer();

  //Sao chep ket qua ve lai CPU 
  cudaMemcpy(host_arr, device_arr, sizeof(int) * ELEMENTS, cudaMemcpyDeviceToHost);

   printf("Ket qua sau khi thuc thi tren GPU: \n");
  for(int i = 0; i < ELEMENTS; i++){
    printf("%d ", host_arr[i]);
    count_elements++;
    if(count_elements == 20){
      count_elements = 0;
      printf("\n");
    }
  }
  printf("\nThoi gian thuc thi tren kernel: %.6fms", elapsed_time);
  cudaFree(device_arr);
  return 0;
}