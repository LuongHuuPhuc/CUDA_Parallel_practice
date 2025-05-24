
#include <stdio.h>

__global__ void addShared(int* out) {
    __shared__ int temp[256];
    int idx = threadIdx.x;
    temp[idx] = idx;
    __syncthreads();
    out[idx] = temp[idx] + 1;
}

int main() {
    const int ARRAY_SIZE = 5;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);

    int h_out[ARRAY_SIZE];
    int* d_out;
    cudaMalloc((void**)&d_out, ARRAY_BYTES);

    addShared<<<1, ARRAY_SIZE>>>(d_out);

    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%d ", h_out[i]);
    }
    printf("\n");

    cudaFree(d_out);
    return 0;
}
