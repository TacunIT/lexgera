#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

NOW="$(date +'%B %d, %Y')"

RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

QUESTION_FLAG="${GREEN}?"
WARNING_FLAG="${YELLOW}!"
NOTICE_FLAG="${CYAN}❯"

ADJUSTMENTS_MSG="${QUESTION_FLAG} ${CYAN}You can edit ${WHITE}CHANGELOG.md${CYAN}. Press enter to continue."
PUSHING_MSG="${NOTICE_FLAG} Pushing new version to ${WHITE}origin${CYAN}..."

RELEASE_NOTE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--message) RELEASE_NOTE="$2"; shift 2 ;;
    *) break ;;
  esac
done

# Safety checks
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { echo "Not a git repository"; exit 1; }

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo -e "${WARNING_FLAG} Working tree not clean."
  exit 1
fi

LATEST_HASH=$(git rev-parse --short HEAD)

tag() {
  local version="$1"
  local message="${2:-Tag version $version.}"
  git tag -a "v$version" -m "$message"
}

if [[ -f VERSION ]]; then
  if git describe --contains HEAD >/dev/null 2>&1; then
    echo -e "${WARNING_FLAG} Current commit is already tagged."
    exit 0
  fi

  IFS='.' read -r V_MAJOR V_MINOR V_PATCH < VERSION
  BASE_STRING="$V_MAJOR.$V_MINOR.$V_PATCH"

  echo -e "${NOTICE_FLAG} Current version: ${WHITE}$BASE_STRING"
  echo -e "${NOTICE_FLAG} Latest commit: ${WHITE}$LATEST_HASH"
  echo -e "${NOTICE_FLAG} Changes since last version"

  git log --pretty=format:"  - %s" "v$BASE_STRING"...HEAD
  echo

  V_PATCH=$((V_PATCH + 1))
  SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"

  read -rp "Enter version [$SUGGESTED_VERSION]: " INPUT_STRING
  INPUT_STRING="${INPUT_STRING:-$SUGGESTED_VERSION}"

  echo "$INPUT_STRING" > VERSION

  TMPFILE=$(mktemp)
  {
    echo "## $INPUT_STRING ($NOW)"
    git log --pretty=format:"  - %s" "v$BASE_STRING"...HEAD
    echo
    echo
    cat CHANGELOG.md
  } > "$TMPFILE"

  mv "$TMPFILE" CHANGELOG.md

  echo -e "$ADJUSTMENTS_MSG"
  read -r

  git add VERSION CHANGELOG.md
  git commit -m "Bump version to $INPUT_STRING."
  tag "$INPUT_STRING" "$RELEASE_NOTE"

  echo -e "$PUSHING_MSG"

    # --- Chiede conferma prima del push sul branch main ---
    read -rp "${QUESTION_FLAG} Vuoi fare push sul branch main? [y/N]: " CONFIRM
    CONFIRM="$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')"

    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
        echo -e "$PUSHING_MSG"
        git push origin HEAD:master --tags
        echo -e "${GREEN}✔ Push completato.${RESET}"
    else
        echo -e "${NOTICE_FLAG} Push annullato. I commit e i tag restano locali.${RESET}"
    fi

    git log --all --graph --decorate

else
  echo -e "${WARNING_FLAG} VERSION file not found."
  exit 1
fi

echo -e "${NOTICE_FLAG} Finished.${RESET}"
