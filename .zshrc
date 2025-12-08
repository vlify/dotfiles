alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -CF'
alias cs="cd ~/Semester-1"
alias lg="lazygit"
alias nvc='cd ~/.config/nvim'
alias python="python3"

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export HTTP_PROXY="http://127.0.0.1:10808"
export HTTPS_PROXY="http://127.0.0.1:10808"
export ALL_PROXY="http://127.0.0.1:10808"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR=vim
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi
export PATH="/usr/local/opt/mysql@8.4/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql@8.4/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@8.4/include"
export PKG_CONFIG_PATH="/usr/local/opt/mysql@8.4/lib/pkgconfig"
export PATH="$PATH:$(go env GOPATH)/bin"
eval "$(starship init zsh)"
