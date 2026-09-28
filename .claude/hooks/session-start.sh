#!/bin/bash
# Installs the SkillSpector CLI used by the skill-inspector skill.
# Pinned to a reviewed commit so upstream changes can't slip in unreviewed.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

SKILLSPECTOR_REF="89e90872e2ec813bcb137bf6b3145c92e55811ae"
SKILLSPECTOR_VERSION="2.12.0"
BIN_DIR="$HOME/.local/bin"
export PATH="$BIN_DIR:$PATH"

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

if skillspector --version 2>/dev/null | grep -q "v$SKILLSPECTOR_VERSION"; then
  exit 0
fi

SPEC="git+https://github.com/NVIDIA/skillspector.git@$SKILLSPECTOR_REF"
if command -v uv >/dev/null 2>&1; then
  uv tool install --force "$SPEC" >&2
else
  python3 -m pip install --user --quiet "$SPEC" >&2
fi

skillspector --version >&2
