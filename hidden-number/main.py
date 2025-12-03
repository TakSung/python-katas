# Hidden Number Game - Entry Point
# TODO: 여기서 의존성을 조립하고 게임을 시작합니다
from ui.tkinter_ui import TkinterUI
from app.game_service import GameService
from infra.random_generator import RandomGenerator
import tkinter as tk

class FakeRandomGenerator(RandomGenerator):
    def __init__(self, fixed_number: int):
        self._fixed_number = fixed_number
        
    def generate(self) -> int:
        return self._fixed_number

if __name__ == "__main__":
    root = tk.Tk()
    
    app = TkinterUI(root, game_service= GameService(FakeRandomGenerator(50)))
    
    app.start()