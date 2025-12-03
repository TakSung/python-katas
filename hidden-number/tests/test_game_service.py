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
        return self.number

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
def test_추측에_따른_숫자판별_검증(game_service: GameService, guess_number: int, expected: GameResult):
    # given
    # when
    result = game_service.guess(guess_number).unwrap().hint
    
    # then
    assert result == expected

@pytest.mark.parametrize(
    "guess_number, expected, start_attempt",
    [
        (50, GameResult.WIN, 0),
        (49, GameResult.IN_PROGRESS, 0),
        (99, GameResult.LOSE, 9)
    ]
)
def test_추측에_따른_게임상태_검증(guess_number: int, expected: GameResult, start_attempt: int):
    # given
    game_service = GameService(FixNumberGenerator(50), Game(50,start_attempt))
    
    # when
    result = game_service.guess(guess_number).unwrap().result
    
    # then
    assert result == expected
