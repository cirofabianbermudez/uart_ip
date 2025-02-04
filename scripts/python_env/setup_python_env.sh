#!/usr/bin/env bash

##=============================================================================
## [Filename]       setup_python_env.sh      
## [Project]        uart_ip
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       Bash Scripting
## [Created]        Nov 2024
## [Modified]       -
## [Description]    Bash script to generate Python environment
## [Notes]          
## [Status]         stable
## [Revisions]      -
##=============================================================================

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$(pwd)

echo -e "\n[INFO]: Checking dependencies"
DEPENDENCIES=("python3")
for item in "${DEPENDENCIES[@]}"; do
  if command -v $item &> /dev/null; then
    printf "  > %8s is INSTALLED\n" "$item"
  else 
    printf "  > %8s is NOT INSTALLED\n" "$item"
    exit 1
  fi
done
echo -e "[INFO]: All dependencies found\n"

echo "[INFO]: Checking Python Version"
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
MIN_VERSION="3.5"
read P_MAJOR P_MINOR <<< $(echo $PYTHON_VERSION | awk -F '.' '{print $1, $2}' )
read M_MAJOR M_MINOR <<< $(echo $MIN_VERSION | awk -F '.' '{print $1, $2}' )
COMPARE_MAJOR=$(echo "$P_MAJOR $M_MAJOR" | awk '{ print ( $1 >= $2) }')
COMPARE_MINOR=$(echo "$P_MINOR $M_MINOR" | awk '{ print ( $1 >= $2) }')
COMPARE=$(echo "$COMPARE_MAJOR" "$COMPARE_MINOR" | awk '{ print ( $1 && $2) }')
printf "  > Detected Python Version: Python %s\n" "$PYTHON_VERSION"
printf "  > Requirement: >= %s\n" "$MIN_VERSION"
if [ "$COMPARE" -eq 1 ]; then
  echo -e "[INFO]: Python Version requirement met"
else
  echo -e "[ERROR]: Python Version requirement NOT met"
  exit 1
fi

echo -e "\n[INFO]: Checking Active Environment"
if [ -n "${VIRTUAL_ENV}" ]; then
  echo "[ERROR]: You are running fron inside a virtual environment!"
  echo "[ERROR]: Run 'deactivate' and retry"
  exit 1
else
  echo "[INFO]: Virtual Environment not Active"
fi

echo -e "\n[INFO]: Creating Virtual Environment"
rm -rf .venv
/usr/bin/python3 -m venv .venv
source .venv/bin/activate
set +e
pip install --upgrade pip
set -e
pip install -r .python_requirements

echo -e ""
echo -e "[INFO]: To activate environment run:"
echo -e "======================================================================================="
echo -e " bash: source $ROOT_DIR/.venv/bin/activate"
echo -e "  csh: source $ROOT_DIR/.venv/bin/activate.csh"
echo -e "======================================================================================="
echo -e ""
