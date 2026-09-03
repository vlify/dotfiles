import site
import sys

# 确保在 python -sP (如 Fedora 默认) 环境下能正确加载用户级 adblock 依赖
user_site = site.getusersitepackages()
if user_site not in sys.path:
    sys.path.insert(0, user_site)

try:
    from qutebrowser.components import braveadblock
    from qutebrowser.utils import version

    if not version.MODULE_INFO["adblock"].is_installed():
        import adblock

        braveadblock.adblock = adblock
        version.MODULE_INFO["adblock"]._initialize_info()
except Exception:
    pass

import catppuccin

# ignore GUI setting
config.load_autoconfig(False)


# === 键位封装(参考 noctuid/dotfiles 设计) ===
def bind(key, command, mode):
    config.bind(key, command, mode=mode)


def nmap(key, command):
    bind(key, command, "normal")


def imap(key, command):
    bind(key, command, "insert")


def cmap(key, command):
    bind(key, command, "command")


def tmap(key, command):
    bind(key, command, "caret")


def pmap(key, command):
    bind(key, command, "passthrough")


def unmap(key, mode):
    config.unbind(key, mode=mode)


def nunmap(key):
    unmap(key, "normal")


# set catppuccin scheme
catppuccin.setup(c, "mocha", True)

# change the editor to neovim
c.editor.command = ["alacritty", "-e", "nvim", "{file}"]

# content the proxy
# c.content.proxy= "http://localhost:7897"

# force webpage to darkmode
c.colors.webpage.darkmode.enabled = True

# 启用双重广告拦截 (Host 规则 + 基于 Rust 的 Brave/python-adblock 规则)
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://filters.adtidy.org/extension/ublock/filters/2_without_easylist.txt",  # AdGuard 基础规则
    "https://filters.adtidy.org/extension/ublock/filters/224.txt",                 # AdGuard 中文过滤规则
    "https://filters.adtidy.org/extension/ublock/filters/14.txt",                  # AdGuard 烦扰与 Cookie 弹窗拦截
    "https://easylist-downloads.adblockplus.org/easylistchina.txt",                # EasyList China
]

# Limit fullscreen to browser window
c.content.fullscreen.window = True

# let <Ctrl-c> turn to exit
nmap("<Ctrl-c>", "mode-leave")
imap("<Ctrl-c>", "mode-leave")
cmap("<Ctrl-c>", "mode-leave")

# let t turn to open webpage in new tabs
nmap("t", "cmd-set-text -s :open -t")
nunmap("O")

# set tabs position
c.tabs.position = "left"
c.tabs.pinned.shrink = True
c.tabs.show = "switching"

# qute-pass 自动填充 (pass 后端): ,p=全部填充, ,u=仅账号, ,P=仅密码, ,o=仅TOTP
# pass-import 条目为扁平文件, 用户名在 secret 的 "login: " 行, 故用 --username-target secret
# GM 脚本管理: ,gr = 重载 greasemonkey 脚本(改完脚本按这个, 再 r 刷页面)
nmap(",gr", "greasemonkey-reload")
nmap(",gc", "config-source")
nmap(
    ",p",
    "spawn --userscript qute-pass --username-target secret --username-pattern 'login: (.+)'",
)
nmap(
    ",u",
    "spawn --userscript qute-pass --username-target secret --username-pattern 'login: (.+)' --username-only",
)
nmap(",P", "spawn --userscript qute-pass --password-only")
nmap(",o", "spawn --userscript qute-pass --otp-only")

# gi 用 hint 精准选输入框(配合 ,p/,u/,P 更可靠)
nmap("gi", "hint inputs")

# === 剪贴板直接打开(noctuid) ===
nmap("P", "open --tab -- {clipboard}")
nmap("p", "open -- {clipboard}")

# === 输入框里 Ctrl-i 调出 nvim ===
imap("<Ctrl-i>", "edit-text")

# === insert 模式 Ctrl-w 删词 ===
imap("<Ctrl-w>", "fake-key <Ctrl-backspace>")
nunmap("<Ctrl-W>")

# === ty 用 mpv 播放当前页面视频 ===
nmap(",ty", 'spawn --detach mpv "{url}"')

# === dl 选词快速查词 (kd 悬浮终端) ===
nmap(",dl", "spawn --userscript qute-dict")
tmap(",dl", "spawn --userscript qute-dict")

# === 恢复原生 Caret 模式 ===
nmap("v", "mode-enter caret")
nmap("V", "mode-enter caret ;; selection-toggle --line")
