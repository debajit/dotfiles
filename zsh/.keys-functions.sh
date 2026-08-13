typeset -A _keymap=(
  ALT_E         '^[e'
  ALT_G         '^[g'
  ALT_J         '^[j'
  ALT_K         '^[k'
  ALT_L         '^[l'
  ALT_O         '^[o'
  ALT_U         '^[u'
  ALT_W         '^[w'
  ALT_0         '^[0'
  ALT_MINUS     '^[-'
  ALT_SHIFT_J   '^[J'
  ALT_SHIFT_K   '^[K'
  ALT_SHIFT_L   '^[L'
  ALT_SHIFT_R   '^[R'
  ALT_SHIFT_U   '^[U'
  SUPER_A       '^[[97;9u'
  SUPER_B       '^[[98;9u'
  SUPER_D       '^[[100;9u'
  SUPER_F       '^[[102;9u'
  SUPER_I       '^[[105;9u'
  SUPER_K       '^[[107;9u'
  SUPER_L       '^[[108;9u'
  SUPER_M       '^[[109;9u'
  SUPER_O       '^[[111;9u'
  SUPER_R       '^[[114;9u'
  SUPER_S       '^[[115;9u'
  SUPER_T       '^[[116;9u'
  SUPER_U       '^[[117;9u'
  SUPER_SHIFT_D '^[[100;10u'
  SUPER_SHIFT_F '^[[102;10u'
  SUPER_SHIFT_I '^[[105;10u'
  SUPER_SHIFT_L '^[[108;10u'
  SUPER_SHIFT_M '^[[109;10u'
  SUPER_SHIFT_P '^[[112;10u'
  SUPER_SHIFT_S '^[[115;10u'
  SUPER_SHIFT_X '^[[120;10u'
  SUPER_CONTROL_C '^[[99;13u'
  SUPER_CONTROL_P '^[[112;13u'
  SUPER_CONTROL_S '^[[115;13u'
  SUPER_CONTROL_T '^[[116;13u'
)

_bind_key_to_command() {
  local key_name="$1"
  local command="$2"

  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  bindkey -s "${key_binding}" "${command}"
}


_bind_key_to_function() {
  local key_name="$1"
  local function_name="$2"

  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  zle -N "${function_name}"
  bindkey "${key_binding}" "${function_name}"
}

# Maps generated ZLE widget names to the arrays that hold their directories.
# This lets every directory cycle share one small, reusable widget function.
typeset -gA _directory_cycle_widgets

