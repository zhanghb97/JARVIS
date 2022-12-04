#-------------------------------------------------------------------------------
# Navigate to buddy-benchmark and initialize the directories.
#-------------------------------------------------------------------------------
cd /root/buddy-benchmark/
rm -rf build-*
mkdir build-dl build-dap build-dip build-vec

#-------------------------------------------------------------------------------
# Build and run deep learning benchmark.
#-------------------------------------------------------------------------------
cd build-dl
cmake -G Ninja .. \
    -DDEEP_LEARNING_BENCHMARKS=ON \
    -DOpenCV_DIR=/root/opencv/build/ \
    -DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/
ninja
cd bin
./mobilenet-benchmark
./resnet_v2_50-benchmark
./inception-v3-benchmark
./mobilenet-v3-benchmark
./resnet-18-benchmark
./conv-2d-nchw-fchw-benchmark
./depthwise-conv-2d-nhwc-hwc-benchmark
./pooling-nhwc-sum-benchmark
./conv-2d-nhwc-hwcf-benchmark

#-------------------------------------------------------------------------------
# Build and run image processing benchmark.
#-------------------------------------------------------------------------------
cd ../../build-dip
cmake -G Ninja .. \
    -DIMAGE_PROCESSING_BENCHMARKS=ON \
    -DOpenCV_DIR=/root/opencv/build/ \
    -DEIGEN_DIR=/root/eigen/ \
    -DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/
ninja image-processing-benchmark
cd bin
./image-processing-benchmark ../../benchmarks/ImageProcessing/Images/YuTu.png random3x3KernelAlign random3x3KernelAlignInt CONSTANT_PADDING

#-------------------------------------------------------------------------------
# Build and run audio processing benchmark.
#-------------------------------------------------------------------------------
cd ../../build-dap
cmake -G Ninja .. \
    -DAUDIO_PROCESSING_BENCHMARKS=ON \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DKFR_DIR=/root/kfr/ \
    -DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/
ninja audio-processing-benchmark
cd bin
./audio-processing-benchmark

#-------------------------------------------------------------------------------
# Build and run vectorization benchmark.
#-------------------------------------------------------------------------------
cd ../../build-vec
cmake -G Ninja .. \
    -DVECTORIZATION_BENCHMARKS=ON \
    -DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/
ninja vectorization-benchmark
cd bin
./vectorization-benchmark

#-------------------------------------------------------------------------------
# Navigate back to buddy-benchmark.
#-------------------------------------------------------------------------------
cd ../..
