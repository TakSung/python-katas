# Test for Game Service
# TODO: GameService에 대한 단위 테스트를 작성합니다
import pytest
from dataclasses import dataclass

from domain.game import Game, GameResult, AnswerType
from domain.protocols import NumberGenerator
from app.game_service import GameService

@dataclass(frozen=True)
class FixNumberGenerator(NumberGenerator):
    number:int
    def generate(self) -> int:
        return self.generate()

@pytest.fixture
def game_service()-> GameService:
    number_generator = FixNumberGenerator(50)
    game_service = GameService(number_generator)
    game_service.new_game()
    return game_service

def test_새게임_생성_확인(game_service: GameService):
    # given
    # when
    game = game_service.new_game()
    # then
    assert isinstance(game, Game)
    assert game_service.game is not None

def test_정답_추측에_성공(game_service: GameService):
    # given
    
    # when
    result = game_service.guess(50).unwrap()
    
    # then
    assert result == AnswerType.CORRECT

def test_낮은_숫자_실패(game_service: GameService):
    # given
    
    # when
    result = game_service.guess(49).unwrap()
    
    # then
    assert result == AnswerType.TOO_LOW
    
def test_높은_숫자_실패(game_service: GameService):
    # given
    
    # when
    result = game_service.guess(99).unwrap()
    
    # then
    assert result == AnswerType.TOO_HIGH