#-------------------------------------------------------------------------------
# check-buddy-mlir-dip-examples.sh
# 
# Run and check the DIP dialect examples in buddy-mlir.
#-------------------------------------------------------------------------------

# Initialize sync status variable.
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
log_name="log-check-buddy-mlir-dip-examples-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-mlir-dip-examples.sh at ${current_time}" > ${log_loc}

# Build and test the DIP example.
cd /root/buddy-mlir/
rm -rf build-check
mkdir build-check
cd build-check
cmake -G Ninja .. \
    -DMLIR_DIR=$PWD/../llvm/build/lib/cmake/mlir \
    -DLLVM_DIR=$PWD/../llvm/build/lib/cmake/llvm \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DBUDDY_EXAMPLES=ON \
    -DBUDDY_DIP_OPT_STRIP_MINING=256 \
    -DBUDDY_ENABLE_OPENCV=ON \
    -DOpenCV_DIR=/root/opencv/build/ \
    >> ${log_loc} 2>&1
ninja correlation2D >> ${log_loc}
cd bin
./correlation2D ../../examples/ConvOpt/images/YuTu.png result-dip-replicate-padding.png result-dip-constant-padding.png >> ${log_loc} 2>&1
if [ $? -ne 0 ]
then
    echo -e "[buddy-mlir] DIP Dialect Corr2D Example \e[31mError\e[0m"
    echo "[buddy-mlir] DIP Dialect Corr2D Example ${1} ${markdown_error}" >> ${status_dir}
    echo "" >> ${status_dir}
    exit 1
else
    echo -e "[buddy-mlir] DIP Dialect Corr2D Example \e[32mSuccessful\e[0m"
    echo "[buddy-mlir] DIP Dialect Corr2D Example ${1} ${markdown_succ}" >> ${status_dir}
    echo "" >> ${status_dir}
fi
