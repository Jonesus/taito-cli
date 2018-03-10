#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_command:?}"

export taito_hook_command_executed=${taito_hook_command_executed}

if [[ "${taito_command}" == "open-"* ]]; then
  mode="open"
elif [[ "${taito_command}" == "link-"* ]]; then
  mode="link"
fi
link_name=${taito_command:5:99}

if [[ ! -z ${mode} ]]; then
  found=$(echo "${link_global_urls:-}${link_urls:-}" | grep "${link_name}[\[\:\=\#]")
  if [[ ${found} != "" ]]; then
    while IFS='*' read -ra items; do
      for item in "${items[@]}"; do
        words=(${item})
        link="${words[0]}"
        description="${words[*]:1}"
        if [[ ${link} ]]; then
          prefix="$( cut -d '=' -f 1 <<< "$link" )";
          command_prototype=${prefix%#*}
          command=${command_prototype%:*}
          command=${command%[*}
          if [[ "${command// /-}" == "${link_name}" ]]; then
            name=${prefix##*#}
            url="$( cut -d '=' -f 2- <<< "$link" )"
            echo
            if [[ "${mode}" == "open" ]]; then
              echo "### links/pre: Opening ${name}"
              echo Opening link "${url}"
              "${taito_cli_path}/util/browser-fg.sh" "${url}"
            else
              echo "### links/pre: Showing link ${name}"
              echo "${url}"
            fi
            taito_hook_command_executed=true
            break
          fi
        fi
      done
    done <<< "${link_global_urls:-} ${link_urls:-}"
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
