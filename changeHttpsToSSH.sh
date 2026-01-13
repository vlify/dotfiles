#/bin/bash
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "错误：当前目录不是一个 Git 仓库 ❌"
  exit 1
fi

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "未检测到 .ssh 文件夹，正在准备生成..."
  read -p "请输入你的 GitHub 邮箱: " EMAIL
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "$EMAIL" -N ""

  echo "------------------------------------------------"
  echo "SSH 密钥已生成！请复制以下内容并添加到 GitHub 设置中："
  # 4. 打印公钥
  cat ~/.ssh/id_ed25519.pub
  echo "------------------------------------------------"
fi

CURRENT_URL=$(git remote get-url origin)
if [[ "$CURRENT_URL" == https* ]]; then
  NEW_URL=$(echo "$CURRENT_URL" | sed 's_https://_git@_; s_/_:_')
  git remote set-url origin "$NEW_URL"
  echo "成功！地址已切换为: $NEW_URL"

else
  echo "这看起来不像是 HTTPS 地址，或者已经是 SSH 了。"
fi
