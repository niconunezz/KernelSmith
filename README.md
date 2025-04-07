# KernelSmith

KernelSmith is an educational GPU compiler project built on MLIR (Multi-Level Intermediate Representation) that demonstrates how to create optimized GPU kernels from high-level code. This project aims to provide a clear, well-documented path through the complex world of compiler design for parallel architectures.

## Overview

KernelSmith translates high-level computational expressions into optimized GPU kernels through a series of MLIR dialects and transformations.

## Prerequisites

- CMake (3.10 or higher)
- C++ compiler with C++17 support
- LLVM/MLIR development environment

## Building KernelSmith

### Step 1: Build MLIR

Follow the official MLIR getting started guide at https://mlir.llvm.org/getting_started/ to build and install MLIR.

### Step 2: Build KernelSmith

```bash
# Clone the repository
git clone https://github.com/niconunezz/KernelSmith.git
cd KernelSmith

# Create a build directory
mkdir build
cd build

# Configure and build
cmake ..
make
```

After successful compilation, you'll find the `kernelsmith` compiler binary in the build directory.

## Usage Guide

### Basic Usage

```bash
./build/tools/diss-opt tests/diss_sintax.mlir

```

### Example Input

```
// TODO
```


## Project Structure

- `include/` - Header files for the compiler
- `lib/` - Implementation files for various compiler stages
- `tools/` - Command-line interface tools
- `tests/` - Test cases and regression tests

## Credits
A lot of this code is based on Open AI;s Triton compiler and other open source compilers.

## License
This project is licensed under the Apache 2.0 License - see the LICENSE file for details.