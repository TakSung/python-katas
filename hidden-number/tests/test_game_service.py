# Test for Game Service
# TODO: GameService에 대한 단위 테스트를 작성합니다
from domain.game import Game, GuessResult
from app.game_service import GameService
from infra.random_generator import RandomGenerator
import pytest

@pytest.fixture
def game_service():
    fake_generator = FakeRandomGenerator(fixed_number=50)
    service = GameService(generator=fake_generator)
    service.new_game()
    return service    

class FakeRandomGenerator(RandomGenerator):
    def __init__(self, fixed_number: int):
        self._fixed_number = fixed_number
        
    def generate(self) -> int:
        return self._fixed_number


def test_새로운_게임_생성(game_service: GameService):
    #when 게임 생성
    new_game = game_service.new_game()
    
    #then 게임이 정상적인지 확인 
    assert new_game.guess(30) == GuessResult.TOO_LOW
    
def test_process_guess_는_추측결과를_정확히_반환한다(game_service: GameService):
    result = game_service.process_guess(30)
    assert result == GuessResult.TOO_LOW
    assert game_service.current_game.attempts == 1    
    
def test_process_guess_는_정답보다_높은값을_축측하면_TOO_HIGH_를_반환한다(game_service: GameService):
    result = game_service.process_guess(70)
    assert result == GuessResult.TOO_HIGH
    assert game_service.current_game.attempts == 1   
    
def test_process_guess_는_정답을_맞히면_CORRECT_를_반환한다(game_service: GameService):
    result = game_service.process_guess(50)
    assert result == GuessResult.CORRECT
    assert game_service.current_game.attempts == 1   