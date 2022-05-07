#-------------------------------------------------------------------------------
# check-buddy-benchmark-audio-processing.sh
# 
# Run and check the audio processing benchamrk in buddy-benchmark.
#-------------------------------------------------------------------------------

# Prepare the log.txt
log_dir=/root/JARVIS/log

if [ ! -d "${log_dir}" ]
then
    mkdir -p ${log_dir}
fi

current_time=`date "+%Y-%m-%d-%H-%M-%S"`
log_name="log-check-buddy-benchmark-audio-processing-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-benchmark-audio-processing.sh at ${current_time}" > ${log_loc}

#-------------------------------------------------------------------------------
# Helper functions.
#-------------------------------------------------------------------------------

checkAudioProcessingBenchmark(){
    echo "Checking ${1} ..." >> ${log_loc}
    ./${1} >> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-benchmark] Audio Processing Case: ${1} \e[31mError\e[0m"
    else
        echo -e "[buddy-benchmark] Audio Processing Case: ${1} \e[32mSuccessful\e[0m"
    fi
}

#-------------------------------------------------------------------------------
# Build audio processing benchmark.
#-------------------------------------------------------------------------------

cd /root/buddy-benchmark
rm -rf build-check
mkdir build-check
cd build-check
cmake -G Ninja .. \
	-DAUDIO_PROCESSING_BENCHMARKS=ON \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DKFR_DIR=/root/kfr/ \
    >> ${log_loc} 2>&1
ninja audio-processing-benchmark >> ${log_loc} 2>&1

#-------------------------------------------------------------------------------
# Check audio processing cases.
#-------------------------------------------------------------------------------

cd bin

# Check image-processing-benchmark
checkAudioProcessingBenchmark audio-processing-benchmark
