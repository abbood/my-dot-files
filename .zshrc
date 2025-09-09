export home="/Users/abdullahbakhach"
alias sshots='cd /Users/abdullahbakhach/sshots'
alias dev="cd $home/dev"

# Load version control information

# Enable vcs_info
autoload -Uz vcs_info

# Configure vcs_info for git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Hook to update vcs_info before each prompt
precmd_vcs_info() {
    vcs_info
}
precmd_functions+=(precmd_vcs_info)

## https://superuser.com/questions/1777510/how-to-change-the-main-color-of-iterm2/1777514?noredirect=1#comment2773337_1777514
setopt PROMPT_SUBST
PROMPT='%F{#9EC084}(${vcs_info_msg_0_})%F{#b3bbc5} %1d %F{#66C2CD}λ %F{#b3bbc5}'


## Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
#

#
#autoload -Uz compinit && compinit
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH="/Users/abdullahbakhach/Downloads/google-cloud-sdk/bin:$PATH"


export PATH="/usr/local/mysql/bin:$PATH"
#alias python=/opt/homebrew/bin/python4
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$home/Library/Android/sdk/platform-tools:$PATH"
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3
export PATH="$HOME/google-cloud-sdk/bin:$PATH"
export PATH="$home/dev/shell/tmux-setup:$PATH"
export PATH="$PATH:/Users/abdullahbakhach/.local/bin"
export PATH=~/dev/go/lib/protobuf-language-server:$PATH
export NODE_PATH='/usr/local/lib/node_modules'
export PATH="~/.composer/vendor/bin:$PATH"
export PATH="$home/dev/SDK/go_appengine:$PATH"
export PATH="$home/dev/SDK/letsencrypt:$PATH"
export GOPATH="$HOME/dev/SDK/go"
export PATH="$GOPATH/bin:$PATH"
export AWS_RDS_HOME='$home/dev/SDK/RDSCli-1.19.004'
export AWS_CREDENTIAL_FILE='$home/dev/SDK/RDSCli-1.19.004/credential-file-path.txt'
export PATH="${AWS_RDS_HOME}/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"



alias vi=lvim

alias aliases="nvim --noplugin $home/.zshrc"

function refresh() { source ~/.zshrc }



## awsini aliases
export PATH=$HOME/dev/lib/flutter/bin:$PATH

alias lvimrc="lvim ~/.config/lvim/config.lua"

alias ssh-siira-staging="gcloud compute ssh --zone=us-central1-a staging-main-backend-node"
alias ssh-siira-prod="gcloud --project=linear-outcome-392912 compute ssh --zone=us-central1-a production-main-backend-node"
alias ssh-rovera-staging="gcloud --project=jovial-coral-443911-f2 compute ssh --zone=us-central1-a staging-main-backend-node"


alias bac-siira="cd /Users/abdullahbakhach/dev/js/siira-backend"


# ---- pixel shortcuts -----
export px="37261FDJG00DEZ"
px () {
    capture_screen $px $1;
}

pxx () {
    capture_screen $px $1;
    shrink_screen $1;
}
alias flutterrc="cd /Users/abdullahbakhach/dev/lib/flutter/packages/flutter_tools/gradle/src/main"


export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
alias movies="cd $home/movies"


alias aerorc="nvim --noplugin ~/.config/aerospace/aerospace.toml"
alias alarc="vi ~/.config/alacritty/alacritty.yml"

alias docs-siira="cd /Users/abdullahbakhach/Documents/Consulting/Siira"
alias docs-rovera="cd /Users/abdullahbakhach/Documents/LoboLabs/Rovera"
alias docs-drv="cd /Users/abdullahbakhach/Documents/LoboLabs/DRV"

#---
alias rg="ranger"
alias ff="ranger"

alias txrc="vi /Users/abdullahbakhach/dev/shell/tmux-setup/tx"

#--

alias mobile-siira="cd /Users/abdullahbakhach/dev/flutter/siira-mobile"

alias gsetauth-siira="gcloud config set account abakhach@siira.me"
alias gsetauth-rovera="gcloud config set account abdullah@rovera.ai"

