@echo off

echo Taito-cli Copyright (C) 2017 Taito United
echo This program comes with ABSOLUTELY NO WARRANTY; for details see the LICENSE.
echo:

echo
echo WARNING: taito.bat is not fully implemented and it might not work yet!
echo

set taito_image="taitounited/taito-cli:latest"
set taito_command=%1
set taito_project_path=%cd%
set taito_cli_path=%~dp0
set taito_config_path=%HOMEDRIVE%%HOMEPATH%\.taito
set taito_extension_path=%taito_config_path%\my-extension

IF "%taito_command%"=="--upgrade" (
  cd "%taito_cli_path%"
  git pull
  cd "%taito_extension_path%"
  git pull
  cd "%taito_project_path%"
  docker pull "%taito_image%"
) ELSE (
  docker run -it ^
    -v "%taito_config_path%:/home/taito/.taito" ^
    -v "%taito_project_path%:/project" ^
    -w /project ^
    -e taito_enabled_extensions="%taito_extension_path%" ^
    -e taito_host_uname="Windows" ^
    -e taito_mode="normal" ^
    -e taito_docker="true" ^
    -e taito_image_name="%taito_image%" ^
    --entrypoint "taito" ^
    --rm "%taito_image%" ^
    "%*"
)
