#-------------------------------------------------------------------------------
# check-buddy-mlir-jit-benchmark.sh
# 
# Run and check the JIT benchmark in buddy-mlir.
#-------------------------------------------------------------------------------

# Prepare the log.txt
log_dir=/root/JARVIS/log

if [ ! -d "${log_dir}" ]
then
    mkdir -p ${log_dir}
fi

current_time=`date "+%Y-%m-%d-%H-%M-%S"`
log_name="log-check-buddy-mlir-jit-benchmark-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-mlir-jit-benchmark.sh at ${current_time}" > ${log_loc}

# Test the JIT benchmark in buddy-mlir
cd /root/buddy-mlir/benchmark
make >> ${log_loc} 2>&1
if [ $? -ne 0 ]
then
    echo -e "[buddy-mlir] JIT benchmark \e[31mError\e[0m"
    exit 1
else
    echo -e "[buddy-mlir] JIT benchmark \e[32mSuccessful\e[0m"
fi
