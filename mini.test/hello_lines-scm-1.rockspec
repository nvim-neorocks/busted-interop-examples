rockspec_format = '3.0'
-- TODO: Rename this file and set the package
package = "hello_lines"
version = "scm-1"
source = {
  -- TODO: Update this URL
  url = "git+https://github.com/nvim-neorocks/luarocks-stub"
}
dependencies = {
  -- Add runtime dependencies here
  -- e.g. "plenary.nvim",
}
test_dependencies = {
  "nlua",
  "mini.test",
}
build = {
  type = "builtin",
}
