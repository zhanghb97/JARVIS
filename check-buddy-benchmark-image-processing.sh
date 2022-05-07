#-------------------------------------------------------------------------------
# check-buddy-benchmark-image-processing.sh
# 
# Run and check the image processing benchamrk in buddy-benchmark.
#-------------------------------------------------------------------------------

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
    ./${1} ../../benchmarks/ImageProcessing/Images/${2}.png ${3}>> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-benchmark] Image Processing Case: ${1} \e[31mError\e[0m"
    else
        echo -e "[buddy-benchmark] Image Processing Case: ${1} \e[32mSuccessful\e[0m"
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
	-DBUDDY_OPT_BUILD_DIR=/root/buddy-mlir/build/ \
    >> ${log_loc} 2>&1
ninja image-processing-benchmark >> ${log_loc} 2>&1

#-------------------------------------------------------------------------------
# Check image processing cases.
#-------------------------------------------------------------------------------

cd bin

# Check image-processing-benchmark
checkImageProcessingBenchmark image-processing-benchmark YuTu laplacianKernelAlign
