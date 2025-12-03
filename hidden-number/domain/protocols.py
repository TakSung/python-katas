from typing import Protocol

class NumberGenerator(Protocol):
    def generate(self) -> int:
        ...