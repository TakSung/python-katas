# Tkinter GUI
# TODO: Tkinter를 사용하여 GUI를 구현합니다
# - 입력 필드
# - 추측 버튼
# - 결과 표시 레이블
# - 새 게임 버튼
import tkinter as tk 
from app.game_service import GameService


class TkinterUI:
    def __init__(self,root, game_service: GameService):
        self.root = root
        self.game_service = game_service    
        self.root.title("Hidden Number 게임")
        self.root.geometry("300x200")

        self.entry_var = tk.StringVar(self.root)
        self.guess_entry = tk.Entry(self.root, textvariable= self.entry_var)
        self.guess_entry.pack(pady =10)
        
        self.guess_button = tk. Button(self.root, text="추측", command = self.handle_guess)
        self.guess_button.pack(pady= 5)
        
        self.result_label = tk.Label(self.root, text = "숫자를 입력하고 추측해 보세요")
        
        self.result_label.pack(pady = 10)
        
    def handle_guess(self):
        pass

    def start(self):
        self.root.mainloop()
        

