// Pinboard bookmarklet that does a little extra.
//
// * It trims whitespace from the selection (if there is one)
// * It adds <blockquote> tags around the selected text on the page (if any is
//   selected)
// * It removes the trailing `?ref_=fn_al_nm_1` from IMDB pages so you know when
//   you're saving the same page twice just because it has a `ref` parameter
// * Removes all params from `theoutline.com` pages, for the same reason as IMDB
//   pages
// * It normalizes all Youtube video (i.e. not playlist) links by removing `?t=`
//   parameters and extra junk
//
// To convert to something you can use as a bookmarklet URL, this file must be
// uglified then URI-encoded. To do that, run
// `bin/pinboard-renegerate-bookmarklet`.

url = location.href;
withoutQueryParams =
  location.protocol + "//" + location.hostname + location.pathname;

if ("" !== document.getSelection().toString()) {
  d =
    "<blockquote>" +
    document.getSelection().toString().trim() +
    "</blockquote>";
} else {
  d = "";
}

hostsWithoutQueryParams = [
  "imdb.com",
  "theoutline.com",
  "twitter.com",
  "tiktok.com",
  "nytimes.com",
];

if (hostsWithoutQueryParams.indexOf(location.hostname) !== -1) {
  url = withoutQueryParams;
} else if (location.href.match(/youtube.com\/watch/)) {
  var u = new URL(location);
  var time = u.searchParams.get("t");
  url = withoutQueryParams + "?v=" + u.searchParams.get("v");
  if (time) {
    url += "&t=" + time;
  }
}
open(
  "https://pinboard.in/add?url=" +
    encodeURIComponent(url) +
    "&description=" +
    encodeURIComponent(d) +
    "&title=" +
    encodeURIComponent(document.title),
  "Pinboard",
  "toolbar=no,width=700,height=350"
);
