---
name: ty-lsp
description: Use whenever navigating, reviewing, or refactoring Python code in this project — finding where a function/class is defined, tracing every call site of a symbol, or checking an inferred type. Prefer the LSP-backed navigation tools (go to definition, find references, hover) that ty provides over grep/text search, especially before renaming or removing something.
---

Grep matches text, not meaning. Python codebases routinely have many
unrelated classes defining methods with the same name — `save`, `load`,
`run`, `__init__` — so a grep for `def run` returns every candidate with no
way to tell which one a given call site actually resolves to. The `ty`
language server wired up by this plugin resolves symbols the way Python
itself would: it knows the type of the receiver, so "find references" and
"go to definition" return only the call sites and declaration that are
actually connected, not just ones that happen to share a name.

Reach for the LSP tools first when:
- Locating where a function, class, or variable is defined
- Finding every call site before renaming or removing something
- Checking what a symbol's inferred type is

Grep is still the right tool for text search that isn't about a specific
symbol (TODO comments, a literal string, a config value), and for files
outside `.py`/`.pyi` that ty doesn't cover.
