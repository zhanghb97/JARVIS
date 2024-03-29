#-------------------------------------------------------------------------------
# check-buddy-benchmark-image-processing.sh
# 
# Run and check the image processing benchamrk in buddy-benchmark.
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
log_name="log-check-buddy-benchmark-image-processing-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-benchmark-image-processing.sh at ${current_time}" > ${log_loc}

#-------------------------------------------------------------------------------
# Helper functions.
#-------------------------------------------------------------------------------

checkImageProcessingBenchmark(){
    echo "Checking ${1} ..." >> ${log_loc}
    ./${1} ../../benchmarks/ImageProcessing/Images/${2}.png ${3} ${4} ${5} >> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-benchmark] Image Processing Case: ${1} ${4} ${5} \e[31mError\e[0m"
        BUDDY_COMPILER_SYNC_STATUS=0
        echo "[buddy-benchmark] Image Processing Case: ${1} ${4} ${5} ${markdown_error}" >> ${status_dir}
        echo "" >> ${status_dir}
    else
        echo -e "[buddy-benchmark] Image Processing Case: ${1} ${4} ${5} \e[32mSuccessful\e[0m"
        echo "[buddy-benchmark] Image Processing Case: ${1} ${4} ${5} ${markdown_succ}" >> ${status_dir}
        echo "" >> ${status_dir}
    fi
}

#-------------------------------------------------------------------------------
# Build image processing benchmark.
#-------------------------------------------------------------------------------

cd /root/buddy-benchmark
rm -rf build-check
mkdir build-check
cd build-check
cmake -G Ninja .. \
	-DIMAGE_PROCESSING_BENCHMARKS=ON \
    -DOpenCV_DIR=/root/opencv/build \
    -DEIGEN_DIR=/root/eigen/ \
	-DBUDDY_MLIR_BUILD_DIR=/root/buddy-mlir/build/ \
    >> ${log_loc} 2>&1
ninja image-processing-benchmark >> ${log_loc} 2>&1

#-------------------------------------------------------------------------------
# Check image processing cases.
#-------------------------------------------------------------------------------

cd bin

# Check image-processing-benchmark
checkImageProcessingBenchmark image-processing-benchmark YuTu random3x3KernelAlign random3x3KernelAlignInt CONSTANT_PADDING
checkImageProcessingBenchmark image-processing-benchmark YuTu random3x3KernelAlign random3x3KernelAlignInt REPLICATE_PADDING

# Exit with error if any error occurs
if [ ${BUDDY_COMPILER_SYNC_STATUS} -ne 1 ]
then
    exit 1
fi
