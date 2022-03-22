# Psh, "no nodename or servname not provided". I'll do `whois
# http://google.com/hello` if I want.
function whois -a url
  command whois (echo $url | sed -E -e 's|^https?://||' -e 's|/.*$||g')
end
