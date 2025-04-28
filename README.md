# LẬP TRÌNH VÀ BIÊN DỊCH CHƯƠNG TRÌNH CUDA TRÊN WINDOWS #

## **Tại sao lại phải cl.exe biên dịch thay cho gcc/g++.exe ?** ##
***I. CUDA Toolkits là gì ?*** <br>
***II. Sự khác nhau giữa `cl.exe` và `gcc/g++.exe`*** <br>
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
🔥Tuy nhiên nếu muốn dùng `gcc/g++.exe` cho nvcc thì chỉ có thể dùng bộ của *MinGW-w64* - bộ host compiler chuẩn của Windows (native Windows) <br>
⚠️ Trình biên dịch `gcc/g++.exe` của *MSYS2* lại không tương thích với chuẩn Windows mà CUDA Toolkits yêu cầu. Vì đây mặc định là kiểu dùng cho Linux/Unix (POSIX). Vì thế nên nvcc từ chối, không compile được 
***III. Cách biên dịch và chạy CUDA trên Visual Studio Code sử dụng `cl.exe`*** <br.

   
