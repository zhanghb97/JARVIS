#-------------------------------------------------------------------------------
# check-buddy-mlir-examples.sh
# 
# Run and check the buddy-mlir examples.
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
log_name="log-check-buddy-mlir-examples-${current_time}.txt"
log_loc=/root/JARVIS/log/${log_name}
echo "Log for check-buddy-mlir-examples.sh at ${current_time}" > ${log_loc}

#-------------------------------------------------------------------------------
# Helper functions.
#-------------------------------------------------------------------------------

checkBudExamples(){
    echo "Checking ${1} ..." >> ${log_loc}
    make ${1} >> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-mlir] Bud Dialect Example: ${1} \e[31mError\e[0m"
        BUDDY_COMPILER_SYNC_STATUS=0
        echo "[buddy-mlir] Bud Dialect Example: ${1} ${markdown_error}" >> ${status_dir}
        echo "" >> ${status_dir}
    else
        echo -e "[buddy-mlir] Bud Dialect Example: ${1} \e[32mSuccessful\e[0m"
        echo "[buddy-mlir] Bud Dialect Example: ${1} ${markdown_succ}" >> ${status_dir}
        echo "" >> ${status_dir}
    fi
}

checkMLIRExamples(){
    echo "Checking ${2} ..." >> ${log_loc}
    make ${2} >> ${log_loc} 2>&1
    if [ $? -ne 0 ]
    then
        echo -e "[buddy-mlir] MLIR ${1} Example: ${2} \e[31mError\e[0m"
        BUDDY_COMPILER_SYNC_STATUS=0
        echo "[buddy-mlir] MLIR ${1} Example: ${2} ${markdown_error}" >> ${status_dir}
        echo "" >> ${status_dir}
    else
        echo -e "[buddy-mlir] MLIR ${1} Example: ${2} \e[32mSuccessful\e[0m"
        echo "[buddy-mlir] MLIR ${1} Example: ${2} ${markdown_succ}" >> ${status_dir}
        echo "" >> ${status_dir}
    fi
}

#-------------------------------------------------------------------------------
# Check Bud dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/BudDialect

# Check bud-array-attr-lower
checkBudExamples bud-array-attr-lower

# Check bud-constant-lower
checkBudExamples bud-constant-lower

# Check bud-print-lower
checkBudExamples bud-print-lower

# Check bud-str-attr-lower
checkBudExamples bud-print-lower

#-------------------------------------------------------------------------------
# Check MLIR Affine dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRAffine

# Check affine-load-run
checkMLIRExamples Affine affine-load-run

#-------------------------------------------------------------------------------
# Check MLIR Linalg dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRLinalg

# Check linalg-conv2d-run
checkMLIRExamples Linalg linalg-conv2d-run

# Check linalg-conv2d-tiling-run
checkMLIRExamples Linalg linalg-conv2d-tiling-run

#-------------------------------------------------------------------------------
# Check MLIR MemRef dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRMemRef

# Check memref-subview-run
checkMLIRExamples MemRef memref-subview-run

#-------------------------------------------------------------------------------
# Check MLIR SCF dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRSCF

# Check scf-while-run
checkMLIRExamples SCF scf-while-run

# Check scf-parallel-run
checkMLIRExamples SCF scf-parallel-run

#-------------------------------------------------------------------------------
# Check MLIR Tensor dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRTensor

# Check tensor-print-run
checkMLIRExamples Tensor tensor-print-run

#-------------------------------------------------------------------------------
# Check MLIR TOSA dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRTOSA

# Check tosa-resize-run
checkMLIRExamples TOSA tosa-resize-run

#-------------------------------------------------------------------------------
# Check MLIR Vector dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRVector

# Check vector-load-run
checkMLIRExamples Vector vector-load-run

# Check vector-broadcast-run
checkMLIRExamples Vector vector-broadcast-run

# Check vector-fma-run
checkMLIRExamples Vector vector-fma-run

# Check vector-long-run
checkMLIRExamples Vector vector-long-run

#-------------------------------------------------------------------------------
# Check MLIR PDL dialect examples.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir/examples/MLIRPDL

# Check vector-load-run
checkMLIRExamples PDL pdl-multiroot-lower

# Exit with error if any error occurs
if [ ${BUDDY_COMPILER_SYNC_STATUS} -ne 1 ]
then
    exit 1
fi
