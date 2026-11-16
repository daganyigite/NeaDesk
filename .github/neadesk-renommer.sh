#!/usr/bin/env bash
# NEADESK : renomme les fichiers de la pré-release (rustdesk-* -> neadesk-*).
# GitHub permet de renommer un fichier de release sans le retélécharger.
# Usage : neadesk-renommer.sh <propriétaire/dépôt> <tag>
set -euo pipefail
repo="$1"
tag="$2"

release_id=$(gh api "repos/$repo/releases/tags/$tag" --jq '.id')
assets=$(gh api --paginate "repos/$repo/releases/$release_id/assets" --jq '.[] | "\(.id) \(.name)"')

while read -r id name; do
  [ -n "$id" ] || continue
  case "$name" in
    rustdesk*) ;;
    *) continue ;;
  esac
  nouveau="neadesk${name#rustdesk}"
  # Un ancien fichier du même nom (build précédent) est supprimé d'abord.
  ancien=$(printf '%s\n' "$assets" | awk -v n="$nouveau" '$2 == n { print $1 }')
  if [ -n "$ancien" ]; then
    gh api -X DELETE "repos/$repo/releases/assets/$ancien"
  fi
  gh api -X PATCH "repos/$repo/releases/assets/$id" -f name="$nouveau" --jq '.name'
done <<< "$assets"
