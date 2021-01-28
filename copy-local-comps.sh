#!/usr/bin/env zsh

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_copy() {
  local comp target="${1}"
  for comp in $target/*; do
    # echo "${0:h}/src"
    cp "$comp" "${0:h}/src"
  done
}

_copy /usr/local/share/zsh/site-functions
