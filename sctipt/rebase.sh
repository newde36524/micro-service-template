#!/bin/bash

# rebase.sh - 同步目标分支并追加当前分支的提交
# 用法: ./rebase.sh <目标分支名>

# 参数检查（目标分支不能为空）
if [ -z "$1" ]; then
    echo "Error: The target branch cannot be empty"
    echo -e "Example:\n\t./rebase.sh dev-2.1"
    exit 1
fi

targetBranch="$1"

echo "Starting rebase to target branch $targetBranch"
echo "target_branch: $targetBranch"

# 保存当前分支（必须在切换前获取）
currentBranch=$(git rev-parse --abbrev-ref HEAD)
echo "current_branch: $currentBranch"

# 核心 rebase 流程（任何一步失败则立即退出）
git checkout "$targetBranch" && \
git pull && \
lastCommitHead=$(git rev-parse HEAD) && \
git checkout "$currentBranch" && \
git rebase --onto "$targetBranch" "$lastCommitHead" "$currentBranch" && \
git push origin "$currentBranch" --force-with-lease && \
echo "Rebase completed successfully"