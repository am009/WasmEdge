# Remove-Item -LiteralPath "build" -Force -Recurse
$vsPath = (&"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath)
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64 -winsdk=10.0.19041.0 -vcvars_ver=14.34.31933"
# -vcvars_ver=14.34.31933
$llvm_dir = "E:\\OSPP\\LLVM-13.0.1-win64\\lib\\cmake\\llvm"
# $Env:CC = "cl.exe"
# $Env:CXX = "cl"
$Env:VSLANG = "1033"
#  -DWASMEDGE_BUILD_TESTS=ON
cmake -Bbuild -GNinja -DCMAKE_SYSTEM_VERSION="10.0.19041.0" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL -DWASMEDGE_BUILD_TESTS=ON "-DLLVM_DIR=$llvm_dir" -DWASMEDGE_BUILD_PACKAGE="ZIP" .
# if ($?) {
    cmake --build build -j1
# }

if ($?) {
    $Env:PATH += ";$pwd\\build\\lib\\api"
    cd build
    ctest --output-on-failure
    cd ..
}
# .\build.ps1 2>&1 > out.txt
