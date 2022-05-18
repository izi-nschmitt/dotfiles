# NAVIGATION
alias scrl="screen -ls"
alias peak="tail -n 3"

# SUDO
alias please=sudo
alias fucking=sudo

# GIT
alias gitnp='git --no-pager'
alias gut='echo "Prost ! 🍺 🍺 🍺"; git'
alias got='echo "Winter is coming ! ❄ ⚔ ❄"; git'
alias fit='echo "Sick gains ! 💪 💪 💪"; git'
alias gti='echo "Vroum Vroum ! 🏎 🏎 🏎"; git'

# MULTI-GIT
alias mg='$HOME/.nodenv/shims/multi-git'

# TEMP
alias cdtemp='cd "$(mktemp -d)"'

# CIRCLECI
alias cci='circleci --skip-update-check'

# KUBECTL
alias kube-utils='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''

# Get CPU request total (we x20 because because each m3.large has 2 vcpus (2000m) )
alias kube-cpualloc='kube-utils | grep % | awk '\''{print $1}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*20), "%\n" } }'\'''

# Get mem request total (we x75 because because each m3.large has 7.5G ram )
alias kube-memalloc='kube-utils | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''
