# Random Number Generator
# TODO: 랜덤 숫자 생성 인터페이스와 구현체를 작성합니다
# - Protocol 또는 ABC로 인터페이스 정의
# - 1-100 사이의 랜덤 숫자 생성
from dataclasses import dataclass
from random import randint

from domain.protocols import NumberGenerator

@dataclass
class RandomNumberGenerator(NumberGenerator):
    begin: int = 1
    end: int = 100
    
    def generate(self):
        return randint(self.begin, self.end)