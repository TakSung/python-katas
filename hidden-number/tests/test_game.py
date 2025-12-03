# Test for Game Domain Entity
# TODO: Game 엔티티에 대한 단위 테스트를 작성합니다
import pytest
from domain.game import Game, AnswerType, GameResult

@pytest.fixture
def game() -> Game:
    return Game(secret_number=50)

def test_추측한_숫자가_정답보다_작은_경우(game: Game):
    # given
    # when
    result = game.guess(30).last_answer
    
    # then
    assert result == AnswerType.TOO_LOW
    
def test_추측한_숫자가_정답보다_큰_경우(game: Game):
    # given
    # when
    result = game.guess(70).last_answer
    
    # then
    assert result == AnswerType.TOO_HIGH
    
def test_추측한_숫자가_정답과_같은_경우(game: Game):
    # given
    # when
    result = game.guess(50).last_answer
    
    # then
    assert result == AnswerType.CORRECT
    
def test_시도_횟수가_정확히_증가하는지_검증(game: Game):
    # given
    # when
    game = game.guess(48).guess(49)
    
    # then
    assert game.attempt == 2

def test_최대_시도_횟수_검증(game: Game):
    # given
    max_attempt = 10 
    assert max_attempt == game.MAX_ATTEMPTS
    
    # when
    for i in range(max_attempt):
        assert game.game_status() == GameResult.IN_PROGRESS
        game = game.guess(49)
    
    # then
    assert game.game_status() == GameResult.LOSE

def test_마지막_시도에_정답을_맞추면_게임은_승리_상태이다(game: Game):
    # given
    start_num = 41
    max_attempt = 10 
    
    # when
    for guess_number in range(start_num, start_num+max_attempt):
        game = game.guess(guess_number)
    
    # then
    assert game.game_status() == GameResult.WIN

def test_게임이_진행중일때_게임_상태는_진행중이다(game: Game):
#     # given
    start_num = 40
    max_attempt = 10 
    
#     # when and then
    for guess_number in range(start_num, start_num+max_attempt):
        assert not game.is_attempt_limit_reached()
        assert game.game_status() == GameResult.IN_PROGRESS
        game = game.guess(guess_number)
    