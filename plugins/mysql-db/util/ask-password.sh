#!/bin/bash
: "${database_username:?}"

passwd_var="${database_username}_password"
passwd="${!passwd_var}"

export MYSQL_PWD
if [[ -n "${passwd}" ]]; then
  # Password already set in environment variable
  MYSQL_PWD="${passwd}"
else
  # Ask password from user
  echo "Password for user ${database_username}:"
  read -r -s MYSQL_PWD
fi
