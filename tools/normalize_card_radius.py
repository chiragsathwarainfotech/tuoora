#!/usr/bin/env python3
"""
Targeted card-radius normaliser.

Walks each .dart file under the given paths. For every line that contains
`borderRadius: BorderRadius.circular(<N>)`, looks ahead up to 6 lines for
`boxShadow:`. If found, the line is treated as belonging to a card and
the radius is rewritten to `8` (the design-system spec). Pills, chips,
icon backgrounds, search fields, dialogs etc. that don't carry a shadow
are untouched, so the change is safe to bulk-apply.

Usage:
    python tools/normalize_card_radius.py <paths>
"""

import re
import sys
from pathlib import Path

# Captures the WHOLE radius expression so 'AppSpacing.s12', '12', '12.0',
# etc. all get normalised in one pass.
RADIUS_RE = re.compile(
    r'(borderRadius:\s*BorderRadius\.circular\()([^)]+)(\))'
)
LOOKAHEAD = 6

# Already-on-spec values we skip to avoid no-op edits.
SPEC_VALUES = {'8', '8.0', 'AppSpacing.cardRadius', 'AppSpacing.s8'}


def process_file(path: Path) -> int:
    lines = path.read_text(encoding='utf-8').splitlines(keepends=True)
    changes = 0
    for i, line in enumerate(lines):
        match = RADIUS_RE.search(line)
        if not match or match.group(2).strip() in SPEC_VALUES:
            continue
        # Look ahead for boxShadow: within LOOKAHEAD lines.
        window = ''.join(lines[i + 1 : i + 1 + LOOKAHEAD])
        if 'boxShadow:' not in window:
            continue
        lines[i] = RADIUS_RE.sub(r'\g<1>AppSpacing.cardRadius\g<3>', line, count=1)
        changes += 1
    if changes:
        path.write_text(''.join(lines), encoding='utf-8')
    return changes


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    total_files = 0
    total_changes = 0
    for root in argv[1:]:
        for dart in Path(root).rglob('*.dart'):
            n = process_file(dart)
            if n:
                total_files += 1
                total_changes += n
                print(f'{n:>3} {dart}')
    print(f'\nDone: {total_changes} card radii normalised across {total_files} files.')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
