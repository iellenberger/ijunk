# --- system-wide bash script ---
source /etc/bashrc

# --- bash aliases and user configs ---
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.bash_user ]; then
    . ~/.bash_user
fi
