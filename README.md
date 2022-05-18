# DOT Files

Fichiers de configuration pour les variables d'environnement, le prompt bash, git, vi et npm

## Installation

```bash
cd ~
git clone git@github.com:izi-nschmitt/dotfiles.git
#puis l'un des scripts d'install. ex:
./dotfiles/install/zsh.sh
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

- **locales** : impose en_US.UTF-8 en locale. Nécessaire au bon fonctionnement des fonts type powerline.
- **zshrc** : config zsh
- **zshrc-default** : .zshrc original

### GIT

- le fichier .gitconfig ne doit pas être changé directement, à la place vous pouvez placer vos modifications dans le fichier `dotfiles/.gitconfig_user` (typiquement user.email et user.name)

### Environnement

- les fichiers de bashrc.d ne doivent pas être changés directement, à la place vous pouvez placer vos modifications dans le fichier `dotfiles/bashrc.d/bash_user`. Il sourcé en dernier pour vous donner la possibilité d'écraser n'importe quelle modification apportée par les fichiers précédent (ex, re definir $PATH).

### VIM

- **.vimrc** : customisation du comportement (exemple : la touche F2 permet d'afficher/masquer les numéros de ligne) et choix du thème VIM
- **.vim** : dossier contenant des thèmes pour VIM (darcula, monokai)

### .inputrc

Permet de modifier le comportement du terminal lorsque vous écrivez une commande. Celui-ci vous permet de modifier le comportement des flêches haut/bas afin de rechercher dans l'historique les commandes correspondant à votre commande en cours. Il permet également d'utiliser ctrl+fleche gauche/droite afin de passer de mot en mot sur la commande en cours de saisie.

### .npmrc

proxy pour npm & change le path d'installation des modules globaux

## Outils tierces

### Oh my zsh

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

### Nodenv

Utilité: Gestion de versions concurrentes de node.js
Source: [https://github.com/nodenv/nodenv](Github)

#### Installation

```bash
git clone https://github.com/nodenv/nodenv.git ~/.nodenv;
cd ~/.nodenv && src/configure && make -C src;
mkdir -p plugins;
git clone https://github.com/nodenv/node-build.git plugins/node-build;
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

Utilité: Gestion de versions concurrentes de python
Source: [https://github.com/pyenv/pyenv](Github)

#### Installation

Chaque version de pyhton téléchargée est ensuite compilée. L'installation nécessite donc certaines dépendances sytème.

```bash
sudo apt-get install -y build-essential libbz2-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev tk-dev
```

Installer de pyenv

```
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
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

### Docker

#### Installation

```bash
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install docker-ce
```

### Kubernetes

#### Installation

Dans Docker Desktop, activer Kubernetes. Puis:

```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl

ln -s /c/Users/{YourUsername}/.kube/config ~/.kube/config
```

### AWS

### Installation

```bash
# aws
pip install awscli
# sam
pip install aws-sam-cli
# ecs
sudo curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli
# eks
sudo curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
sudo chmod +x /usr/local/bin/aws-iam-authenticator
```

> Note sur EKS: par défaut, seul le créateur du cluster dispose d'un accès admin. Il est donc fortement probable qu'il soit nécessaire de se connecter via un rôle. Auquel cas, la section _users_ du .kube/config devra être modifiée.

### Configuration

```bash
ecs-cli configure profile --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY
```

### Redis

```bash
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
tar xzf redis-5.0.4.tar.gz
cd redis-5.0.4
make
sudo mkdir -p /usr/local/src/redis-5.0.4
sudo mv ./* /usr/local/src/redis-5.0.4
cd /usr/local/bin
sudo ln -s ../src/redis-5.0.4/redis-cli
sudo ln -s ../src/redis-5.0.4/redis-server
sudo ln -s ../src/redis-5.0.4/redis-sentinel

```
