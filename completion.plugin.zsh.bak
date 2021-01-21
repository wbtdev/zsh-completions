# Copyright (c) 2020 Brad Thorne

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

fpath+="${0:h}/src"

# Return if requirements are not found.
if [[ "$TERM" == 'dumb' ]]; then
  return 1
fi

# Set options
setopt no_complete_in_word    # Complete from both ends of a word.
setopt always_to_end       # Move cursor to the end of a completed word.
setopt path_dirs           # Perform path search even on command names with slashes.
setopt no_case_glob        # Make globbing case insensitive.
setopt no_list_beep        # Don't beep on ambiguous completions.
setopt auto_menu           # Show completion menu on a successive tab press.
setopt auto_list           # Automatically list choices on ambiguous completion.
setopt auto_param_slash    # If completed parameter is a directory, add a trailing slash.
setopt extended_glob       # Needed for file modification glob modifiers with compinit
setopt no_menu_complete     # Do not autoselect the first completion entry.
setopt no_flow_control      # Disable start/stop characters in shell editor.

#
# Styles
#

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt no_case_glob              # Use Case-Insensitve Globbing.
setopt globdots                 # Glob Dotfiles As Well.
setopt extendedglob             # Use Extended Globbing.

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' rehash true

# Fuzzy match mistyped completions.
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:' verbose false

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections   true
zstyle ':completion:*:man:*' menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path $path

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# run rehash on completion so new installed program are found automatically:
_force_rehash () {
  (( CURRENT == 1 )) && rehash
  return 1
}

# try to be smart about when to use what completer...
WORDCHARS=${WORDCHARS//[\/]}
setopt correct
zstyle -e ':completion:*' completer '
  if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
    _last_try="$HISTNO$BUFFER$CURSOR"
    reply=(_complete _match _ignored _prefix _files)
  else
    if [[ $words[1] == (rm|mv) ]] ; then
      reply=(_complete _files)
    else
      reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
    fi
  fi'

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

zstyle :compinstall filename "$HOME/.zshrc"
