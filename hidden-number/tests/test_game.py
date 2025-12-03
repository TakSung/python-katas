# Test for Game Domain Entity
# TODO: Game 엔티티에 대한 단위 테스트를 작성합니다

from domain.game import Game, AnswerType

def test_추측한_숫자가_정답보다_작은_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(30).last_answer
    
    # then
    assert result == AnswerType.TOO_LOW
    
def test_추측한_숫자가_정답보다_큰_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(70).last_answer
    
    # then
    assert result == AnswerType.TOO_HIGH
    
def test_추측한_숫자가_정답과_같은_경우():
    # given
    game = Game(secret_number=50)
    
    # when
    result = game.guess(50).last_answer
    
    # then
    assert result == AnswerType.CORRECT
    
def test_횟수_추측():
    # given
    game = Game(secret_number=50)
    
    # when
    last_num = 0
    for i in range(1,100):
        last_num = i
        game = game.guess(i)
        result = game.last_answer
        if result == AnswerType.CORRECT :
            break
    
    # then
    assert last_num == 50
    assert game.attempt == 50

def test_최대_시도_횟수_검증():
    # given
    game = Game(secret_number=50)
    max_attempt = 10 
    assert max_attempt == game.MAX_ATTEMPTS
    
    # when
    for i in range(max_attempt):
        assert not game.is_game_over()
        game = game.guess(49)
    
    # then
    assert game.is_game_over()