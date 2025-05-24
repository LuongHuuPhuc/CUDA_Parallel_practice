#include <iostream>
#include <chrono>

#define N (100 * 1000 * 1000) //1e9

void vectorAddCPU(const float *A, const float *B, float *C, int n){
  for(int i = 0; i < n; i++){
    C[i] = A[i] + B[i];
  }
}

int main(void){
  float *A = new float[N];
  float *B = new float[N];
  float *C = new float[N];

  for(int i = 0; i < N; i++){
    A[i] = 1.0f;
    B[i] = 2.0f;
  }

  auto start = std::chrono::high_resolution_clock::now();
  vectorAddCPU(A, B, C, N);
  auto end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> duration = end - start;

  std::cout << "CPU time: " << duration.count() << " seconds \n";

  delete[] A;
  delete[] B;
  delete[] C;

  return 0;
}