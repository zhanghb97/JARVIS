#-------------------------------------------------------------------------------
# check-all.sh
# 
# Check all buddy compiler cases.
#-------------------------------------------------------------------------------

cd /root/JARVIS
./check-buddy-mlir-convopt-examples.sh
cd /root/JARVIS
./check-buddy-mlir-dip-examples.sh
cd /root/JARVIS
./check-buddy-mlir-examples.sh
cd /root/JARVIS
./check-buddy-mlir-jit-benchmark.sh 
cd /root/JARVIS
./check-buddy-benchmark-audio-processing.sh
cd /root/JARVIS
./check-buddy-benchmark-deep-learning.sh
cd /root/JARVIS
./check-buddy-benchmark-image-processing.sh
