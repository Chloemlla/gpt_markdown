#!/usr/bin/env bash
#
# Checks that every commit in <base>..<head> carries a Developer Certificate of
# Origin sign-off matching its author:
#
#   Signed-off-by: Author Name <author@example.com>
#
# which is what `git commit -s` adds. The DCO workflow runs this on every pull
# request; run it yourself before pushing:
#
#   ./scripts/dco.sh origin/main HEAD
#
# Merge commits are skipped, and so are commits authored by GitHub bots —
# Dependabot and the Goldens workflow (`github-actions[bot]`) cannot sign off.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <base> <head>" >&2
  exit 2
fi

base=$1
head=$2
missing=()

while read -r sha; do
  [[ -z "$sha" ]] && continue
  name=$(git log -1 --format=%an "$sha")
  email=$(git log -1 --format=%ae "$sha")
  if [[ "$email" == *"[bot]@users.noreply.github.com" ]]; then
    continue
  fi
  # The whole trailer line, case-insensitively: `git commit -s` writes it from
  # the same user.name and user.email the author fields come from.
  if git log -1 --format=%B "$sha" |
    grep -qixF "Signed-off-by: $name <$email>"; then
    continue
  fi
  missing+=("$(git log -1 --format='%h %s' "$sha")  (author: $name <$email>)")
done < <(git rev-list --no-merges "$base..$head")

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "✓ every commit is signed off"
  exit 0
fi

echo "✗ ${#missing[@]} commit(s) without a matching Signed-off-by line:"
printf '  %s\n' "${missing[@]}"
cat <<'EOF'

Each commit needs a sign-off matching its author. To add it to every commit on
this branch and update the pull request:

  git rebase --signoff origin/main
  git push --force-with-lease

Use `git commit -s` for new commits. See CONTRIBUTING.md, "Sign off your
commits".
EOF
exit 1
