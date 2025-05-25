# **Để phân tích hiệu suất của chương trình CUDA, sử dụng `NSIGHT COMPUTE` và `NSIGHT SYSTEMS`** #
### NSIGHT COMPUTE và NSIGHT SYSTEMS là gì ? ###
1. `NSIGHT COMPUTE`(`nsys)
- Là công cụ giúp bạn phân tích hiệu suất toàn bộ pipeline chương trình CUDA, nó theo dõi: 
  * Thời gian thực thi của kernel
  * Hoạt động sao chép bộ nhớ giữa *host* và *device*
  * Sự đồng bộ giữa CPU và GPU 
  * Thời gian thực thi trên CPU <br>
**👉 Lệnh sử dụng:**
```bash
nsys profile --stats=true ./your_program.exe
```
2. `NSIGHT COMPUTE` (`ncu`)
- Là công cụ để phân tích chi tiết kernel CUDA. Nó cung cấp thông tin về: 
 * Truy cập bộ nhớ (memory accesses)
 * Occupancy (mức độ tận dụng tài nguyên GPU)
 * Cache miss, register usage và thời gian thực thi từng dòng lệnh. 
**👉 Lệnh sử dụng:**
```bash
ncu ./your_program.exe 
```
> Lưu ý, lệnh này chỉ dùng được khi mở quyền Admin cho command prompt hay PowerShell

<p align="center">
<img src="C:\Users\ADMIN\OneDrive\Hình ảnh\Ảnh chụp màn hình\Ảnh chụp màn hình 2025-05-25 204442.png" alt="Efficiency" width="500">
</p>