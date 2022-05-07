#-------------------------------------------------------------------------------
# check-all.sh
# 
# Check all buddy compiler cases.
#-------------------------------------------------------------------------------

# Initialize sync status variable.
BUDDY_COMPILER_SYNC_STATUS=1

#-------------------------------------------------------------------------------
# Helper functions.
#-------------------------------------------------------------------------------

checkBuddyCompilerTargets(){
    cd /root/JARVIS
    ./${1}.sh
    if [ $? -ne 0 ]
    then
        BUDDY_COMPILER_SYNC_STATUS=0
    fi
}

#-------------------------------------------------------------------------------
# Check all targets.
#-------------------------------------------------------------------------------

checkBuddyCompilerTargets check-buddy-mlir-convopt-examples
checkBuddyCompilerTargets check-buddy-mlir-dip-examples
checkBuddyCompilerTargets check-buddy-mlir-examples
checkBuddyCompilerTargets check-buddy-mlir-jit-benchmark
checkBuddyCompilerTargets check-buddy-benchmark-audio-processing
checkBuddyCompilerTargets check-buddy-benchmark-deep-learning
checkBuddyCompilerTargets check-buddy-benchmark-image-processing

# Exit with error if any error occurs
if [ ${BUDDY_COMPILER_SYNC_STATUS} -ne 1 ]
then
    exit 1
fi
