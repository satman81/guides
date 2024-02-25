# by SATMan - https://github.com/satman81
# v0.1 - 02.2024

# Define the binary
base_cmd="crossfid"

_generate_command_completions() {
    local cur prev opts cmds flags
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Initialize commands and flags strings
    cmds=""
    flags=""

    # Fetch the top-level commands if no command has been entered yet
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        cmds=$($base_cmd --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
    fi

    # Determine the active command or sub-command
    local command=""
    local subcommand=""
    for ((i=1; i < COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            if [[ -z "$command" ]]; then
                command="${COMP_WORDS[i]}"
                # Fetch sub-commands for the detected command
                cmds=$($base_cmd $command --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
            else
                subcommand="${COMP_WORDS[i]}"
                # Fetch sub-command options if a sub-command is detected
                cmds=$($base_cmd $command $subcommand --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
                break
            fi
        fi
    done
   
    # Fetch flags for the current context
    if [[ -n "$subcommand" ]]; then
        flags+=" $($base_cmd $command $subcommand --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    elif [[ -n "$command" ]]; then
        flags+=" $($base_cmd $command --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    else
        flags+=" $($base_cmd --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    fi

    # Combine commands, subcommands, and flags for completion, prioritizing commands and subcommands
    COMPREPLY=()
    if [[ "$cur" == --* ]]; then
        COMPREPLY=($(compgen -W "${flags}" -- "${cur}"))
    else
        COMPREPLY=($(compgen -W "${cmds}" -- "${cur}"))
        # If no commands match, then suggest flags
        [[ ${#COMPREPLY[@]} -eq 0 ]] && COMPREPLY=($(compgen -W "${flags}" -- "${cur}"))
    fi
}

complete -F _generate_command_completions $base_cmd 
