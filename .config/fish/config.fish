if status is-interactive
    # ── tmux 智能自动接入与深度防御 ──
    # 防御条件检查：
    # 1. 不在已有的 tmux 会话内 ($TMUX 为空)
    # 2. 未设置紧急跳过变量 ($NO_TMUX 为空，支持临时以 NO_TMUX=1 alacritty 跳过)
    # 3. 必须处于真实 TTY 终端 (test -t 0 且 test -t 1)
    # 4. 排除 IDE / 编辑器内置终端 (Neovim $NVIM, VS Code, JetBrains, Emacs 等)
    # 5. 系统中存在 tmux 可执行命令 (type -q tmux)
    if test -z "$TMUX"
        and test -z "$NO_TMUX"
        and test -z "$NVIM"
        and test -z "$VSCODE_INJECTION"
        and test -z "$VSCODE_RESOLVING_ENVIRONMENT"
        and test -z "$INSIDE_EMACS"
        and test -z "$INTELLIJ_ENVIRONMENT_READER"
        and test -t 0
        and test -t 1
        and type -q tmux

        # 智能接入/创建名为 main 的会话
        # 防死锁策略：正常退出/detach(状态码 0)则关闭终端；若 tmux 启动崩溃则保留终端防止用户被锁在外面
        tmux new-session -A -s main
        if test $status -eq 0
            exit 0
        else
            echo "⚠️ tmux 异常退出或无法启动，已为你保留原生 Fish Shell。"
        end
    end
end
starship init fish | source
set -gx EDITOR nvim
set -g fish_key_bindings fish_vi_key_bindings

# config network proxy
set http_proxy 127.0.0.1:7897
set https_proxy 127.0.0.1:7897
# config bare repo
#alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
abbr -a dotfiles '/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
# add lazygit support
abbr -a lzd 'set -lx GIT_DIR $HOME/.dotfiles; set -lx GIT_WORK_TREE $HOME; lazygit'
# add system update
abbr -a paru 'sudo dnf upgrade -y; sudo dnf autoremove -y; flatpak update -y'
# add btop running in admin
abbr -a bp 'sudo btop'
# add yazi running in admin
abbr -a yz yazi

# >>> coursier install directory >>>
set -gx PATH "$PATH:$HOME/.local/share/coursier/bin"
# <<< coursier install directory <<<

# Added by Antigravity CLI installer
set -gx PATH "$HOME/.local/bin" $PATH

# Ductor (Matrix Agent for Antigravity) XDG environment
set -gx DUCTOR_HOME "$HOME/.local/share/ductor"


# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# ActivityWatch 活跃报告:aw-report [today|yesterday|YYYY-MM-DD](默认 today,按 app 分组、已扣 AFK)
function aw-report
    set -l day (date +%Y-%m-%d)
    set -l stop (date +%Y-%m-%dT%H:%M:%S)
    if test (count $argv) -ge 1
        switch "$argv[1]"
            case today
                # 默认行为:今天,stop=now(已在上方设置)
            case yesterday
                set day (date -d yesterday +%Y-%m-%d)
                set stop "$day"T23:59:59
            case '*'
                set day "$argv[1]"
                set stop "$day"T23:59:59
        end
    end
    aw-client query "$HOME/.config/aw-client/queries/app-breakdown.txt" --start "$day"T00:00:00 --stop "$stop" --timezone Asia/Shanghai
end

# qutebrowser Greasemonkey 脚本安装: gmi <greasyfork_id> [名字]
# 从 greasyfork 直链下载到 qutebrowser 数据目录, @run-at document-start 自动改为 document-end
# (qutebrowser 时序坑: document-start 时 document.body 还没生成, 会报 appendChild null)
function gmi --description "安装 greasyfork 脚本到 qutebrowser"
    set -l dir ~/.local/share/qutebrowser/greasemonkey
    if test (count $argv) -lt 1
        echo "用法: gmi <greasyfork_id> [名字]  例: gmi 486151 bilibili-auto-quality"
        return 1
    end
    set -l id $argv[1]
    set -l name $argv[2]
    test -z "$name"; and set name $id
    set -l file $dir/$id-$name.user.js
    curl -fsSL -o $file https://update.greasyfork.org/scripts/$id/script.user.js
    or begin; echo "下载失败 (id=$id)"; rm -f $file; return 1; end
    # document-start → document-end(qutebrowser 兼容)
    sed -i 's|@run-at[[:space:]]*document-start|@run-at document-end|' $file
    echo "已安装: $file"
    grep -m1 "@version" $file
    echo "记得在 qutebrowser 里按 ,gr 重载"
end
