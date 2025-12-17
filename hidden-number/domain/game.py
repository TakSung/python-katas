# Game Domain Entity
# TODO: dataclass를 사용하여 Game 엔티티를 정의합니다
# - 불변성(frozen=True)
# - 게임 상태 (숨겨진 숫자, 시도 횟수, 게임 종료 여부 등)

from enum import Enum, auto
from dataclasses import dataclass

class GuessResult(Enum):
    TOO_LOW = auto()
    TOO_HIGH = auto()
    CORRECT = auto()
    OUT_OF_RANGE = auto()

@dataclass
class Game:
    secret_number : int
    attempts : int = 0

    def guess(self, guessed_number):
        self.attempts += 1
        if guessed_number < self.secret_number:
            return GuessResult.TOO_LOW
        elif guessed_number > self.secret_number:
            return GuessResult.TOO_HIGH
        elif guessed_number < 1 or guessed_number > 100:
            return GuessResult.OUT_OF_RANGE
        else:
            return GuessResult.CORRECT 
            