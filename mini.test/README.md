## [mini.test](https://github.com/echasnovski/mini.test/tree/main) and busted

This example combines mini.test and busted.

It assumes you want to do the following:

- Run pure unit tests with busted.
- Run impure integration tests with mini.test.

> [!NOTE]
>
> The mini.test example is based on [mini.test's quick demo](https://github.com/echasnovski/mini.nvim/blob/main/TESTING.md#quick-demo).

### Explanation

- We add both nlua and mini.test to our [rockspec's `test_dependencies`](./hello_lines-scm-1.rockspec)
- mini.test tests are in the `tests` directory.
- busted specs are in the `spec` directory.
  This can be modified using the [`.busted`](./.busted) configuration file
  if desired.
- mini.test is initialised and its test suite is executed from within
  busted, via a [`spec/mini_tests_spec.lua`](./spec/mini_tests_spec.lua) file.
- Because we initialise mini.tests in the busted spec file,
  there is no need to do so in [`scripts/minimal_init.lua`](./scripts/minimal_init.lua).

### Hacks

- mini.test, by default, exits with exit code `0` if tests succeed,
  which results in busted test failures not being detectable by CI.
  This behaviour can be disabled, but there appears to be no API to
  determine if mini.test tests have succeeded or not.
  We need to hack into the test reporter to do so.
  By doing this, we can ensure that the test runner exits with a non-zero exit code
  if either the mini.tests or the busted test suite has failed.

### Screenshots

Both suites succeeding:

![](https://github.com/user-attachments/assets/fe17f5e8-7bbe-43b2-a086-65cf279fa7c0)

Only busted failing:

![](https://github.com/user-attachments/assets/9f5f8b65-afce-4bd4-9755-d8a89e84f028)

Only mini.tests failing:

![](https://github.com/user-attachments/assets/84602104-137e-4d36-8ccf-cd0f4d676087)
