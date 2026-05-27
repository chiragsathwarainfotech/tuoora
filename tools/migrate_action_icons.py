#!/usr/bin/env python3
"""
Replace Icon(Icons.edit*, ...) / Icon(Icons.delete*, ...) usages with
AppActionIcon(asset: AppImages.icEdit | icDelete, size: N?).

Preserves the explicit `size:` argument when present; drops `color:` since
the design system fixes both edit + delete icons to primaryBrand.

Adds the two required imports (AppImages, AppActionIcon) the first time
either icon appears in a file.

Usage:
    python tools/migrate_action_icons.py <files...>
"""

import re
import sys
from pathlib import Path

# Matches an `Icon(...)` whose first positional argument is Icons.edit*
# or Icons.delete*. Captures the kind and the size value if present.
ICON_RE = re.compile(
    r'Icon\(\s*Icons\.(?P<kind>edit(?:_outlined|_rounded)?|delete(?:_outline_rounded|_outline|_rounded|_outlined)?)\s*'
    r'(?P<rest>(?:,[^)]*?)?)\)',
    re.DOTALL,
)

SIZE_RE = re.compile(r'size:\s*([A-Za-z0-9_.]+)')

EDIT_KINDS = {'edit', 'edit_outlined', 'edit_rounded'}

IMPORT_APPIMAGES = (
    "import 'package:tuoora/core/constants/app_images.dart';\n"
)
IMPORT_APPACTION = (
    "import 'package:tuoora/core/widgets/app_action_icon.dart';\n"
)


def needs_const(text: str, start: int) -> bool:
    """The replacement is a const constructor; if the original `Icon(`
    was already preceded by `const`, we shouldn't double-up."""
    prefix = text[max(0, start - 8):start].rstrip()
    return not prefix.endswith('const')


def replace_icons(src: str) -> tuple[str, int]:
    """Returns (new_src, replacement_count)."""
    out_parts = []
    last = 0
    count = 0
    for m in ICON_RE.finditer(src):
        kind = m.group('kind')
        rest = m.group('rest') or ''
        size_match = SIZE_RE.search(rest)

        asset = 'AppImages.icEdit' if kind in EDIT_KINDS else 'AppImages.icDelete'
        params = [f'asset: {asset}']
        if size_match:
            params.append(f'size: {size_match.group(1)}')
        replacement = 'AppActionIcon(' + ', '.join(params) + ')'
        if needs_const(src, m.start()):
            replacement = 'const ' + replacement

        out_parts.append(src[last:m.start()])
        out_parts.append(replacement)
        last = m.end()
        count += 1

    out_parts.append(src[last:])
    return ''.join(out_parts), count


def add_imports(src: str) -> str:
    """Insert AppImages + AppActionIcon imports right after the last
    `import 'package:tuoora/...'` line, if not already present."""
    if 'app_images.dart' in src and 'app_action_icon.dart' in src:
        return src

    lines = src.splitlines(keepends=True)
    last_tuoora_idx = -1
    for i, line in enumerate(lines):
        if "import 'package:tuoora/" in line:
            last_tuoora_idx = i

    if last_tuoora_idx < 0:
        # Fallback: prepend
        prefix = ''
        if 'app_images.dart' not in src:
            prefix += IMPORT_APPIMAGES
        if 'app_action_icon.dart' not in src:
            prefix += IMPORT_APPACTION
        return prefix + src

    insert_at = last_tuoora_idx + 1
    new_imports = []
    if 'app_images.dart' not in src:
        new_imports.append(IMPORT_APPIMAGES)
    if 'app_action_icon.dart' not in src:
        new_imports.append(IMPORT_APPACTION)
    lines[insert_at:insert_at] = new_imports
    return ''.join(lines)


def process(path: Path) -> int:
    text = path.read_text(encoding='utf-8')
    new_text, count = replace_icons(text)
    if count == 0:
        return 0
    new_text = add_imports(new_text)
    path.write_text(new_text, encoding='utf-8')
    print(f'{count:>3} {path}')
    return count


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    total = 0
    for arg in argv[1:]:
        for f in Path(arg).rglob('*.dart') if Path(arg).is_dir() else [Path(arg)]:
            total += process(f)
    print(f'\nDone: {total} icons migrated.')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
