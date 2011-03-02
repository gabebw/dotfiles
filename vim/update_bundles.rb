#!/usr/bin/env ruby
# From https://github.com/tsaleh/dotfiles/blob/master/vim/update_bundles

require 'fileutils'
require 'open-uri'

# Ragel doesn't have a git repo or vim script, it's just hosted by the Ragel
# maintainer.
RAGEL_URL = 'http://www.complang.org/ragel/ragel.vim'
RAGEL_FILE = 'ragel/syntax/ragel.vim'

# Where we put zip files from vim.org/scripts/
TEMP_ZIP_NAME = 'temp.zip'
# Where we extract the zipfile to
TEMP_ZIP_DIR = 'temp_zip_dir'

def update_ragel
  FileUtils.mkdir_p("ragel/syntax")
  File.open(RAGEL_FILE, 'w') do |file|
    file << open(RAGEL_URL).read
  end
end


def update_pathogen
  # Not in bundle/, so do it by hand
  Dir.chdir(File.join(File.dirname(__FILE__), 'autoload')) do
    File.open('pathogen.vim', 'w') do |f|
      f << open('https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim').read
    end
  end
end

$git_bundles = [
  #"git://github.com/astashov/vim-ruby-debugger.git",
  #"git://github.com/godlygeek/tabular.git",
  #"git://github.com/hallison/vim-rdoc.git",
  "git://github.com/pangloss/vim-javascript.git",
  "git://github.com/scrooloose/nerdtree.git",
  #"git://github.com/timcharper/textile.vim.git",
  #"git://github.com/tpope/vim-repeat.git",
  #"git://github.com/tpope/vim-surround.git",
  #"git://github.com/tpope/vim-vividchalk.git",
  "git://github.com/tsaleh/vim-matchit.git",
  "git://github.com/tsaleh/vim-supertab.git", # tab completion
  #"git://github.com/tsaleh/vim-tcomment.git",
  #"git://github.com/msanders/snipmate.vim.git",
  "git://github.com/kchmck/vim-coffee-script.git",
  "git://github.com/tpope/vim-cucumber.git",
  "git://github.com/tpope/vim-fugitive.git",
  "git://github.com/tpope/vim-git.git",
  "git://github.com/tpope/vim-haml.git",
  "git://github.com/tpope/vim-markdown.git",
  "git://github.com/tpope/vim-rails.git",
  "git://github.com/tsaleh/vim-shoulda.git",
  "git://github.com/vim-ruby/vim-ruby.git",
]

# [name, script_id, script type]
# e.g. ["jquery",        "12276", "syntax"]
# puts script id 12276 in bundle/jquery/syntax/jquery.vim
$vim_org_scripts = [
  # http://www.vim.org/scripts/script.php?script_id=1682
  # 7062: v070503
  #["IndexedSearch", "7062",  "plugin"],
  # http://www.vim.org/scripts/script.php?script_id=2423
  # 14204: v4.5
  #["gist",          "14204", "plugin"],
  # http://www.vim.org/scripts/script.php?script_id=2416
  # 12276: v0.4
  ["jquery",        "12276", "syntax"],
  # highlight hex colors, so #FF0000 displays in red
  # 8846: v0.7 (2007-06-24)
  ["css", 8846, "syntax"],
  # http://www.vim.org/scripts/script.php?script_id=910
  # 14079: v1.3.3
  ["pydoc", 14079, "plugin"],

  # http://www.vim.org/scripts/script.php?script_id=2441
  # 14288: v3.0
  # 4-element array to mark it as a zip
  ["pyflakes", 14288, "ftplugin", "zip"],
]


def setup
  bundles_dir = File.join(File.dirname(__FILE__), "bundle")

  FileUtils.cd(bundles_dir)

  puts "trashing everything (lookout!)"
  Dir["*"].each {|d| FileUtils.rm_rf d }
end


def update_git_bundles
  $git_bundles.each do |url|
    dir = url.split('/').last.sub(/\.git$/, '')
    puts "Unpacking #{url} into #{dir}"
    `git clone #{url} #{dir}`
    FileUtils.rm_rf(File.join(dir, ".git"))
  end
end

def update_vim_org_scripts
  $vim_org_scripts.each do |name, script_id, script_type, zip|
    puts "Downloading #{name}"
    if zip
      # pyflakes/ftplugin
      target_dir = File.join(name, script_type)
      FileUtils.mkdir_p(target_dir)
      File.open(TEMP_ZIP_NAME, "w") do |file|
        file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
      end
      `unzip #{TEMP_ZIP_NAME} -d #{TEMP_ZIP_DIR}`
      FileUtils.mv(Dir.glob(TEMP_ZIP_DIR + '/*'), target_dir)
      # Clean up
      FileUtils.rm(TEMP_ZIP_NAME)
      FileUtils.rm_rf(TEMP_ZIP_DIR)
    else
      # pyflakes/ftplugin/pyflakes.vim
      local_file = File.join(name, script_type, "#{name}.vim")
      FileUtils.mkdir_p(File.dirname(local_file))
      File.open(local_file, "w") do |file|
        file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
      end
    end
  end

  # Patch pydoc so that K doesn't call Python help in non-python files
  # Also: the first time I've actually found a use for Array#assoc
  pydoc = $vim_org_scripts.assoc('pydoc')
  if pydoc
    pydoc_type = pydoc[2]
    print "Patching pydoc..."
    STDOUT.flush
    # Currently in /bundle dir, so path is relative to that
    `sed -E -i '' -e 's/^(nnoremap .* K :call)/au FileType python \\1/' pydoc/#{pydoc_type}/pydoc.vim`
    puts "done."
  end
end

def update_all
  setup
  update_pathogen
  update_ragel
  update_git_bundles
  update_vim_org_scripts
end

update_all if $0 == __FILE__
