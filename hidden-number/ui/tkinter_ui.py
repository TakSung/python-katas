# Tkinter GUI
# TODO: Tkinter를 사용하여 GUI를 구현합니다
# - 입력 필드
# - 추측 버튼
# - 결과 표시 레이블
# - 새 게임 버튼
import tkinter as tk 


class TkinterUI:
    def __init__(self,root):
        self.root = root
        self.root.title("Hidden Number 게임")
        self.root.geometry("300x200")

        title_label = tk.Label(self.root, text = "안내 문구를 여기에 표시합니다")
        title_label.pack()

        guess_button = tk.Button(self.root, text="클릭하세요!", command = None)
        guess_button.pack()

        result_label = tk.Label(self.root, text = "결과는 여기에 나타납니다.")
        result_label.pack()

    def start(self):
        self.root.mainloop()
        

