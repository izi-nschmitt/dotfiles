# DOT Files

Fichiers de configuration pour les variables d'environnement, le prompt bash, git, vi et npm

## Installation

```bash
cd ~
git clone git@github.com:izi-nschmitt/dotfiles.git
# puis créer des liens symboliques vers tous les fichiers que vous souhaitez utiliser
ln -s dotfiles/.ansible.cfg
ln -s dotfiles/.gitconfig
ln -s dotfiles/.p10k.zsh
ln -s dotfiles/.vim
ln -s dotfiles/.vimrc
ln -s dotfiles/.zshrc
```

## Rôle de chaque fichier

### Bash

- **bash_profile** : fichier pilote du bash, permet simplement de charger les autres .bash\_\*
- **bash_aliases** : contient des alias standards, des raccourcis, des connexions ssh...
- **bash_env** : contient les variables d'environnement
- **bash_prompt** : contient toutes les règles d'affichage (branche git, couleurs...)
- **bash_functions** : contient des fonctions custom (screen, mkdir + cd ...)
- **bash_user** : fichier ignoré et importé, pour toutes les surcharges utilisateur

### ZSH

- **locales** : impose en_US.UTF-8 en locale. Nécessaire au bon fonctionnement des fonts type powerline sur linux
- **zshrc** : config zsh

### GIT

- le fichier .gitconfig ne doit pas être changé directement, à la place vous pouvez placer vos modifications dans le fichier `dotfiles/.gitconfig_user` (typiquement user.email et user.name)

### Environnement

- les fichiers de bashrc.d ne doivent pas être changés directement, à la place vous pouvez placer vos modifications dans le fichier `dotfiles/bashrc.d/bash_user`. Il sourcé en dernier pour vous donner la possibilité d'écraser n'importe quelle modification apportée par les fichiers précédent (ex, re definir $PATH).

### VIM

- **.vimrc** : customisation du comportement (exemple : la touche F2 permet d'afficher/masquer les numéros de ligne) et choix du thème VIM
- **.vim** : dossier contenant des thèmes pour VIM (darcula, monokai)

### .inputrc

> utile uniquement sur bash

Permet de modifier le comportement du terminal lorsque vous écrivez une commande. Celui-ci vous permet de modifier le comportement des flêches haut/bas afin de rechercher dans l'historique les commandes correspondant à votre commande en cours. Il permet également d'utiliser ctrl+fleche gauche/droite afin de passer de mot en mot sur la commande en cours de saisie.

### .npmrc

configuration du scope @iziwork

## Outils tierces

### Oh my zsh

- Utilité: Framework de configuration pour zsh
- Source: [https://ohmyz.sh/](https://ohmyz.sh)
- Installation:

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Powerlevel10k

- Utilité: Thème zsh
- Source: [Github](https://github.com/romkatv/powerlevel10k)
- Installation:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Nodenv

- Utilité: Gestion de versions concurrentes de node.js
- Source: [Github](https://github.com/nodenv/nodenv)
- Installation:

```bash
brew install nodenv nodenv-update nodenv-package-rehash nodenv-package-json-engine
```

Ajouter '~/.nodenv/bin' au $PATH (c'est déjà le cas si bashrc.d/.bash_env est chargé). Sinon:

```bash
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
```

Enfin

```bash
~/.nodenv/bin/nodenv init
```

### Pyenv

- Utilité: Gestion de versions concurrentes de python
- Source: [Github](https://github.com/pyenv/pyenv)
- Installation:

```bash
brew install pyenv
```

Ajouter '~/.pyenv/bin' au $PATH (c'est déjà le cas si bashrc.d/.bash_env est chargé). Sinon:

```bash
export PATH="$HOME/.pyenv/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

#### Création d'un environnement

```bash
cd
pyenv install 3.7.2
pyenv virtualenv 3.7.2 default
pyenv global default
```

### AWS

- Utilité: CLI AWS
- Source: [Documentation AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
- Installation:

```bash
# aws
brew install awscli
```
