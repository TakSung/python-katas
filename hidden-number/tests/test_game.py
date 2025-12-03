# Test for Game Domain Entity
# TODO: Game 엔티티에 대한 단위 테스트를 작성합니다

from domain.game import Game, AnswerType, GameResult

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
    
def test_시도_횟수가_정확히_증가하는지_검증():
    # given
    game = Game(secret_number=50)
    
    # when
    game = game.guess(48).guess(49)
    
    # then
    assert game.attempt == 2

def test_최대_시도_횟수_검증():
    # given
    game = Game(secret_number=50)
    max_attempt = 10 
    assert max_attempt == game.MAX_ATTEMPTS
    
    # when
    for i in range(max_attempt):
        assert game.game_status() == GameResult.IN_PROGRESS
        game = game.guess(49)
    
    # then
    assert game.game_status() == GameResult.LOSE