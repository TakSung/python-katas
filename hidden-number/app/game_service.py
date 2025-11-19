# Game Service - Application Logic
# TODO: 게임 비즈니스 로직을 구현합니다
# - 게임 초기화
# - 추측 검증 (higher, lower, correct)
# - 게임 상태 관리
from domain.game import Game
from infra.random_generator import RandomGenerator

class GameService:
    def __init__(self, generator: RandomGenerator):
        self._generator = generator
    
    def new_game(self) -> Game:
        secret_number = self._generator.generate()
        return Game(secret_number= secret_number)