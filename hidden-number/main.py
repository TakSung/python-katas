# Hidden Number Game - Entry Point
# TODO: 여기서 의존성을 조립하고 게임을 시작합니다
from ui.tkinter_ui import TkinterUI
from app.game_service import GameService
from infra.random_generator import SystemRandomGenerator
import tkinter as tk


if __name__ == "__main__":
    root = tk.Tk()
    
    app = TkinterUI(root, game_service= GameService(SystemRandomGenerator()))
    
    app.start()