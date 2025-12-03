# Game Service - Application Logic
# TODO: 게임 비즈니스 로직을 구현합니다
# - 게임 초기화
# - 추측 검증 (higher, lower, correct)
# - 게임 상태 관리

from typing import Optional, List
from dataclasses import dataclass, field
from returns.result import Result, Success, Failure

from domain.game import Game, AnswerType, GameResult
from domain.protocols import NumberGenerator

@dataclass(frozen=True)
class GuessDto:
    hint :AnswerType
    result :GameResult

@dataclass
class GameService:
    number_generator: NumberGenerator
    game: Optional[Game] = None
    _history: List[Game] = field(default_factory=list)
    
    def _update_game(self, game:Game):
        assert isinstance(game, Game)
        assert isinstance(self._history, list)
        
        self.game = game
        self._history.append(game)
        return True
    
    def new_game(self) -> Optional[Game]:
        secret_number = self.number_generator.generate()
        self._update_game(Game(secret_number=secret_number))
        return self.game
    
    def guess(self, guess_number:int) -> Result[GuessDto, str]:
        if self.game is None:
            return Failure("게임 미생성 - GameService::new_game 후 진행해 주세요.")
        
        new_game = self.game.guess(guess_number)
        self._update_game(new_game)
        
        if new_game.last_answer is None:
            assert False # 이런 경우는 존재하지 않습니다.
            return Failure("Assertion 오류 : last_answer 미생성")
        
        return Success(GuessDto(new_game.last_answer, new_game.game_status()))