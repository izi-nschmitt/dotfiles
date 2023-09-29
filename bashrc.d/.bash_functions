#!/usr/bin/env bash

function mkcdir() {
    mkdir -p "$@" && cd "$@"
}

function mvg() {
    mv $1 $2 && cd $2
}

# Usage : replace "string_old" "string_new" /home/users/me/test
# Recursively replace string_old by string_new in given directory and subs
function replace() {
    cyan=$(tput setaf 37)
    green=$(tput setaf 77)
    white=$(tput setaf 15)
    old=$1
    new=$2
    old_esc="$(echo "$old" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
    new_esc="$(echo "$new" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
    dir=$(dirname "$3")
    echo "Replacing $cyan$old$white by $cyan$new$white in directory $cyan$dir$white ..."
    grep -rli "$old" * | xargs -i@ sed -i "s/$old_esc/$new_esc/g" @
    echo "$green"
    echo "Done"
}

function quickdiff() {
    from=${1:-master}
    to=${2:-develop}
    ls | xargs -n 1 -I {} bash -c "cd {}; echo ''; echo ''; echo '--- {} ---'; git --no-pager log $from..$to --pretty=format:'%h : %s' --graph; cd ..;"
}

function lastversion() {
    ls | xargs -n 1 -I {} bash -c "cd {}; echo '--- {} ---'; git tag -l $1*; cd ..;"
}

function getAnsiblePasswordHash() {
    MSG="msg={{ '"
    MSG+=$1
    MSG+="' | password_hash('sha512', 'kouignamannaubeursale') }}"

    ansible localhost, -m debug -a "$MSG"
}

function updateAwsCliForLinux() {
    setupdir=$(mktemp -d)
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "${setupdir}/awscliv2.zip"
    unzip "${setupdir}/awscliv2.zip" -d "$setupdir"
    sudo "${setupdir}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    rm -rf "$setupdir"
}

function patchMolecule() {
    molVersion=$(brew info --installed --json | jq -r '.[] | select(.name == "molecule") | .versions.stable')
    cd "/home/linuxbrew/.linuxbrew/Cellar/molecule/$molVersion"
    libexec/bin/pip uninstall docker-py
    libexec/bin/pip install molecule-docker --prefix libexec
    cd -
}

function createpr() {
    base="${1:-develop}"
    reviewers="${2:-$GH_DEFAULT_TEAM}"

    gh pr create --title "$(git rev-parse --abbrev-ref HEAD)" --body "" --base "$base" --reviewer "$reviewers"
}

function get_tf_user() {
    user=$(terraform output -json | jq -r --arg app "$1" '.[$app].value')
    key_id="$(echo "$user" | jq -r '.user_ak')"
    secret="$(echo "$user" | jq -r '.user_sk' | base64 -d | gpg --decrypt -q)"

    echo "AWS_ACCESS_KEY_ID=$key_id"
    echo "AWS_SECRET_ACCESS_KEY=$secret"
}

function get_cs_user() {
    user=$(terraform output -json | jq -r --arg app "$1_cs" --arg comp "$2" '.[$app].value[$comp]')
    key_id="$(echo "$user" | jq -r '.user_ak')"
    secret="$(echo "$user" | jq -r '.user_sk' | base64 -d | gpg --decrypt -q)"

    echo "AWS_ACCESS_KEY_ID=$key_id"
    echo "AWS_SECRET_ACCESS_KEY=$secret"
}

function create_tf_module() {
  mkdir -p "$1"
  touch "./$1/main.tf" "./$1/outputs.tf" "./$1/variables.tf"
}

function validate_tf_init() {
  if [ ! -f ".terraform/terraform.tfstate" ]; then
    return 0
  fi

  state_key="$(jq -r '.backend.config.key | split("/") | last' .terraform/terraform.tfstate)"

  if [ "$state_key" != "$1.json" ]; then
    echo "Terraform is not initialized with the current environment"
    return 1
  fi

  return 0
}

function get_gcloud_config() {
  gcloud config get "$1" 2>/dev/null
}

function export_common_gcp_envrc() {
  export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="$(get_gcloud_config 'auth/impersonate_service_account')"
}

function export_common_tf_cli_args() {
  export TF_VAR_assume_deployment_role=false
  export TF_CLI_ARGS_init="-backend-config=backend-$1.hcl -backend-config=profile=${2:-sre-prod}"
  export TF_CLI_ARGS_plan="-var-file=$1.tfvars"
  export TF_CLI_ARGS_apply="-var-file=$1.tfvars"
  export TF_CLI_ARGS_import="-var-file=$1.tfvars"
  export TF_CLI_ARGS_destroy="-var-file=$1.tfvars"
  export TF_CLI_ARGS_console="-var-file=$1.tfvars"
}

function common_tf_envrc() {
  export_common_tf_cli_args "$1" "$2"

  if ! validate_tf_init "$1"; then
    rm .terraform/terraform.tfstate
    terraform init
  fi
}

function common_gcp_envrc() {
  export_common_gcp_envrc
}

function wait_port() {
  while ! nc "$1" "$2"; do
    echo -n "."
    sleep 1
  done
}
