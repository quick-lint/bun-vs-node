import child_process from 'node:child_process';
import fs from 'node:fs';
import puppeteer from 'puppeteer';
import util from 'node:util';

let execFileAsync = util.promisify(child_process.execFile);

let pagesToTest = [
  // some SVG, some JS
  'http://localhost:9001/',

  // more JS
  'http://localhost:9001/demo/',

  // lots of SVG
  'http://localhost:9001/blog/cpp-vs-rust-build-times/',

  // Asciidoc (Opal)
  'http://localhost:9001/cli/',

  // Markdown
  'http://localhost:9001/releases/',

  // basically no server code
  'http://localhost:9001/merch/',
];

let running = false;

async function mainAsync() {
  const browser = await puppeteer.launch({headless: 'new'});
  try {
    const page = await browser.newPage();
    await page.setViewport({width: 1920, height: 1080});

    let pids = process.platform === 'linux' ? await getServerProcessIDsAsync() : [];
    running = true;
    await Promise.all([benchmarkAsync(page), logMemoryUsageAsync(pids)]);
  } finally {
    await browser.close();
  }
}

async function getServerProcessIDsAsync() {
  let mainPID = parseInt(fs.readFileSync('../server.pid'), 10);
  let {stdout, stderr} = await execFileAsync('pstree', ['--show-pids', '--hide-threads', '--ascii', mainPID]);
  return [...stdout.matchAll(/\((\d+)\)/g)].map(match => parseInt(match[1], 10));
}

async function benchmarkAsync(page) {
  try {
    for (let i = 0; i < 30; ++i) {
      for (let url of pagesToTest) {
        await sleepAsync(100);
        let before = performance.now();
        await page.goto(url);
        let after = performance.now();
        if (i >= 3) {
          console.log(`load,${url},${after - before}`);
        }
      }
    }
  } finally {
    running = false;
  }
}

async function logMemoryUsageAsync(pids) {
  while (running) {
    console.log(`mem,${performance.now()},${getMemoryUsageForProcesses(pids)}`);
    await sleepAsync(100);
  }
}

function getMemoryUsageForProcesses(pids) {
  return pids.reduce((acc, pid) => acc + getMemoryUsageForProcess(pid), 0);
}

function getMemoryUsageForProcess(pid) {
  let smapsLines = fs.readFileSync(`/proc/${pid}/smaps_rollup`, 'utf-8').split('\n');
  for (let line of smapsLines) {
    if (line.startsWith("Rss:")) {
      let kbText = line.match(/\d+/)[0];
      return parseInt(kbText, 10) * 1024;
    }
  }
  throw new Error(`failed to get memory usage for process ${pid}`);
}

function sleepAsync(milliseconds) {
  return new Promise(r => setTimeout(r, milliseconds));
}

mainAsync().catch((error) => {
  console.error(error.stack ?? error);
});
