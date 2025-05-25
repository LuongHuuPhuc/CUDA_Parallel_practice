# **Để phân tích hiệu suất của chương trình CUDA, sử dụng `NSIGHT COMPUTE` và `NSIGHT SYSTEMS`** #
### NSIGHT COMPUTE và NSIGHT SYSTEMS là gì ? ###
1. `NSIGHT COMPUTE`(`nsys`)
- Là công cụ giúp bạn phân tích hiệu suất toàn bộ pipeline chương trình CUDA, nó theo dõi: 
  * Thời gian thực thi của kernel
  * Hoạt động sao chép bộ nhớ giữa *host* và *device*
  * Sự đồng bộ giữa CPU và GPU 
  * Thời gian thực thi trên CPU
 
**👉 Lệnh sử dụng:** <br>
Tổng quan hiệu suất kernel:
```bash
nsys profile --stats=true ./your_program.exe
```
![image](https://github.com/user-attachments/assets/01e9ce81-db05-47e9-bff3-bb22f8adc79c)

2. `NSIGHT COMPUTE` (`ncu`)
- Là công cụ để phân tích chi tiết kernel CUDA. Nó cung cấp thông tin về: 
 * Truy cập bộ nhớ (memory accesses)
 * Occupancy (mức độ tận dụng tài nguyên GPU)
 * Cache miss, register usage và thời gian thực thi từng dòng lệnh.

**👉 Lệnh sử dụng:**
```bash
ncu ./your_program.exe 
```
Ngoài ra còn một số lệnh để lọc phần phân tích:
| Mục tiêu                 | Lệnh sử dụng               | 
|--------------------------|----------------------------|
| Đo hiệu suất truy cập bộ nhớ | `ncu --section MemoryWorkloadAnalysis  .\your_program.exe` |
| Kiểm tra occupancy kernel | `ncu --section SpeedOfLight .\your_program.exe` | 
> Lưu ý, lệnh này chỉ dùng được khi mở quyền Admin cho command prompt hay PowerShell
![image](https://github.com/user-attachments/assets/f2ea7d79-32f1-45b6-89fe-e95fcad501ff)

