#-------------------------------------------------------------------------------
# buddy-compiler-auto-sync.sh
# 
# This is the auto-sync script for llvm/mlir submodule daily update.
#-------------------------------------------------------------------------------

cd /root/buddy-mlir

# Create and checkout to new branch

git branch sync
git checkout sync

# Rebase the upstream

git fetch origin
git rebase origin/main

# Sync to the head of llvm-project

cd /root/buddy-mlir/
git submodule update --remote --rebase

# Build the latest llvm/mlir

cd /root/buddy-mlir/llvm/build
ninja
ninja check-mlir

# Build the buddy-mlir

cd /root/buddy-mlir/build
ninja

# Check all the targets.

cd /root/JARVIS
./check-all.sh

if [ $? -ne 0 ]
then
    echo -e "\e[31mPending\e[0m"
    echo "S.O.S. from the sync-bot..."
else
    cd /root/buddy-mlir/llvm
    COMMIT_ID=`git rev-parse --short HEAD`
    echo "ID: $COMMIT_ID"
    cd /root/buddy-mlir
    git add .
    git commit -m "[sync-bot] Sync to llvm-project $COMMIT_ID"
    git push origin sync:main
    git checkout main
    git branch -D sync
    git pull
    git submodule update --init --recursive
    echo "successful!"
fi
