# -*- coding: utf-8 -*-
# Game Domain Entity
# TODO: dataclass를 사용하여 Game 엔티티를 정의합니다
# - 불변성(frozen=True)
# - 게임 상태 (숨겨진 숫자, 시도 횟수, 게임 종료 여부 등)

from dataclasses import dataclass
from enum import Enum

class AnswerType(Enum):
    TOO_LOW = "더 낮음"
    TOO_HIGH = "더 높음"
    CORRECT = "정답"
@dataclass
class Game:
    secret_number:int
    
    def guess(self, guess_number:int) -> AnswerType:
        if self.secret_number > guess_number:
            return AnswerType.TOO_LOW
        elif self.secret_number == guess_number:
            return AnswerType.CORRECT
        else:
            return AnswerType.TOO_HIGH

    