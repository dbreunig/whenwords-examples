import utest.Runner;
import utest.ui.Report;

class TestRunner {
    static function main() {
        var runner = new Runner();
        runner.addCase(new TestWhenwords());
        Report.create(runner);
        runner.run();
    }
}
