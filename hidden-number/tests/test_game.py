# Test for Game Domain Entity
# TODO: Game 엔티티에 대한 단위 테스트를 작성합니다

from domain.game import Game, GuessResult
 

     
def test_축측한숫자가정답보다작은경우():
    game = Game(secret_number=50)
    result = game.guess(30)
    assert result == GuessResult.TOO_LOW
    
def test_축측한숫자가정답인경우():
    game = Game(secret_number=50)
    result = game.guess(50)
    assert result == GuessResult.CORRECT
    
def test_축측한숫자가정답보다큰경우():
    game = Game(secret_number=50)
    result = game.guess(80)
    assert result == GuessResult.TOO_HIGH

