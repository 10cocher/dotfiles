---
name: kedro-conventions
description: Use whenever writing or reviewing Kedro nodes, pipelines, or catalog.yml entries — especially when a node reaches for open(), pd.read_*/to_*, boto3, or a DB connection directly, or when kedro-datasets has no dataset for what's needed. Covers Data Catalog vs inline I/O, and scaffolding a custom AbstractDataset from the bundled template instead of writing one from scratch.
---

## Core principle
Nodes should be pure functions: inputs and outputs only, no I/O. All reading
and writing goes through the Data Catalog. A node performing its own file/DB/
API access defeats the point of the catalog — lineage tracking, swappable
storage, and reproducibility all depend on nodes staying I/O-free.

## When kedro-datasets has no matching dataset
Do not fall back to inline I/O as a shortcut. Instead, write a custom dataset:

1. Subclass `AbstractDataset` (or `AbstractVersionedDataset` if versioning
   matters).
2. Implement `_load`, `_save`, and `_describe` at minimum.
3. Start from the bundled `custom_dataset_template.py` (in this skill's
   directory) rather than writing one from scratch — copy it into
   `src/<package_name>/datasets/<name>.py`, rename the class, and fill in
   `_load`/`_save`.
4. Register it in `catalog.yml` via its full dotted import path, e.g.:
```yaml
   my_dataset:
     type: my_project.datasets.custom_api_dataset.CustomAPIDataset
     ...
```
5. Only fall back to inline I/O inside a node as a last resort, and flag it
   explicitly as a known compromise (e.g. a `# TODO: replace with catalog
   dataset` comment) rather than silently.

## Red flags to catch in review
- `open(...)`, `requests.get(...)`, `pd.read_*`/`pd.to_*` with a literal path,
  boto3/cloud SDK calls, or DB connections appearing inside a node function
  body.
