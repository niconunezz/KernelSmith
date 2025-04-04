cmake_minimum_required(VERSION 3.20.0)

project(mlir-diss LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard to conform to")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(BUILD_DEPS ON)

set(MLIR_DIR "${CMAKE_CURRENT_SOURCE_DIR}/llvm-project/build/lib/cmake/mlir")

find_package(MLIR REQUIRED CONFIG)

message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

set(MLIR_BINARY_DIR ${CMAKE_BINARY_DIR})

include(AddLLVM)
include(TableGen)

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
include(AddMLIR)
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/llvm-project)
include_directories(${PROJECT_BINARY_DIR})

message(STATUS "Fetching or-tools...")
include(FetchContent)
FetchContent_Declare(
  or-tools
  GIT_REPOSITORY https://github.com/google/or-tools.git
  GIT_TAG        v9.11
)
FetchContent_MakeAvailable(or-tools)
message(STATUS "Done fetching or-tools")
# Añade el directorio tools
add_subdirectory(tools)
add_subdirectory(lib)
