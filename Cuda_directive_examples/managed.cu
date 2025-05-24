
#include <stdio.h>

__managed__ int data[5];

__global__ void init() {
    int idx = threadIdx.x;
    data[idx] = idx * 2;
}

int main() {
    init<<<1, 5>>>();
    cudaDeviceSynchronize();

    for (int i = 0; i < 5; i++) {
        printf("%d ", data[i]);
    }
    printf("\n");

    return 0;
}
