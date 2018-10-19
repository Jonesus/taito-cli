#!/bin/bash
: "${taito_cli_path:?}"

echo "PROJECT: LINKS"
echo

while IFS='*' read -ra items; do
  for item in "${items[@]}"; do
    words=(${item})
    link="${words[0]}"
    description="${words[*]:1}"
    if [[ ${link} ]]; then
      prefix="$( cut -d '=' -f 1 <<< "$link" )";
      command_prototype=${prefix%#*}
      echo "  open ${command_prototype//-/ }"
      echo "    ${description}"
      echo
    fi
  done
done <<< "${link_global_urls:-}${link_urls:-}"

while IFS='*' read -ra items; do
  for item in "${items[@]}"; do
    words=(${item})
    link="${words[0]}"
    description="${words[*]:1}"
    if [[ ${link} ]]; then
      prefix="$( cut -d '=' -f 1 <<< "$link" )";
      command_prototype=${prefix%#*}

      echo "  link ${command_prototype//-/ }"
      echo "    ${description}"
      echo
    fi
  done
done <<< "${link_global_urls:-}${link_urls:-}"
