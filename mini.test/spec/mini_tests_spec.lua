describe("integration", function()
	require("mini.test").setup()
	local cases = MiniTest.collect()
	-- This makes sure mini.test doesn't prevent busted tests from
	-- exiting with a non-zero exit code if it succeeds
	local opts = { quit_on_finish = false }
	local reporter = MiniTest.gen_reporter.stdout(opts)
	-- HACK: mini.tests doesn't have an API to determine if tests have failed
	-- We can work around this by detecting failures in `reporter.update`
	-- and then exiting with a non-zero exit code in `reporte.finish` if we detected one.
	local has_fails
	local orig_update = reporter.update
	reporter.update = function(case_num)
		local case = cases[case_num]
		local fails = vim.tbl_get(case, "exec", "fails") or {}
		if #fails > 0 then
			has_fails = true
		end
		orig_update(case_num)
	end
	local orig_finish = reporter.finish
	reporter.finish = function(...)
		if has_fails then
			vim.cmd("silent! 1cquit")
		end
		orig_finish(...)
	end
	MiniTest.execute(cases, { reporter = reporter })
end)
