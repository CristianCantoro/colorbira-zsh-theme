# shellcheck disable=SC1090,SC2016,SC2148,SC2154
# ZSH Theme

function _theme() {
  unset -f _theme

  # import per-host prompt color definitions
  source "$ZSH_CUSTOM/themes/hosts.themes"

  local cc
  local aa
  local hh

  local user_symbol

  if [[ $UID -eq 0 ]]; then
    # user is root
    cc="${user_color_root}"
    aa="${at_color_root}"
    hh="${host_color_root}"

    if [ -z "$at_color_root" ]; then
      aa="$cc"
    fi

    if [ -z "$host_color_root" ]; then
      hh="$aa"
    fi

    user_symbol='#'
  else
    # user is not root
    cc="${user_color_user}"
    aa="${at_color_user}"
    hh="${host_color_user}"

    if [ -z "$at_color_user" ]; then
      aa="$cc"
    fi

    if [ -z "$host_color_user" ]; then
      hh="$aa"
    fi

    user_symbol='$'
  fi

  # user@host cwd
  local user_host='%{$terminfo[bold]%}'${cc}'%n%{$reset_color%}'
        user_host+='%{$terminfo[bold]%}'${aa}'@%{$reset_color%}'
        user_host+='%{$terminfo[bold]%}'${hh}'%m%{$reset_color%}'
  local current_dir='%{$terminfo[bold]${fg[blue]}%}%~%{$reset_color%}'

  # git
  # if in repo:
  #  - clean: ‹branch ✓›
  #  - dirty: ‹branch ✗›
  # else empty.
  local git_green="${FG[113]}"

  # shellcheck disable=SC2034
  {
  ZSH_THEME_GIT_PROMPT_PREFIX=" $git_green‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="$git_green›$reset_color"
  }

  function _gitp() {
    unset -f _gitp

    local gitconf
    gitconf="$(command git config --get oh-my-zsh.hide-dirty 2>/dev/null)"

    # shellcheck disable=SC2034
    {
    if [[ "$gitconf" != "1" ]]; then
      ZSH_THEME_GIT_PROMPT_DIRTY=" ${fg[red]}✗"
      ZSH_THEME_GIT_PROMPT_CLEAN=" ${FX[bold]}✓$reset_color"
    fi
    }
  }

  function git_prompt_info () {
    local ref

    local gitconf
    gitconf="$(command git config --get oh-my-zsh.hide-status 2>/dev/null)"

    local _git_prompt_info

    if [[ "$gitconf" != "1" ]]; then
      ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || \
          return 0

      gitconf="$(command git config --get oh-my-zsh.hide-dirty 2>/dev/null)"

      if [[ "$gitconf" != "1" ]]; then
        _git_prompt_info="$ZSH_THEME_GIT_PROMPT_PREFIX"
        _git_prompt_info+="${ref#refs/heads/}"
        _git_prompt_info+="$(parse_git_dirty)"
        _git_prompt_info+="$ZSH_THEME_GIT_PROMPT_SUFFIX"
      else
        _git_prompt_info="$ZSH_THEME_GIT_PROMPT_PREFIX"
        _git_prompt_info+="${ref#refs/heads/}"
        _git_prompt_info+="$ZSH_THEME_GIT_PROMPT_SUFFIX"
      fi

      echo "${_git_prompt_info}"
    fi
  }
  local gitp=''
  _gitp
  gitp='%{$(git_prompt_info)$reset_color%}'

  # virtualenv
  # if virtualenv is active: ‹virtualenv›. else empty.
  function _venvp() {
    unset -f _venvp
    local venvp=''

    venvp+='%{$fg[yellow]'
    venvp+='$(virtualenv_prompt_info | sed -r "s#\[(.*)\]# ‹\1›#")'
    venvp+='$reset_color%}'

    echo "$venvp"
  }

  # conda
  # if conda is active: ‹conda›. else empty.
  function _condap() {
    unset -f _condap
    local condap=''

    condap+='%{$fg[cyan]'
    condap+='$(test "$CONDA_DEFAULT_ENV" && echo " ‹$CONDA_DEFAULT_ENV›")'
    condap+='$reset_color%}'

    echo "$condap"
  }

  # helper functions for ruby prompt
  function rvm_prompt_active() {
    return 1
  }

  function rvm_activate_prompt() {
    function rvm_prompt_active() {
      return 0
    }
  }

  function rvm_deactivate_prompt() {
    function rvm_prompt_active() {
      return 1
    }
  }

  # ruby
  # if rvm_prompt_active (rvm_activate_prompt/rvm_deactivate_prompt):
  #  - if rvm: ‹ruby_version› or ‹system›
  #  - if rbenv: ‹ruby_version›
  # else empty.
  function _rvmp() {

    local rvmp=''
    if command -v rvm-prompt &> /dev/null; then
      rvmp='%{$fg[red]%}'

      rvmp+='$($(rvm_prompt_active) &&
                ([ ! -z "$(rvm-prompt i v g)" ] &&
                  echo " ‹$(rvm-prompt i v g)›"
                ) ||
                ([[ "x$(dirname $(command -v ruby))" == "x/usr/bin" ]] &&
                  echo " ‹system›"
                )
              )'
      rvmp+='%{$reset_color%}'
    elif command -v rbenv &> /dev/null; then
      rvmp='%{$fg[red]%} ‹$(rbenv version |
              sed -e "s/ (set.*$//")›%{$reset_color%}'
    fi

    echo "$rvmp"
  }

  # prompt: user@host cwd ‹virtualenv› ‹ruby› ‹git›
  PROMPT="╭─${user_host} ${current_dir}$(_venvp)$(_condap)$(_rvmp)${gitp}"
  PROMPT+="
╰─%B${user_symbol}%b "

  # if the previous command return code is non-zero print it in red
  local return_code="%(?..%{${fg[red]}%}%? ↵%{$reset_color%})"
  # shellcheck disable=SC2034
  RPS1="%B${return_code}%b"

  function _cleanup() {
    unset -f _cleanup

    unset -f _venvp
    unset -f _rvmp
    unset _gitp
  }

  _cleanup
}

_theme
