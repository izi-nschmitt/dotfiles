#!/bin/bash

INIT_PROMPT=""
INIT_PROMPT="${INIT_PROMPT}Setup templates: \n"
INIT_PROMPT="${INIT_PROMPT}🔹 1: zsh, dotfiles, nodenv, pyenv, awscli, awssam, ansible, docker, kubectl, helm, helmfile \n"
INIT_PROMPT="${INIT_PROMPT}🔹 2: zsh, dotfiles, nodenv, pyenv, awscli, ansible \n"
INIT_PROMPT="${INIT_PROMPT}🔹 3: zsh, dotfiles \n"
INIT_PROMPT="${INIT_PROMPT}🔹 4: tmux \n"
INIT_PROMPT="${INIT_PROMPT}🔹 a: Abort \n"
INIT_PROMPT="${INIT_PROMPT}Select a setup template: (1, 2, 3, 4, a): "

VERSIONS_PROMPT=""
VERSIONS_PROMPT=""

INSTALL_ZSH=""
INSTALL_DOTFILES=""
INSTALL_NODENV=""
INSTALL_PYENV=""
INSTALL_AWSCLI=""
INSTALL_SAMCLI=""
INSTALL_ANSIBLE=""
INSTALL_DOCKER=""
INSTALL_KUBE=""
INSTALL_TMUX=""
INSTALL_WSL=""
NODE_VERSION="12.16.1"
PY_VERSION="3.8.3"
HELM_VERSION="3.2.4"
HELMFILE_VERSION="0.120.0"
HELMDIFF_VERSION="3.1.1"
STERN_VERSION="1.11.0"
COMPOSE_VERSION="1.26.2"

init()
{
    printf "$INIT_PROMPT"
    read -p "" -n 1 -r
    echo
    if [[ "$REPLY" =~ ^[1]$ ]]; then
        echo "1 selected"
        INSTALL_ZSH="1"
        INSTALL_DOTFILES="1"
        INSTALL_NODENV="1"
        INSTALL_PYENV="1"
        INSTALL_AWSCLI="1"
        INSTALL_SAMCLI="1"
        INSTALL_ANSIBLE="1"
        INSTALL_DOCKER="1"
        INSTALL_KUBE="1"
    elif [[ "$REPLY" =~ ^[2]$ ]]; then
        INSTALL_ZSH="1"
        INSTALL_DOTFILES="1"
        INSTALL_NODENV="1"
        INSTALL_PYENV="1"
        INSTALL_AWSCLI="1"
        INSTALL_ANSIBLE="1"
    elif [[ "$REPLY" =~ ^[3]$ ]]; then
        INSTALL_ZSH="1"
        INSTALL_DOTFILES="1"
    elif [[ "$REPLY" =~ ^[4]$ ]]; then
        INSTALL_TMUX="1"
    elif [[ "$REPLY" =~ ^[aA]$ ]]; then
        echo "Aborting..."
        exit
    else
        init
    fi

    if [[ ! -z "$WSL_DISTRO_NAME" ]]; then
        INSTALL_WSL="1"
    fi
}

