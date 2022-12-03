#-------------------------------------------------------------------------------
# check-buddy-benchmark-deep-learning.sh
# 
# Run and check the deep learning benchamrk in buddy-benchmark.
#-------------------------------------------------------------------------------

# Initialize sync status variable.

BUDDY_COMPILER_SYNC_STATUS=1
status_dir=/root/JARVIS/log/SyncStatus.md
markdown_error="<font color="red">error</font>"
markdown_succ="<font color="green">successful</font>"

# Prepare the log.txt
log_dir=/root/JARVIS/log

if [ ! -d "${log_dir}" ]
then
    mkdir -p ${log_dir}
fi

current_time=`date "+%Y-%m-%d-%H-%M-%S"`
log_name="log-check-buddy-benchmark-deep-learning-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-benchmark-deep-learning.sh at ${current_time}" > ${log_loc}

#-------------------------------------------------------------------------------
# Helper functions.
#-------------------------------------------------------------------------------

checkDeepLearningBenchmark(){
    echo "Checking ${1} ..." >> ${log_loc}
    ./${1} >> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-benchmark] Deep Learning Case: ${1} \e[31mError\e[0m"
        BUDDY_COMPILER_SYNC_STATUS=0
        echo "[buddy-benchmark] Deep Learning Case: ${1} ${markdown_error}" >> ${status_dir}
        echo "" >> ${status_dir}
    else
        echo -e "[buddy-benchmark] Deep Learning Case: ${1} \e[32mSuccessful\e[0m"
        echo "[buddy-benchmark] Deep Learning Case: ${1} ${markdown_succ}" >> ${status_dir}
        echo "" >> ${status_dir}
    fi
}

#-------------------------------------------------------------------------------
# Build deep learning benchmark.
#-------------------------------------------------------------------------------

cd /root/buddy-benchmark
rm -rf build-check
mkdir build-check
cd build-check
cmake -G Ninja .. \
	-DDEEP_LEARNING_BENCHMARKS=ON \
	-DOpenCV_DIR=/root/opencv/build \
	-DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/ \
    >> ${log_loc} 2>&1
ninja >> ${log_loc} 2>&1

#-------------------------------------------------------------------------------
# Check deep learning cases.
#-------------------------------------------------------------------------------

cd bin

# Check conv-2d-nchw-fchw-benchmark
checkDeepLearningBenchmark conv-2d-nchw-fchw-benchmark

# Check conv-2d-nhwc-hwcf-benchmark
checkDeepLearningBenchmark conv-2d-nhwc-hwcf-benchmark

# Check depthwise-conv-2d-nhwc-hwc-benchmark
checkDeepLearningBenchmark depthwise-conv-2d-nhwc-hwc-benchmark

# Check pooling-nhwc-sum-benchmark
checkDeepLearningBenchmark pooling-nhwc-sum-benchmark

# Check inception-v3-benchmark
checkDeepLearningBenchmark inception-v3-benchmark

# Check mobilenet-benchmark
checkDeepLearningBenchmark mobilenet-benchmark

# Check mobilenet-v3-benchmark
checkDeepLearningBenchmark mobilenet-v3-benchmark

# Check resnet_v2_50-benchmark
checkDeepLearningBenchmark resnet_v2_50-benchmark

# Exit with error if any error occurs
if [ ${BUDDY_COMPILER_SYNC_STATUS} -ne 1 ]
then
    exit 1
fi
