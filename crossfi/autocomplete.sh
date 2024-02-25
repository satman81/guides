# by SATMan - https://github.com/satman81/                                        
# v0.1 - 02.2024
_generate_crossfid_completions() {
    local cur prev opts cmds
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Define the base command
    local base_cmd="crossfid"

    # Initialize commands string
    cmds=""

    # Fetch the top-level commands if no command has been entered yet
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        cmds=$(crossfid --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
    fi

    # Determine the active command or sub-command
    local command=""
    local subcommand=""
    for ((i=1; i < COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            if [[ -z "$command" ]]; then
                command="${COMP_WORDS[i]}"
                # Fetch sub-commands for the detected command
                cmds=$(crossfid $command --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
            else
                subcommand="${COMP_WORDS[i]}"
                # Fetch sub-command options if a sub-command is detected
                cmds=$(crossfid $command $subcommand --help 2>/dev/null | awk '/Commands:/,/^$/' | grep -vE 'Commands:|Available Commands:' | awk '{print $1}' | sort -u)
                break
            fi
        fi
    done

    # Fetch and parse options based on the current context
    opts=""
    if [[ -n "$subcommand" ]]; then
        opts+=" $(crossfid $command $subcommand --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    elif [[ -n "$command" ]]; then
        opts+=" $(crossfid $command --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    else
        opts+=" $(crossfid --help 2>/dev/null | grep -oE '\-\-[a-zA-Z0-9\-]+' | sort -u)"
    fi

    # Combine commands and options for completion
    COMPREPLY=()
    if [[ "$cur" == --* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
    else
        COMPREPLY=($(compgen -W "${cmds} ${opts}" -- "${cur}"))
    fi
}

complete -F _generate_crossfid_completions crossfid
