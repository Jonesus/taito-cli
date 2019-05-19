#!/bin/bash -e

. _template-config.sh

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_vc_repository:?}"
: "${template_dest_git:?}"
: "${template_default_vc_url:?}"

if [[ -d alternatives ]]; then
  alternatives=${template_default_alternatives:-}
  if [[ ! ${alternatives} ]]; then
    echo
    echo "The template comes with React / Node.js / Postgres implementation by"
    echo "default, but offers also the following alternatives:"
    echo
    ls -d alternatives/*/ | sed "s/alternatives\\///" | sed "s/\\///"

    echo
    echo "Give alternative names one by one. Give empty name once done."
    alternative=-
    while [[ $alternative ]]; do
      read -r alternative
      if [[ -d alternatives/$alternative ]]; then
        alternatives="${alternatives} $alternative"
      else
        echo "No such alternative: $alternative"
      fi
    done
  fi

  echo "Preparing alternatives..."
  for alternative in ${alternatives}
  do
    if [[ -d "alternatives/$alternative" ]]; then
      name="${alternative%%-*}"
      rm -rf "$name"
      mv "alternatives/$alternative" "$name"
    fi
  done
  rm -rf alternatives
fi

# Execute create script of template
"${taito_plugin_path}/util/init.sh" "create"

rm -f ./_template-config.sh

taito project-docs

echo
echo "Create a new repository: ${template_default_vc_url}/${taito_vc_repository}"
echo "The new repository must be completely empty (no README.md, LICENSE,"
echo "or .gitignore). After you have created the empty repository, continue by"
echo "pressing enter."
read -r

doc="README.md#configuration"
if [[ -f "DEVELOPMENT.md" ]]; then
  doc="DEVELOPMENT.md#configuration"
fi
if [[ -f "CONFIGURATION.md" ]]; then
  doc="CONFIGURATION.md"
fi

echo "Please wait..."
"${taito_cli_path}/util/execute-on-host-fg.sh" "
  set -e
  export GIT_PAGER=''
  git init -q
  git add .
  git commit -q -m 'First commit'
  git remote add origin ${template_dest_git}/${taito_vc_repository}.git
  while ! (echo Pushing to git... && git push --force -q -u origin master &> /dev/null)
  do
    echo Failed pushing to ${template_dest_git}/${taito_vc_repository}.
    echo Make sure the git repository exists and you have authenticated using SSH keys.
    echo Press enter to try again.
    read -r
  done
  git tag v0.0.0
  git push -q origin v0.0.0
  git checkout -q -b dev
  git push -q -u origin dev &> /dev/null
  echo
  echo Created directory: ${taito_vc_repository}
  echo Press enter to open configuration instructions.
  read -r
  echo
  if [[ \"${template_dest_git}\" == *\"bitbucket.org:\"* ]]; then
    taito -c util-browser https://${template_default_vc_url}/${taito_vc_repository}/src/dev/${doc}
  else
    taito -c util-browser https://${template_default_vc_url}/${taito_vc_repository}/blob/dev/${doc}
  fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
