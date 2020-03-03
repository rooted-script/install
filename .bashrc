# History control
# its all about tomnomnom && nahamsec && parrotsec 
#i am just modified it for me . :"D
#
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s histappend

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

alias grep='grep --color=auto'
alias gg='git grep -ni'
alias phpunit='phpunit --colors'
alias vimpress="VIMENV=talk vim"
alias c="composer"
alias v="vagrant"
alias d="sudo docker"
alias biggest="du -h --max-depth=1 | sort -h"
alias tnn="cd ~/src/github.com/tomnomnom"
alias :q="exit"
alias norg="gron --ungron"
alias ungron="gron --ungron"

# COLOURS! YAAAY!
export TERM=xterm-256color

# Obviously.
export EDITOR=/usr/bin/vim

# Personal binaries
export PATH=${PATH}:~/bin:~/.local/bin:~/etc/scripts

# I'd quite like for Go to work please.
export PATH=${PATH}:/usr/local/go/bin
export GOPATH=~


# Change up a variable number of directories
# E.g:
#   cu   -> cd ../
#   cu 2 -> cd ../../
#   cu 3 -> cd ../../../
function cu {
    local count=$1
    if [ -z "${count}" ]; then
        count=1
    fi
    local path=""
    for i in $(seq 1 ${count}); do
        path="${path}../"
    done
    cd $path
}


# Open all modified files in vim tabs
function vimod {
    vim -p $(git status -suall | awk '{print $2}')
}

# Open files modified in a git commit in vim tabs; defaults to HEAD. Pop it in your .bashrc
# Examples:
#     virev 49808d5
#     virev HEAD~3
function virev {
    commit=$1
    if [ -z "${commit}" ]; then
      commit="HEAD"
    fi
    rootdir=$(git rev-parse --show-toplevel)
    sourceFiles=$(git show --name-only --pretty="format:" ${commit} | grep -v '^$')
    toOpen=""
    for file in ${sourceFiles}; do
      file="${rootdir}/${file}"
      if [ -e "${file}" ]; then
        toOpen="${toOpen} ${file}"
      fi
    done
    if [ -z "${toOpen}" ]; then
      echo "No files were modified in ${commit}"
      return 1
    fi
    vim -p ${toOpen}
}

# 'Safe' version of __git_ps1 to avoid errors on systems that don't have it
function gitPrompt {
  command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}
## extra tools 
hgrip(){ 
history | grep $1
}

#----- AWS -------

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

#----- misc -----
certspotter(){
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?q=%.$1  | sed 's/<\/\?[^>]\+>//g' | grep $1
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma

certbrute(){
cat $1.txt | while read line; do python3 dirsearch.py -e . -u "https://$line"; done
}

ipinfo(){
curl http://ipinfo.io/$1
}
deadlink() {
        # copyright 2007 - 2010 Christopher Bratusek
        find -L -type l
}
# about files depending on the available space
function lls() {
        # count files
        echo -n "<`find . -maxdepth 1 -mindepth 1 -type f | wc -l | tr -d '[:space:]'` files>"
        # count sub-directories
        echo -n " <`find . -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d '[:space:]'` dirs/>"
        # count links
        echo -n " <`find . -maxdepth 1 -mindepth 1 -type l | wc -l | tr -d '[:space:]'` links@>"
        # total disk space used by this directory and all subdirectories
        echo " <~`du -sh . 2> /dev/null | cut -f1`>"
        ROWS=`stty size | cut -d' ' -f1`
        FILES=`find . -maxdepth 1 -mindepth 1 |
        wc -l | tr -d '[:space:]'`
        # if the terminal has enough lines, do a long listing
        if [ `expr "${ROWS}" - 6` -lt "${FILES}" ]; then
                ls
        else
                ls -hlAF --full-time
        fi
}

##################################################
# Mailme                                         #
##################################################
 
function mailme()
{
        echo "$@" | mail -s "$1" $SERVERMAIL
}



#------ Tools ------
dirsearch(){
cd /opt/dirsearch*
python3 dirsearch.py -e . -u $1
}

sqlmap(){
sqlmap -u $1 
}

knock(){
cd /home/tools/knock/knockpy
python knockpy.py -w list.txt $1
}

ncx(){
nc -l -n -vv -p $1 -k
}
ffufd(){
ffuf -w /usr/share/wordlists/dirb/big.txt -u https://$1/FUZZ -mc all -fs 42 -c -o dirs.txt
}
li-of-ho(){
sed 's#^#http://#g' list-of-hosts > output
}

# Colours have names too. Stolen from Arch wiki
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

# Prompt colours
atC="${txtpur}"
nameC="${txtpur}"
hostC="${txtpur}"
pathC="${txtgrn}"
gitC="${txtpur}"
pointerC="${txtgrn}"
normalC="${txtwht}"


# Patent Pending Prompt

# Local settings go last
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:/snap/bin:$PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\]"
PS1='\[\033[1;30m\][\[\033[0;37m\]${PIPESTATUS}\[\033[1;30m\]:\[\033[0;37m\]${SHLVL}\[\033[1;30m\]:\[\033[0;37m\]\j\[\033[1;30m\]][\[\033[1;34m\]\u\[\033[0;34m\]@\[\033[1;34m\]\h\[\033[1;30m\]:\[\033[0;37m\]`tty | sed s/\\\\\/dev\\\\\/\//g`\[\033[1;30m\]]\[\033[0;37m\][\[\033[1;37m\]\W\[\033[0;37m\]]\[\033[1;30m\] \$\[\033[00m\] '                                                                  
# grey and blue with default black output
else
    PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
fi

# Set 'man' colors
if [ "$color_prompt" = yes ]; then
        man() {
        env \
        LESS_TERMCAP_mb=$'\e[01;31m' \
        LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
        man "$@"
        }
fi

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'
alias cls='clear'
alias rsup='apt upgrade && apt upgrade -y'




# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi                                                                                                                                                                                                             
