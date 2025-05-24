#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define N   1000 //Kich thuoc mang
/**
 * @note Chi thi __global__ duoc gan cho cac ham kernel, nghia la: 
 * \note - Ham duoc goi tu CPU nhung lai chay tren GPU
 * \note - Nen dung chi thi nay cho cac ham chinh khoi chay tren GPU (kernel)
 * \note - Khong phu hop cho cac ham tinh toan nho/modular
 * \note - Khong duoc phep tra ve gia tri
 */
__global__ void myKernel(int *arg){
  int idx =  threadIdx.x + blockIdx.x * blockDim.x;
  if(idx < N){
    arg[idx] += 1;
  }
}

int main(void){
  int count_elements = 0;
  int host_a[N]; //Mang tren CPU (host)
  int *device_a; //Con tro tren GPU (device)

  //Khoi tao mang host_a
  for(int i = 0; i < N; i++){
    host_a[i] = i;
  }

  //Cap phat bo nho tren GPU
  cudaMalloc((void**)&device_a, sizeof(int) * N);

  //Sao chep du lieu tu CPU sang GPU
  cudaMemcpy(device_a, host_a, sizeof(int) * N, cudaMemcpyHostToDevice);

  /**
   * @brief Goi kernel tren GPU voi n block, moi block m thread 
   * @note Muc tieu: Chia N phan tu thanh nhieu block, voi 1 thread dam nhiem 1 phan tu, sao cho:
   * \note - Tong so thread >= N
   * \note - Moi block co dung threadsPerBlock thread (ngoai tru block cuoi neu du)
   * Neu N la so khong chia het cho `threadsPerBlock` thi se xay ra truong hop bo sot nhung phan tu cuoi cung
   * => De giai quyet cho van de, thi su dung giai phap lam tron len (chia lay tran) de sinh ra thua threads, 
   * dam bao khong co phan tu nao bi bo sot
   */
  int threadsPerBlock = 9;    
  int numBlocks = (N + threadsPerBlock - 1) / threadsPerBlock; //Ceiling
  //Goi kernel tren CPU
  myKernel <<< numBlocks, threadsPerBlock >>> (device_a);

  //Dong bo hoa GPU 
  cudaDeviceSynchronize();

  //Sao chep du lieu tro ve CPU 
  cudaMemcpy(host_a, device_a, sizeof(int) * N, cudaMemcpyDeviceToHost);

  //In ra ket qua 
  printf("Ket qua sau khi cong 1 tren GPU: \n");
  for(int i = 0; i < N; i++){
    printf("%d ", host_a[i]);
    count_elements++;
    if(count_elements == 20){
      count_elements = 0;
      printf("\n");
    }
  }

  //Giai phong bo nho tren GPU
  cudaFree(device_a);

  return 0;
}