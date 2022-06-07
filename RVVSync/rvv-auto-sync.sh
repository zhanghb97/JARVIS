#-------------------------------------------------------------------------------
# rvv-auto-sync.sh
# 
# This is the auto-sync script for RVV toolchain and MLIR RVV dialect.
#-------------------------------------------------------------------------------

# Prepare the status page and status variables.

log_dir=/root/JARVIS/RVVSync/log
status_dir=/root/JARVIS/RVVSync/log/RVVStatus.md
markdown_error="<font color="red">error</font>"
markdown_succ="<font color="green">successful</font>"

current_time=`date "+%Y-%m-%d %H:%M:%S"`

if [ ! -d "${log_dir}" ]
then
    mkdir -p ${log_dir}
fi

rm -rf /root/JARVIS/RVVSync/log/*
cd ${log_dir}

echo "---" > ${status_dir}
echo "layout: default" >> ${status_dir}
echo "title: RVV Status" >> ${status_dir}
echo "parent: Display Boards" >> ${status_dir}
echo "---" >> ${status_dir}
echo "" >> ${status_dir}

#-------------------------------------------------------------------------------
# Title and description.
#-------------------------------------------------------------------------------

echo "# RISC-V Vector Extension Toolchain Status" >> ${status_dir}
echo "" >> ${status_dir}
echo "Hi! I am the sync-bot of buddy compiler, and I am responsible for updating the RISC-V toolchain and testing if the MLIR RVV support is working." >> ${status_dir}
echo "" >> ${status_dir}
echo "**[${current_time}] The following is the sync information and status.**" >> ${status_dir}
echo "" >> ${status_dir}

echo "---" >> ${status_dir}

#-------------------------------------------------------------------------------
# Rebase the RVV patch and get the upstream commit ID.
#-------------------------------------------------------------------------------

cd /root/llvm-project
git fetch origin
git rebase origin/main
LLVM_COMMIT_ID=`git rev-parse --short HEAD^`

echo "## LLVM Project" >> ${status_dir}
echo "**URL** https://github.com/llvm/llvm-project" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Commit ID** ${LLVM_COMMIT_ID}" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Branch** main" >> ${status_dir}
echo "" >> ${status_dir}

echo "---" >> ${status_dir}
echo "" >> ${status_dir}

#-------------------------------------------------------------------------------
# Get the information of RISC-V GNU toolchain.
# TODO: sync to the latest version every day.
#-------------------------------------------------------------------------------

cd /root/env-zoo/riscv-gnu-toolchain
RISCV_GNU_TOOLCHAIN_COMMIT_ID=`git rev-parse --short HEAD`

echo "## RISC-V GNU Toolchain" >> ${status_dir}
echo "**URL** https://github.com/riscv-collab/riscv-gnu-toolchain" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Commit ID** ${RISCV_GNU_TOOLCHAIN_COMMIT_ID}" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Branch** rvv-next" >> ${status_dir}
echo "" >> ${status_dir}

echo "---" >> ${status_dir}
echo "" >> ${status_dir}

#-------------------------------------------------------------------------------
# Get the information of QEMU.
#-------------------------------------------------------------------------------

cd /root/env-zoo/qemu
QEMU_COMMIT_ID=`git rev-parse --short HEAD`

echo "## QEMU" >> ${status_dir}
echo "**URL** https://github.com/sifive/qemu" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Commit ID** ${QEMU_COMMIT_ID}" >> ${status_dir}
echo "" >> ${status_dir}
echo "**Branch** master" >> ${status_dir}
echo "" >> ${status_dir}

echo "---" >> ${status_dir}
echo "" >> ${status_dir}

#-------------------------------------------------------------------------------
# Run the RVV patch integration test and print the status.
#-------------------------------------------------------------------------------

echo "## MLIR RISC-V Vector Dialect RFC Patch" >> ${status_dir}

cd /root/llvm-project
rm -rf build-integration
mkdir build-integration
cd build-integration
cmake -G Ninja ../llvm  \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="X86;RISCV" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DMLIR_INCLUDE_INTEGRATION_TESTS=ON \
  -DMLIR_RUN_RISCV_VECTOR_TESTS=ON \
  -DRISCV_VECTOR_QEMU_EXECUTABLE="/root/env-zoo/qemu/build/riscv64-linux-user/qemu-riscv64" \
  -DRISCV_VECTOR_QEMU_OPTIONS="-L /root/env-zoo/build-gnu-toolchain/sysroot/ -cpu rv64,x-v=true" \
  -DRISCV_QEMU_LLI_EXECUTABLE="/root/env-zoo/build-cross-clang/bin/lli" \
  -DRISCV_QEMU_UTILS_LIB_DIR="/root/env-zoo/build-cross-mlir/lib/"

ninja check-mlir-integration

if [ $? -ne 0 ]
then
    echo -e "[Integration Test] \e[31mError\e[0m"
    echo "**Integration Test** ${markdown_error}" >> ${status_dir}
    echo "🆘 Oops! The sync-bot has detected some errors and is working to fix them..." >> ${status_dir}
    echo "" >> ${status_dir}
else
    echo -e "[Integration Test] \e[32mSuccessful\e[0m"
    echo "**Integration Test** ${markdown_succ}" >> ${status_dir}
    echo "" >> ${status_dir}
fi

#-------------------------------------------------------------------------------
# Push the sync status to website.
#-------------------------------------------------------------------------------

cd /root/buddy-compiler.github.io
git fetch origin
git rebase origin/master

cd /root/buddy-compiler.github.io/Pages/DisplayBoards
rm -rf RVVStatus.md
cp ${status_dir} /root/buddy-compiler.github.io/Pages/DisplayBoards

cd /root/buddy-compiler.github.io
git add .
git commit -m "[sync-bot] Update rvv sync status ${current_time}."
git push
echo "successful!"
