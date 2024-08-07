local restart_last = function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.cmd("OverseerRun")
  else
    overseer.run_action(tasks[1], "restart")
  end
end

vim.keymap.set("n", "<leader>tl", "<cmd>OverseerLoadBundle<CR>", {desc = "Load task what were saved to disk"})
vim.keymap.set("n", "<leader>tp", "<cmd>OverseerRun<CR>", {desc = "Pick and run task"})
vim.keymap.set("n", "<leader>ts", "<cmd>OverseerSaveBundle<CR>", {desc = "Serialize and save the current task to disk"})
vim.keymap.set("n", "<leader>ta", "<cmd>OverseerTaskAction<CR>", {desc = "Task action"})
vim.keymap.set("n", "<leader>r", restart_last, { desc = "Run last task in terminal" })


return {
  'stevearc/overseer.nvim',
  cmd = { "OverseerRun", "OverseerRestartLast", "OverseerLoadBundle" },
  config = function()

    require("overseer").setup({
      templates = { "builtin"},
      ---@diagnostic disable-next-line: assign-type-mismatch
      strategy = {
        "toggleterm",
        -- load your default shell before starting the task
        use_shell = false,
        -- overwrite the default toggleterm "direction" parameter
        direction = "float",
        -- have the toggleterm window close and delete the terminal buffer
        -- automatically after the task exits
        close_on_exit = false,
        -- have the toggleterm window close without deleting the terminal buffer
        -- automatically after the task exits
        -- can be "never, "success", or "always". "success" will close the window
        -- only if the exit code is 0.
        quit_on_exit = "never",
        -- open the toggleterm window when a task starts
        open_on_start = true,
        -- mirrors the toggleterm "hidden" parameter, and keeps the task from
        -- being rendered in the toggleable window
        hidden = false,
      },
    })
  end,
}
