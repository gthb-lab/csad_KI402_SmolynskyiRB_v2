from src.hello import add


def test_BasicAddition():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
