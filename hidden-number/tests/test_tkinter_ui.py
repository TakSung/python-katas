import tkinter as tk 
import pytest 
from unittest.mock import Mock 

from ui.tkinter_ui import TkinterUI 
from app.game_service import GameService
from domain.game import GuessResult

def test_guess_updates_result_label():
    """
    사용자가 추측했을 때, 그 결과가 UI 결과 레이블에 업데이즈되는지 테스트합니다.
    """
    mock_game_service = Mock(spec = GameService)
    mock_game_service.process_guess.return_value = GuessResult.TOO_HIGH
    
    root = tk.Tk()
    ui = TkinterUI(root,game_service=mock_game_service)
    
    ui.entry_var.set("80")
    ui.handle_guess()
    
    assert ui.result_label.cget("text") == "더 작은 수입니다!"
    
    mock_game_service.process_guess.assert_called_once_with(80)
    
    root.destroy()