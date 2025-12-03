# Tkinter GUI
# TODO: Tkinter를 사용하여 GUI를 구현합니다
# - 입력 필드
# - 추측 버튼
# - 결과 표시 레이블
# - 새 게임 버튼
import tkinter as tk 
from app.game_service import GameService
from domain.game import GuessResult


class TkinterUI:
    def __init__(self,root, game_service: GameService):
        self.root = root
        self.game_service = game_service
        self.game_service.new_game()    
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
        try:
            guessed_number_str = self.entry_var.get()
            guessed_number = int(guessed_number_str)
            
            result_enum = self.game_service.process_guess(guessed_number)  
            
            message = ""
            match result_enum:
                case GuessResult.TOO_HIGH:
                    message = "더 작은 수입니다!"
                case GuessResult.TOO_LOW:
                    message = "더 큰 수입니다!"
                case GuessResult.CORRECT:
                    message = "정답입니다!"
                case _:
                    message = "알 수 없는 결과입니다."
                    
            self.result_label.config(text= message)
        
        except ValueError:
            self.result_label.config(text= "유요한 숫자를 입력해주세요.")
            
        except Exception as e:
            self.result_label.config(text=f"오류 발생:{e}")
    
        
    

    def start(self):
        self.root.mainloop()
        

