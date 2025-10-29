setopt nullglob

typeset -A _keymap=(
  ALT_E         '^[e'
  ALT_G         '^[g'
  ALT_J         '^[j'
  ALT_K         '^[k'
  ALT_L         '^[l'
  ALT_O         '^[o'
  ALT_U         '^[u'
  ALT_MINUS     '^[-'
  ALT_SHIFT_L   '^[L'
  ALT_SHIFT_R   '^[R'
  ALT_SHIFT_U   '^[U'
  SUPER_A       '^[[97;9u'
  SUPER_B       '^[[98;9u'
  SUPER_D       '^[[100;9u'
  SUPER_F       '^[[102;9u'
  SUPER_L       '^[[108;9u'
  SUPER_M       '^[[109;9u'
  SUPER_R       '^[[114;9u'
  SUPER_S       '^[[115;9u'
  SUPER_T       '^[[116;9u'
  SUPER_U       '^[[117;9u'
  SUPER_SHIFT_C '^[[99;10u'
  SUPER_SHIFT_D '^[[100;10u'
  SUPER_SHIFT_F '^[[102;10u'
  SUPER_SHIFT_L '^[[108;10u'
  SUPER_SHIFT_P '^[[112;10u'
  SUPER_SHIFT_S '^[[115;10u'
  SUPER_CONTROL_P '^[[112;13u'
  SUPER_CONTROL_S '^[[115;13u'
)

_get_key_binding() {
  local key_name="$1"

  local key_binding="${_keymap[$key_name]}"
  if [[ -z ${key_binding} ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  echo "${key_binding}"
}


_bind_key_to_command() {
  local key_name="$1"
  local command="$2"

  local key_binding=$(_get_key_binding "$key_name") || return 1

  bindkey -s "${key_binding}" "${command}"
}


_bind_key_to_command2() {

}

_bind_key_to_function() {
  local key_name="$1"
  local function_name="$2"

  local key_binding=$(_get_key_binding "$key_name") || return 1

  zle -N "${function_name}"
  bindkey "${key_binding}" "${function_name}"
}

# General-purpose command cycler (cycles through any array of commands)
_cycle_commands_with_list() {
  local -a commands=("${(@P)1}")  # Evaluate variable name passed as string
  local i next_index

  # Handle empty command list
  if [[ ${#commands[@]} -eq 0 ]]; then
    return 1
  fi

  if [[ -z "$BUFFER" ]]; then
    BUFFER="${commands[1]}"
  else
    # Find current command in the list
    for i in {1..${#commands[@]}}; do
      if [[ "$BUFFER" == "${commands[i]}" ]]; then
        next_index=$(( (i % ${#commands[@]}) + 1 ))
        BUFFER="${commands[next_index]}"
        break
      fi
    done

    # If current buffer doesn't match any command, start from the beginning
    if [[ -z "$next_index" ]]; then
      BUFFER="${commands[1]}"
    fi
  fi

  # Move cursor to end and redisplay
  zle end-of-line
  zle redisplay  # Forces the command line to refresh, which can help with display issues in some terminals
}

zle -N _cycle_commands_with_list

# Generic function to create a cycle function with custom commands and key binding
_bind_key_to_cycle_commands() {
  local key_name="$1"
  shift 1

  # Lookup key binding from _keymap associative array
  local key_binding="${_keymap[$key_name]}"
  if [[ -z $key_binding ]]; then
    echo "Error: Unknown key name '$key_name'" >&2
    return 1
  fi

  local -a commands=("$@")

  # Generate a unique function name based on key binding
  local func_name="cycle_func_${key_name}"

  # Create the function dynamically with eval
  eval "
      function ${func_name}() {
        local -a cmd_list=($(printf "'%s' " "${commands[@]}"))
        _cycle_commands_with_list cmd_list
      }
    "

  # Register with zle and bind key
  zle -N "$func_name"
  bindkey "$key_binding" "$func_name"
}

_bind_key_to_empty_or_nonempty_command_line() {
  local key_name="$1"
  local empty_cmd="$2"
  local full_cmd="$3"

  local key_binding="${_keymap[$key_name]}"

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
