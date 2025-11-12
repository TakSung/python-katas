# Game Domain Entity
# TODO: dataclass를 사용하여 Game 엔티티를 정의합니다
# - 불변성(frozen=True)
# - 게임 상태 (숨겨진 숫자, 시도 횟수, 게임 종료 여부 등)

from enum import Enum, auto

class GuessResult(Enum):
    TOO_LOW = auto()
    TOO_HIGH = auto()
    CORRECT = auto()

class Game:
    def __init__(self, secret_number):
        self.secret_number = secret_number

    def guess(self, guessed_number):
        if guessed_number < self.secret_number:
            return GuessResult.TOO_LOW
        elif guessed_number > self.secret_number:
            return GuessResult.TOO_HIGH
        else:
            return GuessResult.CORRECT 