#!/usr/bin/env bash
# Status line derived from the colored bash PS1 in ~/.bashrc:
#   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

chroot_prefix=""
if [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
  [ -n "$debian_chroot" ] && chroot_prefix="($debian_chroot)"
fi

printf '%s\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' \
  "$chroot_prefix" "$(whoami)" "$(hostname -s)" "$cwd"

# Context window usage, styled after the truecolor palette + bracketed
# segment style used in ~/.config/starship.toml (palette.foo: almond
# #eaddca / brass #e1c16e, plus a warning red akin to the character
# module's bold-red error_symbol).
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  if [ "$used_int" -ge 80 ]; then
    ctx_color='38;2;224;108;117' # warning red
  elif [ "$used_int" -ge 50 ]; then
    ctx_color='38;2;225;193;110' # brass
  else
    ctx_color='38;2;234;221;202' # almond
  fi
  printf ' \033[%sm[ctx %s%%]\033[00m' "$ctx_color" "$used_int"
fi
