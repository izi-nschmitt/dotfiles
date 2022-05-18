if [ -e ~/dotfiles/bashrc.d/.bash_aliases ]; then
    . ~/dotfiles/bashrc.d/.bash_aliases
fi

if [ -e ~/dotfiles/bashrc.d/.bash_env ]; then
    . ~/dotfiles/bashrc.d/.bash_env
fi

if [ -e ~/dotfiles/bashrc.d/.bash_prompt ]; then
    . ~/dotfiles/bashrc.d/.bash_prompt
fi

if [ -e ~/dotfiles/bashrc.d/.bash_functions ]; then
    . ~/dotfiles/bashrc.d/.bash_functions
fi

if [ -e ~/dotfiles/bashrc.d/.bash_user ]; then
    . ~/dotfiles/bashrc.d/.bash_user
fi
