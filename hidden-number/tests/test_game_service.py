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

@pytest.mark.parametrize(
    "guess_number, expected",
    [
        (50, AnswerType.CORRECT),
        (49, AnswerType.TOO_LOW),
        (99, AnswerType.TOO_HIGH)
    ]
)
def test_추큭_결과_검증(game_service: GameService, guess_number: int, expected: AnswerType):
    # given
    # when
    result = game_service.guess(guess_number).unwrap()
    
    # then
    assert result == expected
