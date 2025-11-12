# Test for Game Domain Entity
# TODO: Game 엔티티에 대한 단위 테스트를 작성합니다

from domain.game import Game, AnswerType

def test_추측한_숫자가_정답보다_작은_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(30)
    
    # then
    assert result == AnswerType.TOO_LOW
    
def test_추측한_숫자가_정답보다_큰_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(70)
    
    # then
    assert result == AnswerType.TOO_HIGH
    
def test_추측한_숫자가_정답과_같은_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(50)
    
    # then
    assert result == AnswerType.CORRECT