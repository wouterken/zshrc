##
# LOAD COLORS
##

# Setup zsh-autosuggestions
export TERM="xterm-256color"

function next_line(){
  if [[ -z $BUFFER ]]; then
    echo "$fg_bold[cyan]($fg_bold[red]...$fg_bold[cyan])$reset_color"
    echo "\n"
  else
    zle kill-buffer
  fi
  zle redisplay >> /dev/null 2>&1
}

function exists {
  which $1 &> /dev/null
}

function separately {
  $@ &
}

function quietly {
  $@ &> /dev/null &
}

function daemonize {
  nohup $@ &> /dev/null &
}

zle -N next_line
trap next_line INT


if [ -z $SSH_AUTH_SOCK ]
    then
    echo "Starting $fg_bold[green]ssh-agent$reset_color"
    eval `ssh-agent`
    ssh-add
fi
ssh-add >> /dev/null 2>&1

if exists fasd; then eval "$(fasd --init auto)"; fi
if exists rbenv; then eval "$(rbenv init - --no-rehash)"; fi


#Options
setopt histignoredups
setopt correct

#Path
export RBENV_ROOT=/Users/woutercoppieters/.rbenv
export SCALA_HOME="/usr/local/share/scala-2.11.4"
export PATH="/Users/woutercoppieters/.rbenv/shims:\
$HOME/.rbenv/bin\
:$PATH\
:/usr/local/sbin\
:/Users/woutercoppieters/.rbenv/bin\
:/Development/golang/bin\
:/Applications/Adobe Flash Builder 4.6/sdks/3.6.0/bin\
:/usr/local/opt/mosquitto/sbin\
:$PATH:$SCALA_HOME/bin\
:/usr/local/scipt/scipoptsuite-3.1.0/scip-3.1.0/bin\
:/usr/local/coin-Cbc/bin\
:/usr/local/Cellar/elasticsearch/bin\
:/usr/local/Cellar/nim-0.10.2/bin\
:/Applications/Minecraft Server\
:/usr/local/heroku/bin\
:/Applications/GAMS/gams24.4_osx_x64_64_sfx"

export EDITOR="subl -w"
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_GC_HEAP_FREE_SLOTS=500000
export RUBY_GC_HEAP_INIT_SLOTS=40000
export DESK=/Users/woutercoppieters/Desktop
export MAIL_SENDER='wouter@littlecoder.com'
export LC_ALL=en_US.UTF-8
export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '
export COMPLETION_WAITING_DOTS=false

#ZSH
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# # Set name of the theme to load.
# # Look in ~/.oh-my-zsh/themes/
# # Optionally, if you set this to "random", it'll load a random theme each
# # time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}XX %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

plugins=(git ruby osx python rails rake-fast postgres gem bundler brew themes sudo encode64 rand-quote sublime sudo battery colored-man emoji-clock nyan)
source $ZSH/oh-my-zsh.sh


#Aliases
alias reveal="open -R"
alias relocate='sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist'
alias profile="edit ~/.zshrc"
alias hosts="sudo edit /etc/hosts"
alias reload="source ~/.zshrc"
alias ip='ipconfig getifaddr en0; ipconfig getifaddr en1'
alias ipext="curl -s http://checkip.dyndns.org/ | grep -o '[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9]*'"
alias srlua="/usr/local/lib/srlua/glue /usr/local/lib/srlua/srlua"
alias glog="git log --pretty=format:\"%ar - %an, %h %s\""
alias ls="ls -1abCeGLopTlh"
alias bolt="rm .zeus.sock 2>/dev/null; zeus start > /dev/null 2>&1 &"
alias rc="bundle exec rails console"
alias app="open -a"
alias duf='du -sk ./* | sort --n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'''
alias running='ps -ax | grep '
alias irb="pry"
alias edit="subl -s -b"
##
# Functions
##
#
function starwars(){
  telnet towel.blinkenlights.nl
}

function whoson(){
    lsof -iTCP:$1
}

function tree(){
    find ./ -type d -print | grep -v "^\.//\." | sed -e 's;[^/]*/; /;g;s;/ ;    ;g;s;^ /$;.;;s; /;|-- ;g'
}

function leave_my_port_alone(){
    IFS=$'\n'
    whoson $1| awk 'FNR != 1 {print $2}' | read -d -a all_pids
    sorted=( $(
        for el in "${all_pids[@]}"
        do
            echo "$el"
        done | sort -u) )
    for i in "${sorted[@]}"
    do
       kill -9 $i 2>/dev/null
    done
}

