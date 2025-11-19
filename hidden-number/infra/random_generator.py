# -*- coding: utf-8 -*-
# Random Number Generator
# TODO: 랜덤 숫자 생성 인터페이스와 구현체를 작성합니다
# - Protocol 또는 ABC로 인터페이스 정의
# - 1-100 사이의 랜덤 숫자 생성
from typing import Protocol

class RandomGenerator(Protocol):
    """1과 100 사이의 숫자를 생성하는 객체의 규칙을 정의합니다."""
    def generate(self) -> int:
        ...