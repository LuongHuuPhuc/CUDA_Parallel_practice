@echo off
::vcvars64.bat la script khoi tao moi truong de co the dung trinh bien dich cl.exe
::Neu dung VS Developer Command Prompt -> moi truong da thiet lap san
::Con terminal nhu Powershell, cmd, VsCode (terminal) thi can goi vcvar64.bat de tranh loi 
call "D:/VisualStudio/Product/VC/Auxiliary/Build/vcvars64.bat" 

:: Duong dan toi trinh bien dich MSVC (cl.exe)
set cl_compiler_path="D:/VisualStudio/Product/VC/Tools/MSVC/14.43.34808/bin/Hostx64/x64/cl.exe"

for %%F in (%2) do (
  if not exist "%%~dpF" mkdir "%%~dpF"
)

@REM %1 la file.cu, %2 la file.exe 
@REM nvcc can moi truong cua cl.exe de bien dich CUDA code
echo [INFO] Compiling from %1 to %2 ...
nvcc -ccbin %cl_compiler_path% %1 -o %2

:: Kiem tra loi sau khi bien dich
if %errorlevel% neq 0 (
  echo [ERROR] Fail to compiler !
  exit /b %errorlevel%  
) else (
  echo [SUCCESS] Complier successfully: %2
)
