# Tkinter GUI
# TODO: Tkinter를 사용하여 GUI를 구현합니다
# - 입력 필드
# - 추측 버튼
# - 결과 표시 레이블
# - 새 게임 버튼

import tkinter as tk
from tkinter import Tk, Label, Entry, Button

from app.game_service import GameService


class TkinterUI:
    
    def __init__(self, root:Tk, game_service:GameService):
        root.title("Hidden Number Game")
        root.geometry("300x200+500+300")
        label = Label(root, text="1부터 100 사이의 숫자를 맞춰보세요", font=("나눔고딕",16), bg="lightgray")
        entry_field = Entry(root, width=10, font=("나눔고딕",20))
        guess_button = Button(root, text="추측", font=("나눔고딕",16))
        
        
        label.pack(pady=30, side=tk.TOP)
        
        guess_button.pack(pady=5, side=tk.BOTTOM)
        entry_field.pack(pady=5, side=tk.BOTTOM)
        
        self.root = root
        self.entry_field = entry_field
        self.guess_button = guess_button
        self.message_label = label
        self.game_service = game_service
        
    def start_app(self):
        self.root.mainloop()