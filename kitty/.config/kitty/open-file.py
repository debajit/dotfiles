"""Pick visible file paths, with optional line numbers, and open the editor."""

import re


PATH_REFERENCE = re.compile(
    r"(?<![\w/.:~+@-])(?P<path>[\w~./+@-]+)"
    r"(?::(?P<line>[0-9]+)(?::[0-9]+)?)?"
)


def mark(text, args, Mark, extra_cli_args, *a):
    index = 0
    for match in PATH_REFERENCE.finditer(text):
        path = match["path"].rstrip(".")
        line = match["line"]
        # Ignore ordinary words and punctuation; keep paths, filenames and
        # extensionless filenames with a line number (e.g. Makefile:12).
        if not re.search(r"\w", path) or not ("/" in path or "." in path or line):
            continue
        end = match.end() if line else match.start() + len(path)
        yield Mark(index, match.start(), end, text[match.start():end],
                   {"path": path, "line": line})
        index += 1


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    from kitty.utils import get_editor

    for match, reference in zip(data["match"], data["groupdicts"]):
        if match:
            command = get_editor(
                path_to_edit=reference["path"],
                line_number=int(reference["line"] or 0),
            )
            boss.run_background_process(command, cwd=data["cwd"],
                                        allow_remote_control=False)
