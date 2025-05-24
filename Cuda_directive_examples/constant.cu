
#include <stdio.h>

__constant__ int factor;

__global__ void multiplyConstant(int* out, int* in) {
    int idx = threadIdx.x;
    out[idx] = in[idx] * factor;
}

int main() {
    const int ARRAY_SIZE = 5;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);

    int h_in[ARRAY_SIZE] = {1, 2, 3, 4, 5};
    int h_out[ARRAY_SIZE];
    int h_factor = 3;

    int *d_in, *d_out;
    cudaMalloc((void**)&d_in, ARRAY_BYTES);
    cudaMalloc((void**)&d_out, ARRAY_BYTES);

    cudaMemcpyToSymbol(factor, &h_factor, sizeof(int));
    cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

    multiplyConstant<<<1, ARRAY_SIZE>>>(d_out, d_in);

    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%d ", h_out[i]);
    }
    printf("\n");

    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
