#################################################
# the settings for prompt

# initialize our new variables
# in theory this would be in a fish_prompt event, but this file isn't sourced
# until the fish_prompt function is called anyway.
if not set -q __prompt_initialized_2
  set -U fish_color_user -o green
  set -U fish_color_host -o cyan
  set -U fish_color_status red
  set -U __prompt_initialized_2
end

#################################################
# the settings for git prompt
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish

#------------------------------------------------
# normal git prompt mode

#set -g __fish_git_prompt_showdirtystate 1
#set -g __fish_git_prompt_showstashstate 1
#set -g __fish_git_prompt_showuntrackedfiles 1
#set -g __fish_git_prompt_showupstream "informative"
#set -g __fish_git_prompt_describe_style "branch"
#set -g __fish_git_prompt_showcolorhints 1

#------------------------------------------------
# informative git prompt mode

set -g __fish_git_prompt_show_informative_status 1

#set -g __fish_git_prompt_hide_untrackedfiles 1

#set -g __fish_git_prompt_char_upstream_prefix ""
#set -g __fish_git_prompt_char_upstream_ahead "↑"
#set -g __fish_git_prompt_char_upstream_behind "↓"
#set -g __fish_git_prompt_char_upstream_stateseparator "|"
set -g __fish_git_prompt_char_dirtystate "+"
#set -g __fish_git_prompt_char_invalidstate "✖"
#set -g __fish_git_prompt_char_stagedstate "●"
#set -g __fish_git_prompt_char_untrackedfiles "…"
#set -g __fish_git_prompt_char_cleanstate "✔"

#set -g __fish_git_prompt_color_dirtystate blue
#set -g __fish_git_prompt_color_invalidstate red
#set -g __fish_git_prompt_color_stagedstate yellow
#set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
#set -g __fish_git_prompt_color_cleanstate green bold

#set -g __fish_git_prompt_color_prefix    magenta bold
#set -g __fish_git_prompt_color_suffix    magenta bold
#set -g __fish_git_prompt_color_bare      magenta bold
#set -g __fish_git_prompt_color_merging   magenta bold
#set -g __fish_git_prompt_color_branch    magenta bold
#set -g __fish_git_prompt_color_flags     magenta bold
#set -g __fish_git_prompt_color_upstream  magenta bold

#################################################
# prompt function

function fish_prompt --description 'Write out the prompt'

  #################################################
  # the prompt's content

  set -l last_status $status
  set -l prompt_status
  if test $last_status -ne 0
    set prompt_status "[$last_status]"
  end

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  set -l delim '$'

  if not set -q -g __fish_classic_git_functions_defined
    set -g __fish_classic_git_functions_defined

    function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
      if status --is-interactive
        set -e __fish_prompt_user
        commandline -f repaint ^/dev/null
      end
    end
    
    function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
      if status --is-interactive
        set -e __fish_prompt_host
        commandline -f repaint ^/dev/null
      end
    end
    
    function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
      if status --is-interactive
        set -e __fish_prompt_status
        commandline -f repaint ^/dev/null
      end
    end
  end

  # remove first blank
  set prompt_git (my_git_prompt | cut -c 2-)

  #################################################
  # the prompt's color

  if not set -q __fish_prompt_user
    set -g __fish_prompt_user (set_color $fish_color_user)
  end

  if not set -q __fish_prompt_host
    set -g __fish_prompt_host (set_color $fish_color_host)
  end

  switch $USER

  case root

    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
      else
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
    end

  case '*'

    if not set -q __fish_prompt_cwd
      set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

  end

  if not set -q __fish_prompt_status
    set -g __fish_prompt_status (set_color $fish_color_status)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  echo ""
  echo -s "$__fish_prompt_user" "$USER" "$__fish_prompt_normal" "@" "$__fish_prompt_host" "$__fish_prompt_hostname" "$__fish_prompt_normal" ': ' "$__fish_prompt_cwd" (my_pwd_prompt) 
  echo -s (my_vi_prompt) "$prompt_git" "$__fish_prompt_status" "$prompt_status"  "$__fish_prompt_normal" "$delim "
end

function my_pwd_prompt
  # shorten the path
  #echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||' -e 's-\([^/.]\)[^/]*/-\1/-g'

  # the last 3 path is not shortened
  set path (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')
  set path_head (echo $path | sed -e 's-\(/[^/]*/[^/]*$\)--g') 
  set path_tail (echo $path | grep '\(/[^/]*/[^/]*$\)' -o)
  set path_head (echo $path_head | sed -e 's-\([^/.]\)[^/]*/-\1/-g') 
  echo -s  $path_head $path_tail
end

function my_git_prompt
  set git_toplevel (git rev-parse --show-toplevel 2>/dev/null)

  if test $status -eq 0
    # in a git repository
    
    switch "$git_toplevel"

    # homebrew, no git prompt
    case '/usr/local'
      return

    # my home repository. only show prompt in $HOME
    case $HOME
      if test $HOME = $PWD
        __fish_git_prompt
      else
        return
      end

    # a normal git repository, show git prompt
    case '*'
      __fish_git_prompt

    end

  else
    # not in a git repository
    return
  end
end

# learnt from funtion fish_mode_prompt
function my_vi_prompt --description "Displays the current mode"
  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    echo -s (set_color green) '['
    switch $fish_bind_mode
      case default
        echo -s (set_color magenta) 'N'
      case insert
        echo -s (set_color cyan) 'I'
      case replace-one
        echo -s (set_color magenta) 'R'
      case visual
        echo -s (set_color magenta) 'V'
    end
    echo -s (set_color green) ']'
  end
end
