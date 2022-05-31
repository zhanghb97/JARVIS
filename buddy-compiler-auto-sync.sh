#-------------------------------------------------------------------------------
# buddy-compiler-auto-sync.sh
# 
# This is the auto-sync script for llvm/mlir submodule daily update.
#-------------------------------------------------------------------------------

# Prepare the status page.

log_dir=/root/JARVIS/log
status_dir=/root/JARVIS/log/SyncStatus.md

current_time=`date "+%Y-%m-%d %H:%M:%S"`

if [ ! -d "${log_dir}" ]
then
    mkdir -p ${log_dir}
fi

cd ${log_dir}
rm -rf /root/JARVIS/log/*

echo "---" > ${status_dir}
echo "layout: default" >> ${status_dir}
echo "title: Sync Status" >> ${status_dir}
echo "parent: Display Boards" >> ${status_dir}
echo "---" >> ${status_dir}
echo "" >> ${status_dir}

echo "# Sync Status" >> ${status_dir}
echo "" >> ${status_dir}
echo "Hi! I am the sync-bot of buddy compiler. Buddy compiler uses LLVM/MLIR as the submodules, and we are using the daily synchronizing strategy." >> ${status_dir}
echo "" >> ${status_dir}
echo "**[${current_time}] The following is the sync status:**" >> ${status_dir}
echo "" >> ${status_dir}

# Start the sync process.

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
    echo "🆘 Oops! The sync-bot has detected some errors and is working to fix them..." >> ${status_dir}
    echo "" >> ${status_dir}
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
    echo "✅ Sync to llvm-project $COMMIT_ID ." >> ${status_dir}
    echo "" >> ${status_dir}
fi

#-------------------------------------------------------------------------------
# Push the sync status to website.
#-------------------------------------------------------------------------------

cd /root/buddy-compiler.github.io
git fetch origin
git rebase origin/master

cd /root/buddy-compiler.github.io/Pages/DisplayBoards
rm -rf SyncStatus.md
cp ${status_dir} /root/buddy-compiler.github.io/Pages/DisplayBoards

cd /root/buddy-compiler.github.io
git add .
git commit -m "[sync-bot] Update sync status ${current_time}."
git push
echo "successful!"
