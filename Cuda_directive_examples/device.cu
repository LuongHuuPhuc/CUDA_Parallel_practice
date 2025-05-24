
#include <stdio.h>

__device__ float cube(float x) {
    return x * x * x;
}

__global__ void applyCube(float* d_out, float* d_in) {
    int idx = threadIdx.x;
    d_out[idx] = cube(d_in[idx]);
}

int main() {
    const int ARRAY_SIZE = 5;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

    float h_in[ARRAY_SIZE] = {1, 2, 3, 4, 5};
    float h_out[ARRAY_SIZE];

    float *d_in, *d_out;
    cudaMalloc((void**)&d_in, ARRAY_BYTES);
    cudaMalloc((void**)&d_out, ARRAY_BYTES);

    cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

    applyCube<<<1, ARRAY_SIZE>>>(d_out, d_in);

    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%f ", h_out[i]);
    }
    printf("\n");

    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
