#!/bin/sh

set -eu

failures=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

pass() {
  printf 'PASS: %s\n' "$1"
}

require_file() {
  if [ -f "$1" ]; then
    pass "$1 exists"
  else
    fail "$1 is missing"
  fi
}

require_text() {
  file=$1
  text=$2
  label=$3

  if [ ! -f "$file" ]; then
    fail "$label (missing file: $file)"
  elif grep -Fq -- "$text" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

repository_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repository_root"

required_files='
AGENTS.md
README.md
product/README.md
specs/README.md
specs/templates/product-spec.md
specs/templates/technical-spec.md
specs/templates/implementation-plan.md
specs/templates/test-plan.md
specs/templates/feature-status.md
architecture/README.md
architecture/decisions/README.md
architecture/decisions/ADR-template.md
docs/development/README.md
docs/development/engineering-os-bootstrap.md
docs/operations/README.md
docs/operations/release-readiness-review-template.md
docs/security/README.md
plans/active/README.md
plans/completed/README.md
skills/write-product-spec/SKILL.md
skills/write-technical-spec/SKILL.md
skills/create-implementation-plan/SKILL.md
skills/implement-feature/SKILL.md
skills/review-feature/SKILL.md
skills/verify-feature/SKILL.md
skills/security-review/SKILL.md
skills/release-review/SKILL.md
'

for file in $required_files; do
  require_file "$file"
done

require_text AGENTS.md 'Do not implement substantial product behavior without an approved product specification, technical specification, implementation plan, and test plan.' 'implementation gate is explicit'
require_text AGENTS.md 'Human approval is required for product scope, consequential architecture or security decisions, and production release.' 'human approval boundary is explicit'
require_text product/README.md 'No product discovery has been performed yet.' 'pre-discovery state is explicit'
require_text architecture/README.md 'No application architecture or technology stack has been selected.' 'architecture is intentionally undecided'
require_text specs/templates/product-spec.md 'Only the product owner may change `Status` to `Approved`.' 'product approval is human-controlled'
require_text specs/templates/technical-spec.md 'Only an authorized human reviewer may change `Status` to `Approved`.' 'technical approval is human-controlled'
require_text docs/operations/release-readiness-review-template.md 'Codex may prepare this review but may not grant production approval.' 'production approval is human-controlled'

for template_heading in \
  'specs/templates/product-spec.md|## Functional requirements' \
  'specs/templates/product-spec.md|## Acceptance criteria' \
  'specs/templates/technical-spec.md|## Authorization and trust boundaries' \
  'specs/templates/technical-spec.md|## Failure modes' \
  'specs/templates/technical-spec.md|## Observability' \
  'specs/templates/implementation-plan.md|## Requirement traceability' \
  'specs/templates/implementation-plan.md|## Completion gate' \
  'specs/templates/test-plan.md|## Acceptance-criteria mapping' \
  'specs/templates/test-plan.md|## Authorization and isolation tests' \
  'specs/templates/feature-status.md|## Evidence'; do
  file=${template_heading%%|*}
  heading=${template_heading#*|}
  require_text "$file" "$heading" "$file contains $heading"
done

for skill_file in skills/*/SKILL.md; do
  skill_directory=$(basename "$(dirname "$skill_file")")
  require_text "$skill_file" '---' "$skill_file has front matter delimiters"
  require_text "$skill_file" "name: $skill_directory" "$skill_file name matches its directory"
  require_text "$skill_file" 'description:' "$skill_file declares a description"
done

for reference in \
  'architecture/decisions' \
  'architecture/decisions/ADR-template.md' \
  'docs/operations/release-readiness-review-template.md' \
  'specs/templates'; do
  if [ -e "$reference" ]; then
    pass "local reference target $reference exists"
  else
    fail "local reference target $reference is missing"
  fi
done

if [ "$failures" -ne 0 ]; then
  printf '\nEngineering OS validation failed with %s issue(s).\n' "$failures" >&2
  exit 1
fi

printf '\nEngineering OS validation passed.\n'
