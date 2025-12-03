# Game Service - Application Logic
# TODO: 게임 비즈니스 로직을 구현합니다
# - 게임 초기화
# - 추측 검증 (higher, lower, correct)
# - 게임 상태 관리

from dataclasses import dataclass
from typing import Optional
from domain.game import Game

@dataclass
class GameService:
    game: Optional[Game] = None
    
    def new_game(self) -> Optional[Game]:
        self.game = Game(secret_number=50)
        return self.game