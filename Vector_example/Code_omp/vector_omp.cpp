#include <iostream>
#include <omp.h>
#include <time.h>
#include <iomanip> //in chu so ra sau dau phay

#define N (100 * 1000 * 1000)

#ifdef __cplusplus
extern "C"{
#endif

int main(void){
  float *A = new float[N];
  float *B = new float[N];
  float *C = new float[N];

  //Khoi tao du lieu 
  for(int i = 0; i < N; i++){
    A[i] = 1.0f;
    B[i] = 2.0f;
  }

  double start_time = omp_get_wtime();

  #pragma omp parallel for 
  for(int i = 0; i < N; i++){
    C[i] = A[i] + B[i];
  }

  double end_time = omp_get_wtime();
  
  std::cout << std::fixed << std::setprecision(6); //In ra 6 chu so sau dau phay
  std::cout << "Elapsed time: " << end_time - start_time << " seconds" << std::endl;
  
  //In ra mot vai so de kiem tra
  for(int i = 0; i < 5; i++){
    std::cout << "C[" << i << "]: " << C[i] << std::endl;
  }
}

#ifdef __cplusplus
}
#endif 