# Test for Random Generator
# TODO: RandomGenerator에 대한 단위 테스트를 작성합니다
from infra.random_generator import SystemRandomGenerator


def test_system_random_generator_returns_number_in_range():
    #system_random_generator을 생성한다
    randomgenerator = SystemRandomGenerator()
    #숫자 생성
    result = randomgenerator.generate()
    # 1에서 100사이인지 확인 - (생성된 숫자 필요)
    assert (1<= result <=100) 