function pdfman () {
    man -t "${1}" | open -f -a /Applications/Preview.app/
}

function ip2loc () {
        wget -qO - www.ip2location.com/$1 | grep "<span id=\"dgLookup__ctl2_lblICountry\">" | sed 's/<[^>]*>//g; s/^[\t]*//; s/&quot;/"/g; s/</</g; s/>/>/g; s/&amp;/\&/g';
}

function mdd (){
    qlmanage -p $1 -o . >> /dev/null
    a="$1.qlpreview"
    b="./$1.qlpreview/Preview.html"
    c="${1%.*}.pdf"
    wkhtmltopdf --quiet $b $c >> /dev/null
    rm -rf $a
    open $c
}

function swap()
{
  tmpfile=$(mktemp $(dirname "$1")/XXXXXX)
  mv "$1" "$tmpfile" && mv "$2" "$1" &&  mv "$tmpfile" "$2"
}

function ql()
{
    qlmanage -p "$1" 2> /dev/null 1> /dev/null
}

function fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    bg
    zle redisplay
  else
    zle push-input
  fi
}

function server(){
    servpath=`pwd`
    dirname=`basename ${servpath}`
    ln -s `pwd` "/Applications/MAMP/htdocs/${dirname}"
    open "http://localhost/${dirname}"
}

function help()
{
    sh -c "help ${1}"
}


function tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}
function  tab-reset() {
    echo -ne "\033]6;1;bg;*;default\a"
}

function  color-ssh() {
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        trap "tab-reset" INT EXIT
        if [[ "$*" =~ "production|ec2-.*compute-1" ]]; then
            tab-color 255 0 0
        else
            tab-color 255 0 0
        fi
    fi
    ssh $*
}

function extract {
  echo Extracting $1 ...
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xjf $1  ;;
          *.tar.gz)    tar xzf $1  ;;
          *.bz2)       bunzip2 $1  ;;
          *.rar)       unrar x $1    ;;
          *.gz)        gunzip $1   ;;
          *.tar)       tar xf $1   ;;
          *.tbz2)      tar xjf $1  ;;
          *.tgz)       tar xzf $1  ;;
          *.zip)       unzip $1   ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1  ;;
          *)        echo "'$1' cannot be extracted via extract()" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}


# Detect empty enter, execute git status if in git dir
function magic-enter () {
        if [[ -z $BUFFER ]]; then
          if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            echo -ne '\n'
            git status
            zle accept-line
          else
            zle kill-buffer
          fi
        else
          zle accept-line
        fi
}

function clear-screen (){
  clear
  zle redisplay >> /dev/null 2>&1
}

zle -N magic-enter
bindkey "^M" magic-enter

zle -N clear-screen
bindkey "^K" clear-screen

source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#Initializations

echo "Initializing $fg_bold[green]golang$reset_color"
export GOPATH=/Development/golang

clear
echo "Logged in: \n$fg_bold[yellow]`who`$reset_color"

wisdom(){
  fortune | cowsay -f `ruby -e "puts %w(beavis.zen bong bud-frogs bunny cheese cower daemon default dragon dragon-and-cow elephant elephant-in-snake eyes flaming-sheep ghostbusters head-in hellokitty kiss kitty koala kosh luke-koala meow milk moofasa moose mutilated ren satanic sheep skeleton small sodomized stegosaurus stimpy supermilker surgery telebears three-eyes turkey turtle tux udder vader vader-koala www).sample"`
}

compdef _ssh color-ssh=ssh
alias ssh=color-ssh
autoload -U colors && colors
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
clear
echo "Welcome $fg_bold[red]$USER$reset_color : $fg_bold[cyan]`hostname`$reset_color $fg_bold[magenta]"`ipconfig getifaddr en0`$reset_color "$fg_bold[green]["`sw_vers -productName`"@"`sw_vers -productVersion`" | `uname -smr`]$reset_color"
printf $fg_bold[yellow]
printf `df -hl | grep 'disk1' | awk '{print $4"/"$2" free ("$5" used)"}'`
echo $reset_color

wisdom

dotenv () {
  git status 2>/dev/null
}

bold()          { ansi 1 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }
strikethrough() { ansi 9 "$@"; }
red()           { ansi 31 "$@"; }
ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }

settheme() {
  ZSH_THEME="$@"
  source $ZSH/oh-my-zsh.sh
}


chpwd_functions=(dotenv)
unalias heroku
unalias sl

PERL_MB_OPT="--install_base \"/Users/woutercoppieters/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/woutercoppieters/perl5"; export PERL_MM_OPT;
