from pathlib import Path, PurePosixPath
from typing import Any
from kedro.io import AbstractVersionedDataset
from kedro.io.core import get_filepath_str, get_protocol_and_path
import fsspec


class CustomDataset(AbstractVersionedDataset[Any, Any]):
    """
    TODO: Rename this class and update the docstring to describe what
    this dataset loads/saves and from where.
    """

    def __init__(
        self,
        filepath: str,
        version=None,
        credentials: dict = None,
        load_args: dict = None,
        save_args: dict = None
    ):
        protocol, path = get_protocol_and_path(filepath)
        self._protocol = protocol
        self._fs = fsspec.filesystem(protocol, **(credentials or {}))
        self._load_args = load_args or {}
        self._save_args = save_args or {}

        super().__init__(
            filepath=PurePosixPath(path),
            version=version,
            exists_function=self._fs.exists,
            glob_function=self._fs.glob,
        )

    def _load(self) -> Any:
        load_path = get_filepath_str(self._get_load_path(), self._protocol)
        # TODO: replace with the real load logic
        with self._fs.open(load_path, mode="rb") as f:
            raise NotImplementedError

    def _save(self, data: Any) -> None:
        save_path = get_filepath_str(self._get_save_path(), self._protocol)
        # TODO: replace with the real save logic
        with self._fs.open(save_path, mode="wb") as f:
            raise NotImplementedError

    def _describe(self) -> dict[str, Any]:
        return dict(
            filepath=self._filepath,
            protocol=self._protocol,
            version=self._version,
            load_args=self._load_args,
            save_args=self._save_args,
        )
