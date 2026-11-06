from hello.main import add, main


class TestBasicAddition:
    def test_basic_addition(self):
        assert add(2, 3) == 5

    def test_main_output(self, capsys):
        main()
        assert capsys.readouterr().out.strip() == "Hello, World!"