# Change to the directory after PWD in the named array. If PWD is not in the
# array, start at its first directory; after the last directory, wrap around.
_cycle_directories_with_list() {
  local directory_list_name="$1"
  local -a directories=("${(@P)directory_list_name}")
  local current_directory="${PWD:A}"
  local next_directory
  local i

  if (( ${#directories[@]} == 0 )); then
    zle -M "Cannot cycle directories: '${directory_list_name}' is empty"
    return 1
  fi

  next_directory="${directories[1]}"

  for (( i = 1; i <= ${#directories[@]}; i++ )); do
    if [[ "${current_directory}" == "${directories[i]:A}" ]]; then
      next_directory="${directories[$(( (i % ${#directories[@]}) + 1 ))]}"
      break
    fi
  done

  if [[ ! -d "${next_directory}" ]]; then
    zle -M "Cannot cycle directories: not found: ${next_directory}"
    return 1
  fi

  builtin cd -- "${next_directory}" || return 1
  zle reset-prompt
}

# The shared ZLE widget looks up the directory-array name registered for the
# key that invoked it.
_cycle_directories_widget() {
  local directory_list_name="${_directory_cycle_widgets[$WIDGET]}"
  _cycle_directories_with_list "${directory_list_name}"
}

# Bind a key from _keymap to an ordered array of directories. To add another
# independent cycle, declare another global array and call this function with
# its key name and array name.
_bind_key_to_cycle_directories() {
  local key_name="$1"
  local directory_list_name="$2"
  local widget_name="_cycle_directories_widget_${key_name}"

  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  if (( ! ${+parameters[$directory_list_name]} )); then
    echo "Error: Unknown directory list '${directory_list_name}'" >&2
    return 1
  fi

  _directory_cycle_widgets[$widget_name]="${directory_list_name}"
  zle -N "${widget_name}" _cycle_directories_widget
  bindkey "${key_binding}" "${widget_name}"
}

# General-purpose command cycler (cycles through any array of commands)
# Note: the array is named command_list, not commands, because $commands is
# a zsh special parameter mapping command names to their paths.
_cycle_commands_with_list() {
  local -a command_list=("${(@P)1}")  # Evaluate variable name passed as string
  local i next_index

  # Handle empty command list
  if [[ ${#command_list[@]} -eq 0 ]]; then
    return 1
  fi

  if [[ -z "$BUFFER" ]]; then
    BUFFER="${command_list[1]}"
  else
    # Find current command in the list
    for i in {1..${#command_list[@]}}; do
      if [[ "$BUFFER" == "${command_list[i]}" ]]; then
        next_index=$(( (i % ${#command_list[@]}) + 1 ))
        BUFFER="${command_list[next_index]}"
        break
      fi
    done

    # If current buffer doesn't match any command, start from the beginning
    if [[ -z "$next_index" ]]; then
      BUFFER="${command_list[1]}"
    fi
  fi

  # Move cursor to end and redisplay
  zle end-of-line
  zle redisplay  # Forces the command line to refresh, which can help with display issues in some terminals
}

# Maps generated ZLE widget names to the arrays holding their commands. This
# lets every command cycle share one small widget function, the same way
# _directory_cycle_widgets does above, instead of generating a function per
# key with eval. Generating them meant quoting shell source by hand, which
# silently produced a broken widget for any command containing an apostrophe.
typeset -gA _command_cycle_widgets

# The shared ZLE widget looks up the command-array name registered for the
# key that invoked it.
_cycle_commands_widget() {
  _cycle_commands_with_list "${_command_cycle_widgets[$WIDGET]}"
}

# Bind a key from _keymap to an ordered list of commands to cycle through.
_bind_key_to_cycle_commands() {
  local key_name="$1"
  shift 1

  # Lookup key binding from _keymap associative array
  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  # Keep the cycle_func_* widget name, so bindings read the same as before
  local widget_name="cycle_func_${key_name}"
  local command_list_name="_command_cycle_list_${key_name}"

  # Hold this key's commands in a global array, and record which array the
  # shared widget should read when this key is pressed.
  typeset -ga "${command_list_name}"
  set -A "${command_list_name}" "$@"
  _command_cycle_widgets[$widget_name]="${command_list_name}"

  # Register with zle and bind key
  zle -N "${widget_name}" _cycle_commands_widget
  bindkey "${key_binding}" "${widget_name}"
}

_bind_key_to_empty_or_nonempty_command_line() {
  local key_name="$1"
  local empty_cmd="$2"
  local full_cmd="$3"

  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  # Create a widget function with a unique name based on the key name
  local widget_name="_empty_or_full_command_widget_${key_name}"

  # Create the actual widget function
  eval "${widget_name}() {
    if [[ -z \"\$BUFFER\" ]]; then
      BUFFER='${empty_cmd}'
      zle accept-line
    else
      # If the rightmost char is not a space
      if [[ \"\${BUFFER: -1}\" != ' ' ]]; then
        BUFFER+=' '
      fi

      BUFFER+='${full_cmd}'
      zle end-of-line
    fi
  }"

  # Register the widget
  zle -N "${widget_name}"

  # Bind the key to the widget
  bindkey "${key_binding}" "${widget_name}"
}

_bind_key_to_command_and_move_cursor_left() {
  local key_name="$1"
  local cmd="$2"
  local cursor_left_steps="$3"

  local key_binding="${_keymap[$key_name]}"

  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  # Create a widget function with a unique name based on the key name
  local widget_name="_command_and_move_cursor_left_widget_${key_name}"

  # Create the actual widget function
  eval "${widget_name}() {
    BUFFER='${cmd}'
    zle end-of-line
    ((CURSOR -= ${cursor_left_steps}))
  }"

  # Register the widget
  zle -N "${widget_name}"

  # Bind the key to the widget
  bindkey "${key_binding}" "${widget_name}"
}
