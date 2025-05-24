#include <stdio.h>
#include <cuda_runtime.h>

//__shared__: bo nho chia se giua cac thread trong 1 block

__global__ void addShared(int *out, int *in1, int *in2){
  __shared__ int temp1[256], temp2[256];

  int t_id = threadIdx.x; //So luong thread se duoc quyet dinh boi luc goi kernel <<< >>>

  temp1[t_id] = in1[t_id];
  temp2[t_id] = in2[t_id];

}