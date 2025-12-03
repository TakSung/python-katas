# Test for Game Service
# TODO: GameService에 대한 단위 테스트를 작성합니다

from domain.game import Game, GameResult, AnswerType
from app.game_service import GameService

def test_새게임_생성_확인():
    # given
    game_service = GameService()
    # when
    game = game_service.new_game()
    # then
    assert isinstance(game, Game)