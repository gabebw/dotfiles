---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "tpope/vim-rails",
    init = function()
      vim.g.rails_projections = {
        ["config/routes.rb"] = { command = "routes" },
        ["app/admin/*.rb"] = {
          command = "admin",
          alternate = "spec/controllers/admin/{singular}_controller_spec.rb",
        },
        ["spec/controllers/admin/*_controller_spec.rb"] = {
          alternate = "app/admin/{plural}.rb",
        },
        ["app/components/*.html.erb"] = {
          alternate = "app/components/{}.rb",
        },
        ["app/components/*.rb"] = {
          alternate = "app/components/{}.html.erb",
        },
        ["spec/factories/*.rb"] = { command = "factories" },
        ["spec/factories.rb"] = { command = "factories" },
        ["spec/features/*_spec.rb"] = { command = "feature" },
        ["config/locales/en/*.yml"] = {
          command = "tran",
          template = "en:\n  {underscore|plural}:\n    ",
        },
        ["app/services/*.rb"] = {
          command = "service",
          test = "spec/services/{}_spec.rb",
        },
        ["script/datamigrate/*.rb"] = {
          command = "datamigrate",
          template = "#!/usr/bin/env rails runner\n\n",
        },
        ["app/jobs/*_job.rb"] = {
          command = "job",
          template = "class {camelcase|capitalize|colons}Job < ActiveJob::Job\n  def perform(*)\n  end\nend",
          test = { "spec/jobs/{}_job_spec.rb" },
        },
      }
      vim.cmd [[
        augroup vim_rails
          autocmd!
          autocmd User Rails nnoremap <Leader>m :Emodel<Space>
          autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
          autocmd User Rails nnoremap <Leader>v :Eview<Space>
          autocmd User Rails nnoremap <Leader>u :Eunittest<Space>
          autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar A :exec 'edit '.rails#buffer().alternate()
          autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar AS :exec 'split '.rails#buffer().alternate()
          autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar AV :exec 'vsplit '.rails#buffer().alternate()
        augroup END
      ]]
    end,
  },
}
