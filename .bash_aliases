# alases
alias kctx='kubectl ctx'
alias kns='kubectl ns'
alias kd='kubectl describe'
alias kst='kubectl status'
alias kaci='kubectl auth can-i'
alias kgr='kubectl get role'
alias kdr='kubectl describe role'
alias kgrb='kubectl get rolebinding'
alias kdrb='kubectl describe rolebinding'
alias kgclr='kubectl get clusterrole'
alias kdclr='kubectl describe clusterrole'
alias kgclrb='kubectl get clusterrolebinding'
alias kdclrb='kubectl describe clusterrolebinding'

# colorized ls
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# list items by size
alias lsz='ls -lrSh'

# colorized grep
alias grep='grep --color'

# find ps
alias findps='ps -ax | grep'

# prints directory structure in colors and sizes
alias tree='tree -Ch'

# alias vim open files with fzf
alias viof='vim $(find . -type f -not -path "*.git/*" -not -path "*node_modules/*" | fzf)'

# dev
# git aliases
alias glog='git log --oneline -n 25 --graph --decorate --color'
alias gshow='git show --stat'
# system
# Show listening ports
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
alias pstree='ps auxf'
alias netcon='ss -tuln'

certinfo() { openssl s_client -connect $1:443 </dev/null 2>/dev/null | openssl x509 -noout -text ; }
certinfodates() { openssl s_client -connect $1:443 </dev/null 2>/dev/null | openssl x509 -noout -dates ; }