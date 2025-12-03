# -*- coding: utf-8 -*-
# Game Domain Entity
# TODO: dataclass를 사용하여 Game 엔티티를 정의합니다
# - 불변성(frozen=True)
# - 게임 상태 (숨겨진 숫자, 시도 횟수, 게임 종료 여부 등)

from dataclasses import dataclass, replace
from enum import Enum
from typing import Optional, Self

class AnswerType(Enum):
    TOO_LOW = "더 낮음"
    TOO_HIGH = "더 높음"
    CORRECT = "정답"

class GameResult(Enum):
    WIN = "승리"
    LOSE = "패배"
    IN_PROGRESS = "진행중"

@dataclass(frozen=True)
class Game:
    # 이 변수들은 인스턴스가 생성될 때마다 달라지는 값입니다.
    secret_number:int
    attempt:int = 0 # 디폴트 값은 0, 테스트를 위해서 지정 가능
    last_answer: Optional[AnswerType] = None
    
    # 이 변수는 Game 클래스 자체에 속하며 모든 인스턴스가 공유합니다.
    MAX_ATTEMPTS:int = 10 # 게임 전체에 동일하게 설정
    
    def guess(self, guess_number:int) -> Self:
        answer = self._evaluate_guess(guess_number)
        
        return replace(
            self,
            attempt=self.attempt+1,
            last_answer=answer
        )
    
    def _evaluate_guess(self, guess_number:int) -> AnswerType:
        if self.secret_number > guess_number:
            return AnswerType.TOO_LOW
        elif self.secret_number == guess_number:
            return AnswerType.CORRECT
        else:
            return AnswerType.TOO_HIGH
    
    def game_status(self) -> GameResult:
        if self.last_answer == AnswerType.CORRECT:
            return GameResult.WIN
        elif self.is_attempt_limit_reached():
            return GameResult.LOSE
        else :
            return GameResult.IN_PROGRESS
    
    def is_attempt_limit_reached(self) -> bool:
        return self.MAX_ATTEMPTS <= self.attempt

    