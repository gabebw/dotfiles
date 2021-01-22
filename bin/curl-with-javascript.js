// vim: syntax=javascript
// Set up:
//    yarn global add playwright@1.8.0
// Then run:
//    NODE_PATH="$(yarn global dir)/node_modules/" node curl-with-javascript.js <URL>

const playwright = require('playwright');

const url = process.argv[2];

if(!url){
  console.error("!!! You must provide a URL");
  process.exit(1);
}

(async () => {
  const browser = await playwright.chromium.launch();
  const page = await browser.newPage();
  await page.goto(url);
  const content = await page.content();

  console.log(content);

  await browser.close();
})();