alias gauth-clearall="gcloud auth revoke --all"

alias gauth-siira="gcloud auth login abakhach@siira.me"
alias gauth-rovera="gcloud auth login abdullah@rovera.ai"
alias gauth-awsini="gcloud auth login abdullah.bakhach@gmail.com"

alias gprojects-list="gcloud projects list"
alias gconfigs-list="gcloud config configurations list"
alias gconfigs-activate-siira="gcloud config configurations activate siira"
alias gconfigs-activate-rovera="gcloud config configurations activate rovera"

export PATH="/opt/homebrew/opt/php@8.0/bin:$PATH"

alias cm="cd /Users/abdullahbakhach/dev/shell/oclif/cloud-manager"

alias mobile-ps="cd /Users/abdullahbakhach/dev/flutter/parashute"
alias bac-ps="cd /Users/abdullahbakhach/dev/php/parashute-dashboard"
alias rovera-replit="cd /Users/abdullahbakhach/dev/js/rovera-replit"
alias ssh-siira-staging="gcloud compute ssh --zone=us-central1-a staging-main-backend-node"
alias ssh-siira-prod="gcloud --project=linear-outcome-392912 compute ssh --zone=us-central1-a production-main-backend-node"
alias ssh-rovera-staging="gcloud --project=jovial-coral-443911-f2 compute ssh --zone=us-central1-a staging-main-backend-node"
alias alacritty-remote-reset="export TERM=xterm-256color"
alias oori="cd /Users/abdullahbakhach/dev/php/oori/investor-portal"
alias bac-oori="cd /Users/abdullahbakhach/dev/js/oori-api"
alias web-oori="cd /Users/abdullahbakhach/dev/js/oori-web"


alias borders_start="brew services start borders"
alias borders_stop="brew services stop borders"

fzff() {
  local file
  file=$(fzf) && open "$file"
}

# search for and open file
zz() {
  local file
  file=$(fzf) && open "$file"
}

## search for and open location of file in finder app
oo() {
  local file
  file=$(fzf) && open -R "$file"
}

# same as above
## search for and open location of file in finder app
zo() {
  local file
  file=$(fzf) && open -R "$file"
}

## search for and copy content of file into clipboard 
cc() {
  local file
  file=$(fzf) && osascript -e "set the clipboard to POSIX file \"$(realpath "$file")\""
}

# search for and copy filename (not full path) to clipboard
nn() {
  local file
  file=$(fzf) && echo "$(basename "$file")" | pbcopy
}




#tmux 
## create new session
## usage: tmuxn <esssion_name>
function tmuxn()
{
    tmux new -s $1
}

function tmuxc()
{
    tmux new -s $1
}

## list sessions
## usage: tmuxl
function tmuxl()
{
    tmux list-sessions
}

## attach to session
## usage: tmuxa <session_name>
function tmuxa()
{
    tmux attach -t $1
}

function tmuxr()
{
    tmux rename-session $1 
}



## kill a session 
## usage: tmuxx <session_name>
function tmuxx()
{
    tmux kill-session -t $1
}

## kill a session 
## usage: tmuxd 
function tmuxd()
{
    tmux detach 
}

alias ld="adb devices"

function convert_svg() {
    rsvg-convert -h 100 $1 > $1.png
}

function convert_ico() {
    convert $1 -thumbnail 32x32 -alpha on -background none -flatten $1.png

}

function convert_md() {
    pandoc $1 -o output.docx
}

alias docs-nayla="cd /Users/abdullahbakhach/Documents/LoboLabs/Rovera/partner\ companies/nayla"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias bac-siira='cd /Users/abdullahbakhach/dev/js/siira-backend'
alias web-siira="cd /Users/abdullahbakhach/dev/js/siira-admin"
alias ai-siira="cd /Users/abdullahbakhach/dev/python/Siira"

capture_screen () {
    adb -s $1 shell screencap -p /sdcard/sshots/$2.png; 
    adb -s $1 pull /sdcard/sshots/$2.png; 
    adb -s $1 shell rm /sdcard/sshots/$2.png; 
}

px () {
    capture_screen $px $1;
}
