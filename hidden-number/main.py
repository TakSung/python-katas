# Hidden Number Game - Entry Point
# TODO: 여기서 의존성을 조립하고 게임을 시작합니다

from tkinter import Tk
from dataclasses import dataclass

from app.game_service import GameService
from infra.random_generator import RandomNumberGenerator, NumberGenerator
from ui.tkinter_ui import TkinterUI

@dataclass
class ObjectContainer:
    generator : NumberGenerator
    game_service : GameService
    ui : TkinterUI
    tk : Tk

def inject_object_dependency()-> ObjectContainer:
    generator = RandomNumberGenerator()
    game_service = GameService(generator)
    game_service.new_game()
    tk = Tk()
    ui = TkinterUI(root=tk, game_service=game_service)
    
    return ObjectContainer(
        generator=generator,
        game_service=game_service,
        ui = ui,
        tk = tk
    )

def run(container : ObjectContainer):
    ui = container.ui
    
    ui.start_app()

if __name__ == "__main__":
    container = inject_object_dependency()
    run(container)