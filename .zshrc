setopt hist_ignore_all_dups
setopt hist_ignore_space

HISTFILE=$HOME/.histfile
HISTSIZE=99999999
SAVEHIST=$HISTSIZE

bindkey -v

autoload -Uz compinit
compinit

autoload -U promptinit
promptinit

setopt correctall

alias l='ls --color=none --group-directories-first'
alias la='l -al'
alias ..='c ..'

alias pp='ping 1.1'
alias -g @@='torify'

alias _='sudo'
alias sx='startx -- vt1'
alias xclip="xclip -selection clipboard"

if [[ $(uname -rv) =~ .*gentoo.* ]]; then
    alias es='emerge -s'
    alias ea='_ emerge -av'
else
    alias es='apt-cache search'
    alias ea='_ apt-get install'
fi

alias -g '.G'='| grep'
alias -g '.T'='2>&1 | tail'
alias -g '.L'='2>&1 | less -FXS'
alias -g '.H'='2>&1 | head'
alias -g '.A'='| awk'
alias -g '.D'='2>&1 > /dev/null'
alias -g '.J'='| python -m json.tool'
alias -g '.X'='| xclip'

v () {
    if [[ $EDITOR == "emacsclient" ]]; then
        bspc desktop -f '^1'
        emacsclient -nq $* 1> /dev/null
    else
        $EDITOR $*
    fi
}

alias vzc='v ~/.zshrc'
alias vsc='v ~/.config/sxhkd/sxhkdrc'
alias vs='_ vim'
alias vrc='vs /etc/resolv.conf'
alias vmc='vs /etc/portage/make.conf'
alias vuc='vs /etc/portage/package.use'
alias voc='vs /etc/openvpn/openvpn.conf'
alias jl='julia --banner=no --startup-file=no'
alias jlp='julia --startup-file=no --banner=no --project'
alias py='python3.8'
alias nsight="_ ~/pacs/nsight/nv-nsight-cu"

pi () {
    dir=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    mkdir -p /tmp/$dir && cd $_
    py -m pip $*
    cd -
}

c () {cd $1 && echo -- $(pwd) -- && l}

cb () {cd - && echo -- $(pwd) -- && l}

s () {l -la | grep $1}

t () {termite $* &}

shi () {cat ~/.histfile | grep $*}

p () {ps ax | grep $* | head -1}

zzz () {
    emacsclient -ne "(org-clock-out)"
    emacsclient -ne "(save-buffers-kill-emacs t)"

    _ shutdown -h $1 now
}

cu () {
    curl $*
}

sr () {
    _ rc-service $1 restart
}

si () {
    rc-service $1 status
}

ss () {
   case $(rc-service $1 status|awk '{print $3}') in
      stopped)
         _ rc-service $1 start;;
      *)
         _ rc-service $1 stop
   esac
}

ap () {
   echo path+=$(pwd) >> $HOME/.zshenv
}

apt () {
   export PATH=$(pwd):$PATH
}

erase () { cat /dev/null > $1 }

fat () {
   du -h | sort -h
}

wttr () {
   cu https://wttr.in/Lviv --silent | head -n 37 | tail -n 30
   cu https://wttr.in/Moon --silent | head -n 23
}

cheat () {
   cu "https://cheat.sh/$*"
}

savepage() {
    wget \
        --recursive \
        --no-clobber \
        --page-requisites \
        --html-extension \
        --convert-links \
        --restrict-file-names=windows \
        --no-parent \
        $*
}

json () {
   curl -H 'Content-Type: application/json' --data-binary $*
}

paper () {
    cu -L -H "User-Agent:""$UA"";" "$1" -s -o ~/shel/${1##*/}
    echo -n ${1##*/}
}

jp () {
   export PYTHONPATH=`pwd`

   echo '{"cells": [],"metadata": {},"nbformat": 4,"nbformat_minor": 2}' > stash.ipynb

   if [ -d ".venv" ]; then
       PYTHONPATH=$(pwd) pipenv run ./.venv/bin/jupyter notebook --no-browser
   else
      jupyter notebook --no-browser
   fi

   rm stash.ipynb
}

lk () {
   i3lock -i ~/asts/black.png -p win
}

emergeworld() {
   _ emerge -av --update --newuse --deep --changed-use --with-bdeps=y --backtrack=103 --verbose-conflicts @world
}

rekey () {
   setxkbmap -option "caps:swapescape"
   xset r rate 200 100
}

sensmo() {
   xinput set-prop $1 154 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
}

joke() {
	 cat /sys/class/power_supply/BAT0/capacity
}

bright() {
   vs /sys/class/backlight/intel_backlight/brightness
}

eval `keychain --quiet --eval --agents ssh $HUBLET`

xela() {
    nodemon $1 -x "xelatex -shell-escape -8bit -interaction nonstopmode $1"
}

unixify() {
    find . -type f -exec perl -pi -e 's/\r\n/\n/g' {} \;
}

pii () {
    pi install --user $*
}

getem () {
    youtube-dl "$1" -f bestvideo+bestaudio -o $2
}

fill () {
    jl ~/iros/muses/filling.jl $*
}

split () {
    spleeter separate -p ~/pacs/spleeter/spleeter/resources/$2stems.json -i $1 -o .
}

iiwpa() {
    _ pkill wpa_supplicant
    _ wpa_supplicant -iwlo1 -Dnl80211 -B -d -c /etc/wpa_supplicant/wpa_supplicant.conf
    _ wpa_cli -i wlo1
}

sleeping() {
    while true; do nvidia-smi; sleep 1; done
}

echo $METAX[$((${RANDOM:0:1} % ${#METAX} + 1))]
