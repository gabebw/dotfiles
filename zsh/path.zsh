########
# PATH #
########

# DO NOT SET PATH ANEW - always use $PATH and your stuff before/after it
# * note that setting it anew breaks rvm
# /etc/profile gives us these
# /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/X11/bin

# Removes duplicate PATH entries but keeps the original order.
trim_path() {
  # http://chunchung.blogspot.com/2007/11/remove-duplicate-paths-from-path-in.html
  export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'<<<$PATH)
}
# So I can tell ZSH to scan the PATH for newly-installed programs, without
# running the whole bootup process all over again. And yes, I used to use
# Gentoo.
# Wrap it in a function so it's evaluated at run-time.
env-update() { export PATH=$PATH; }

MANPATH=/usr/share/man:/usr/local/share/man:/usr/X11/share/man:/usr/X11/man:/usr/local/man

# TeX
pdflatex_dir='/usr/local/texlive/2010/bin/x86_64-darwin'
[[ -x ${pdflatex_dir}/pdflatex ]] && PATH="$PATH:$pdflatex_dir"
unset pdflatex_dir

# My scripts are always last. Use full path instead of ~/ so that "which" works.
PATH="$PATH:/Users/randy/bin"
PATH="/usr/local/bin:$PATH" # homebrew
