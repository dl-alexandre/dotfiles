return {
  -- Swift language extra module doesn't exist in LazyVim
  -- { import = "lazyvim.plugins.extras.lang.swift" },

  -- Add swiftformat (correct package name) for formatting
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "swiftformat")
    end,
  },
}
