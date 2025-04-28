# LẬP TRÌNH VÀ BIÊN DỊCH CHƯƠNG TRÌNH CUDA TRÊN WINDOWS #

## **Tại sao lại phải cl.exe biên dịch thay cho gcc/g++.exe ?** ##
***I. Sự khác nhau giữa `cl.exe` và `gcc/g++.exe`*** <br>
1. `cl.exe` - "C++ cho Windows chuẩn Microsoft"
   * Thuộc hãng: Microsoft
   * Nền tảng chính: Windows
   * Tiêu chuẩn hỗ trợ: C++ theo kiểu Microsoft (trình biên dịch của MCVS)
   * Cách biên dịch: `cl.exe` -> Dùng cú pháp riêng của nó
   * Chạy trên: Windows (chặt với Windows SDK)
   * Tính năng nổi bật: Tích hợp cực sâu vào Windows/ COM/ DirectX
   * Hỗ trợ CUDA: NVIDIA CUDA trên Windows yêu cầu `cl.exe`
   * Tôi ưu hóa cho Windows.exe
   * Kết quả build: `.exe`, `.dll` theo chuẩn Windows
3. `gcc/g++.exe` - "C++ cho mọi nền tảng chuẩn GNU"
   * Thuộc hãng: GNU (cộng đồng mã nguồn mở)
   * Nền tảng chính: Linux/masOS, Windows(qua MSYS/MinGW)
   * Tiêu chuẩn hỗ trợ: C++ theo chuẩn ISO gốc
   * Cách bien dịch: `gcc`, `g++` -> cú pháp GNU chuẩn
   * Chạy trên: Cross-platform (đa nền tảng)
   * Tính năng nổi bật: Rất phổ biến cho Open-source, Linux app
   * Hỗ trợ CUDA: Không hỗ trợ tốt trên Windows 

   
