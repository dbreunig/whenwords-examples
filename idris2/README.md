# whenwords: POC Idris2 implementation

[Idris2](https://github.com/idris-lang/Idris2/tree/v0.8.0) library implementation by
[DeepSeek 3.1 Terminus](https://openrouter.ai/deepseek/deepseek-v3.1-terminus) via
[Crush AI](https://github.com/charmbracelet/crush)

Prompt:

```
You have following bash tools:
1. System compiler:
/root/.idris2/bin/idris2 --check --log 50 Sample.idr
2. Ask compiler about hole context, where hole is a "?hole" in code:
echo -e ':color off\n :load "Sample.idr"\n :ti hole' | /root/.idris2/bin/idris2
3. Ask compiler about type declarations, where some_function in code is a top level function or data:
echo -e ':color off\n :load "Sample.idr"\n :di some_function' | /root/.idris2/bin/idris2

Implement Idris2 library according to specification. By the end of implementation run tests to make sure that all is fine and fix code if needed.
```

Full implementation required to repeat the prompt few times:

```
run tests to make sure that all is fine and fix code if needed
```

Overall generation took ~3 hours and spent ~3.5$ at OpenRouter.