installZsh()
{
    echo -e "⌛ installing zsh"
    # zsh
    if [[ -x "$(command -v apt-get)" ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq zsh
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install -yq zsh
    fi

    # oh my zsh
    export CHSH="no"
    export RUNZSH="no"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    unset CHSH
    unset RUNZSH

    export ZSH="$HOME/.oh-my-zsh"
    export ZSH_CUSTOM="$ZSH/custom"

    # powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    if [[ -e "~/.zshrc" ]]; then
        mv ~/.zshrc ~/dotfiles-setup-leftovers/
    fi

    cd
    ln -s dotfiles/.zshrc

    chsh -s "$(which zsh)"
}

installGit()
{
    echo -e "⌛ installing git"
    # git
    if [[ -x "$(command -v apt-get)" ]]; then
        sudo add-apt-repository ppa:git-core/ppa
        sudo apt-get update
        sudo apt-get install git
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install git
    fi

    if [[ -e "~/.gitconfig" ]]; then
        mv ~/.gitconfig ~/dotfiles-setup-leftovers/
    fi

    cd
    ln -s dotfiles/.gitconfig

    read -p "Enter your email: " -r
    USER_EMAIL="$REPLY"
    read -p "Enter your name: " -r
    USER_NAME="$REPLY"

    cat > ~/dotfiles/.gitconfig_user <<EOL
[user]
  email = "${USER_EMAIL}"
  name = "${USER_NAME}"
EOL
}

installGitFlow()
{
    echo -e "⌛ installing git flow"
    # git flow
    brew install git-flow-avh
}

installVim()
{
    echo -e "⌛ installing vim"
    # vim
    if [[ -x "$(command -v apt-get)" ]]; then
        sudo apt-get install -yq vim
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install -yq vim
    fi

    if [[ -e "~/.vim" ]]; then
        mv ~/.vim ~/dotfiles-setup-leftovers/
    fi

    if [[ -e "~/.vimrc" ]]; then
        mv ~/.vimrc ~/dotfiles-setup-leftovers/
    fi

    cd
    ln -s dotfiles/.vim
    ln -s dotfiles/.vimrc
}

installNode()
{
    echo -e "⌛ installing nodenv & npm"
    # npm
    if [[ -e "~/.npm/etc/npmrc" ]]; then
        mkdir -p ~/dotfiles-setup-leftovers/.npm/etc
        mv ~/.npm/etc/npmrc  ~/dotfiles-setup-leftovers/.npm/etc/npmrc
    fi

    mkdir -p ~/.npm/etc
    cd ~/.npm/etc
    ln -s ~/dotfiles/.npmrc npmrc
    cd

    # nodenv
    curl -fsSL https://raw.githubusercontent.com/nodenv/nodenv-installer/master/bin/nodenv-installer | bash
    export PATH="$HOME/.nodenv/bin:$PATH"
    eval "$(nodenv init -)"

    mkdir -p "$(nodenv root)"/plugins
    git clone https://github.com/nodenv/nodenv-update.git "$(nodenv root)"/plugins/nodenv-update
    git clone https://github.com/nodenv/nodenv-default-packages.git $(nodenv root)/plugins/nodenv-default-packages
    cat > $(nodenv root)/default-packages <<EOL
npm
npm-upgrade
nodemon
multi-git
EOL
    git clone https://github.com/nodenv/nodenv-package-rehash.git "$(nodenv root)"/plugins/nodenv-package-rehash
    git clone https://github.com/nodenv/nodenv-package-json-engine.git $(nodenv root)/plugins/nodenv-package-json-engine

    nodenv install $NODE_VERSION
    nodenv global $NODE_VERSION
}

installPython()
{
    echo -e "⌛ installing pyenv & pip"
    # pyenv
    if [[ -x "$(command -v apt-get)" ]]; then
        sudo apt-get install -yq make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install -yq sudo yum install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
    fi

    curl -fsSL https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    pyenv install $PY_VERSION
    pyenv global $PY_VERSION

    # pip
    pip install --upgrade pip
}

installHomebrew()
{
    echo -e "⌛ installing homebrew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    sudo apt-get install build-essential
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
}

installAWSCLI()
{
    echo -e "⌛ installing aws cli"
    # awscli
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/aws
    rm /tmp/awscliv2.zip
}

installSAMCLI()
{
    echo -e "⌛ installing aws sam cli"
    # awssamcli
    brew tap aws/tap
    brew install aws-sam-cli
}

installAnsible()
{
    echo -e "⌛ installing ansible"
    # ansible
    brew install ansible

    if [[ -e "~/.ansible.cfg" ]]; then
        mv ~/.ansible.cfg ~/dotfiles-setup-leftovers/
    fi

    mkdir -p ~/.ansible
    ln -s ~/dotfiles/.ansible.cfg
}

installKubernetes()
{
    echo -e "⌛ installing kubectl, eksctl, helm & helmdiff"
    # kubernetes
    sudo apt-get install -y bash-completion nmap apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -LOSs https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    sudo mv kubectl /usr/local/bin
    sudo chmod u+x /usr/local/bin/kubectl

    # eksctl
    curl -fsSL "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    sudo chmod u+x /usr/local/bin/eksctl

    # helm
    curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/linux-amd64/helm /usr/local/bin
    sudo chmod u+x /usr/local/bin/helm

    # helm diff
    helm plugin install https://github.com/databus23/helm-diff --version "v${HELMDIFF_VERSION}"

    # helmfile
    curl -LOSs "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64"
    sudo mv helmfile_linux_amd64 /usr/local/bin/helmfile
    sudo chmod u+x /usr/local/bin/helmfile

    # stern
    curl -LOSs "https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64"
    sudo mv stern_linux_amd64 /usr/local/bin/stern
    sudo chmod u+x /usr/local/bin/stern
}

installDocker()
{
    echo -e "⌛ installing docker & docker compose"
    # docker
    sudo apt-get install -y apt-transport-https ca-certificates software-properties-common curl gnupg-agent
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER

    # docker compose
    sudo curl -fsSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

installTmux()
{
    echo -e "⌛ installing tmux"
    # tmux
    if [[ -x "$(command -v apt-get)" ]]; then
        sudo apt-get install -yq tmux
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install -yq tmux
    fi

    if [[ -e "~/.tmux.conf" ]]; then
        mv ~/.tmux.conf ~/dotfiles-setup-leftovers/
    fi

    cd
    mkdir -p ~/.tmux/plugins
    ln -s dotfiles/.tmux.conf

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

installWSL()
{
    if [[ -e "/etc/wsl.conf" ]]; then
        sudo mv /etc/wsl.conf ~/dotfiles-setup-leftovers/
    fi

    sudo ln -s "$HOME/dotfiles/wsl.conf" /etc/wsl.conf
}

main()
{
    sudo -k
    sudo true

    if [[ $? -ne 0 ]]; then
        echo "💣 sudo permissions required to proceed, aborting"
    fi

    cd
    sudo apt-get update -y
    sudo apt-get install curl
    mkdir -p dotfiles-setup-leftovers

    if [[ ! -z "$INSTALL_DOTFILES" ]]; then
        installGit
        installVim
    fi

    if [[ ! -z "$INSTALL_NODENV" ]]; then
        installNode
    fi

    if [[ ! -z "$INSTALL_PYENV" ]]; then
        installPython
    fi

    if [[ ! -z "$INSTALL_ANSIBLE" ]] || [[ ! -z "$INSTALL_SAMCLI" ]] || [[ ! -z "$INSTALL_DOTFILES" ]]; then
        installHomebrew
    fi

    if [[ ! -z "$INSTALL_DOTFILES" ]]; then
        installGitFlow
    fi

    if [[ ! -z "$INSTALL_AWSCLI" ]]; then
        installAWSCLI
    fi

    if [[ ! -z "$INSTALL_SAMCLI" ]]; then
        installSAMCLI
    fi

    if [[ ! -z "$INSTALL_ANSIBLE" ]]; then
        installAnsible
    fi

    if [[ ! -z "$INSTALL_DOCKER" ]]; then
        installDocker
    fi

    if [[ ! -z "$INSTALL_KUBE" ]]; then
        installKubernetes
    fi

    if [[ ! -z "$INSTALL_TMUX" ]]; then
        installTmux
    fi

    if [[ ! -z "$INSTALL_WSL" ]]; then
        installWSL
    fi

    if [[ ! -z "$INSTALL_ZSH" ]]; then
        installZsh
    fi
}

init
main
