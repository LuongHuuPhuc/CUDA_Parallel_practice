# LẬP TRÌNH VÀ BIÊN DỊCH CHƯƠNG TRÌNH CUDA TRÊN WINDOWS #
## **CUDA Toolkits là gì ?** ##
![image](https://github.com/user-attachments/assets/a3e55fc5-013e-414b-bc90-da4bb404cacf)

## **Tại sao lại phải cl.exe biên dịch thay cho gcc/g++.exe ?** ##
### ***🤖 Sự khác nhau giữa `cl.exe` và `gcc/g++.exe`*** ### <br>
**1. `cl.exe` - "C++ cho Windows chuẩn Microsoft"**
   * Thuộc hãng: Microsoft
   * Nền tảng chính: Windows
   * Tiêu chuẩn hỗ trợ: C++ theo kiểu Microsoft (trình biên dịch của MCVS)
   * Cách biên dịch: `cl.exe` -> Dùng cú pháp riêng của nó
   * Chạy trên: Windows (chặt với Windows SDK)
   * Tính năng nổi bật: Tích hợp cực sâu vào Windows/ COM/ DirectX
   * Hỗ trợ CUDA: NVIDIA CUDA trên Windows yêu cầu `cl.exe`
   * Tôi ưu hóa cho Windows.exe
   * Kết quả build: `.exe`, `.dll` theo chuẩn Windows <br>
***
**2. `gcc/g++.exe` - "C++ cho mọi nền tảng chuẩn GNU"**
   * Thuộc hãng: GNU (cộng đồng mã nguồn mở)
   * Nền tảng chính: Linux/masOS, Windows(qua MSYS/MinGW)
   * Tiêu chuẩn hỗ trợ: C++ theo chuẩn ISO gốc
   * Cách bien dịch: `gcc`, `g++` -> cú pháp GNU chuẩn
   * Chạy trên: Cross-platform (đa nền tảng)
   * Tính năng nổi bật: Rất phổ biến cho Open-source, Linux app
   * Hỗ trợ CUDA: Không hỗ trợ tốt trên Windows <br>
***
🔥Tuy nhiên nếu muốn dùng `gcc/g++.exe` cho nvcc thì chỉ có thể dùng bộ của *MinGW-w64*, bộ host compiler chuẩn của Windows (native Windows) <br>
⚠️ Trình biên dịch `gcc/g++.exe` của *MSYS2* lại không tương thích với chuẩn Windows mà CUDA Toolkits yêu cầu. Vì đây mặc định là kiểu dùng cho Linux/Unix (POSIX). Vì thế nên nvcc từ chối, không compile được <br>
***
## **Cách biên dịch và chạy CUDA trên Visual Studio Code sử dụng `cl.exe`** ##

### **🌐 Hiểu về biến chỉ số toàn cục `Global Index` trong lập trình CUDA** ###
Trong lập trình CUDA , `global index` (chỉ số toàn cục) là một biến vô cùng quan trọng, giúp xác định mỗi thread sẽ xử lý phần tử dữ liệu cụ thể nào trong bộ nhớ. CUDA chia công việc thành các `block`, mỗi `block` chứa nhiều `thread`. Để xử lý dữ liệu đúng cách, chúng ta cần biết chính xác vị trí toàn cục của mỗi `thread` trong toàn bộ `grid`. `Global index` giúp ánh xạ mỗi thread đến đúng phần tử trong mảng. 
***
#### **🔍 Cách tính chỉ số toàn cục** ####
Trong CUDA 1D (1 chiều):
```cpp
int idx = blockIdx.x * blockDim.x + threadIdx.x;
```
* `threadIdx.x`: chỉ số thread trong block (cục bộ)
* `blockDim.x`: số thread trong mỗi block
* `blockIdx.x`: chỉ số của block trong mỗi grid <br>
Giá trị của `idx` chính là chỉ số tòan cục - vị trí mà thread hiện tại nên xử lý trong mảng dữ liệu.
***
#### **📌 Vì sao cần tính chỉ số toàn cục?** ####
1. Phân chia công việc: Mỗi thread xử lý đúng phần tử dữ liệu của nó
2. Không trùng lặp: Tránh ghi đè, tránh nhiều thread xử lý cùng 1 phần tử
3. Tăng tốc độ xử lý: Hàng nghìn thread xử lý song song nhiều phần tử
4. Tránh lỗi bộ nhớ: Giới hạn thread không truy cập ngoài vùng dữ liệu (`if(idx < N)`)

