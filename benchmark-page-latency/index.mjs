import puppeteer from 'puppeteer';

let pagesToTest = [
  // some SVG, some JS
  'http://127.0.0.1:9001/',

  // more JS
  'http://127.0.0.1:9001/demo/',

  // lots of SVG
  'http://127.0.0.1:9001/blog/cpp-vs-rust-build-times/',

  // Asciidoc (Opal)
  'http://127.0.0.1:9001/cli/',

  // Markdown
  'http://127.0.0.1:9001/releases/',

  // basically no server code
  'http://127.0.0.1:9001/merch/',
];

async function mainAsync() {
  const browser = await puppeteer.launch({headless: 'new'});
  const page = await browser.newPage();

  await page.setViewport({width: 1920, height: 1080});

  for (let i = 0; i < 30; ++i) {
    for (let url of pagesToTest) {
      await sleepAsync(100);
      let before = performance.now();
      await page.goto(url);
      let after = performance.now();
      if (i >= 3) {
        console.log(`${url},${after - before}`);
      }
    }
  }

  await browser.close();
}

function sleepAsync(milliseconds) {
  return new Promise(r => setTimeout(r, milliseconds));
}

mainAsync().catch((error) => {
  console.error(error.stack ?? error);
});
