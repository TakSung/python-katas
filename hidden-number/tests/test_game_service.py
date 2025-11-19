# Test for Game Service
# TODO: GameService에 대한 단위 테스트를 작성합니다
from domain.game import Game, GuessResult
from app.game_service import GameService
from infra.random_generator import RandomGenerator

class FakeRandomGenerator(RandomGenerator):
    def __init__(self, fixed_number: int):
        self._fixed_number = fixed_number
        
    def generate(self) -> int:
        return self._fixed_number


def test_새로운_게임_생성():
    #given game service 생성 (난수 생성기)
    random_generator = FakeRandomGenerator(fixed_number = 50)
    game_service = GameService(generator=random_generator)
    
    #when 게임 생성
    new_game = game_service.new_game()
    
    #then 게임이 정상적인지 확인 
    assert new_game.guess(30) == GuessResult.TOO_LOW