#!/usr/bin/env sh

cd build
# cmake -D CMAKE_C_COMPILER=/usr/bin/clang.exe -D CMAKE_CXX_COMPILER=/usr/bin/clang++.exe ..
cmake -G "MSYS Makefiles" -D CMAKE_C_COMPILER=/c/msys64/mingw64/bin/clang.exe -D CMAKE_CXX_COMPILER=/c/msys64/mingw64/bin/clang++.exe ..

