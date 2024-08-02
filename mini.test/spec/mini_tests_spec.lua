describe("integration", function()
	require("mini.test").setup()
	-- This makes sure mini.test doesn't prevent busted tests from
	-- exiting with a non-zero exit code if it succeeds
	local opts = { quit_on_finish = false }
	local reporter = MiniTest.gen_reporter.stdout(opts)
	local all_cases
	local orig_start = reporter.start
	reporter.start = function(cases)
		all_cases = cases
    orig_start(cases)
	end
	local orig_finish = reporter.finish
	reporter.finish = function(...)
		local has_fails = vim.iter(all_cases):any(function(case)
        local fails = vim.tbl_get(case, "exec", "fails") or {}
        return #fails > 0
    end)
		if has_fails then
			vim.cmd("silent! 1cquit")
		end
		orig_finish(...)
	end
	local cases = MiniTest.collect()
	MiniTest.execute(cases, { reporter = reporter })
end)
