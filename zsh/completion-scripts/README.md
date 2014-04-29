This is where I put any extra ZSH completion scripts. Currently it only has symbolic links, since RVM and Homebrew get updated so frequently.
If you're interested, you can these symbolic links via:

<pre>
<code>
  ln -s `brew --prefix`/Library/Contributions/brew_zsh_completion.zsh .
  ln -s $rvm_path/scripts/zsh/Completion/_rvm .
</code>
</pre>

This directory is added to ZSH's <code>$fpath</code> variable before running compinit so
that compinit doesn't have to run more than once, since that takes forever.
