import fs from "node:fs";
import path from "node:path";
import url from "node:url";
import zlib from "node:zlib";

let __filename = url.fileURLToPath(import.meta.url);
let __dirname = path.dirname(__filename);

let uasCompressed = fs.readFileSync(path.join(__dirname, "uas.txt.gz"));
let uas = zlib.gunzipSync(uasCompressed).toString('utf-8').split("\n");

// Derived from isbot.
// https://www.npmjs.com/package/isbot
let re = / daum[ /]| deusu\/| yadirectfetcher|(?:^| )site|(?:^|[^g])news|@[a-z]|\(at\)[a-z]|\(github\.com\/|\[at\][a-z]|^12345|^<|^[\w \.\-\(\)]+(\/v?\d+(\.\d+)?(\.\d{1,10})?)?$|^[^ ]{50,}$|^active|^ad muncher|^amaya|^anglesharp\/|^anonymous|^avsdevicesdk\/|^axios\/|^bidtellect\/|^biglotron|^btwebclient\/|^castro|^clamav[ /]|^client\/|^cobweb\/|^coccoc|^custom|^ddg[_-]android|^discourse|^dispatch\/\d|^downcast\/|^duckduckgo|^facebook|^fdm[ /]\d|^getright\/|^gozilla\/|^hatena|^hobbit|^hotzonu|^hwcdn\/|^jeode\/|^jetty\/|^jigsaw|^linkdex|^lwp[-: ]|^metauri|^microsoft bits|^movabletype|^mozilla\/\d\.\d \(compatible;?\)$|^mozilla\/\d\.\d \w*$|^navermailapp|^netsurf|^offline explorer|^php|^postman|^postrank|^python|^read|^reed|^restsharp\/|^snapchat|^space bison|^svn|^swcd |^taringa|^test certificate info|^thumbor\/|^tumblr\/|^user-agent:mozilla|^valid|^venus\/fedoraplanet|^w3c|^webbandit\/|^webcopier|^wget|^whatsapp|^xenu link sleuth|^yahoo|^yandex|^zdm\/\d|^zoom marketplace\/|^{{.*}}$|adbeat\.com|appinsights|archive|ask jeeves\/teoma|bit\.ly\/|bluecoat drtr|(?<! cu)bot|browsex|burpcollaborator|capture|catch|check|chrome-lighthouse|chromeframe|cloud|crawl|cryptoapi|dareboost|datanyze|dataprovider|dejaclick|dmbrowser|download|evc-batch\/|feed|firephp|freesafeip|ghost|gomezagent|(?<! (?:channel\/|google\/))google(?!(app|\/google| pixel))|headlesschrome\/|(?<!(?:lib))http|httrack|hubspot marketing grader|hydra|ibisbrowser|images|iplabel|ips-agent|java(?!;)|library|mail\.ru\/|manager|monitor|morningscore\/|neustar wpm|nutch|offbyone|optimize|pageburst|pagespeed|perl|phantom|pingdom|powermarks|preview|proxy|ptst[ /]\d|reader|rexx;|rigor|rss|scan|scrape|(?<! ya(?:yandex)?)search|serp ?reputation ?management|server|sogou|sparkler\/|speedcurve|spider|splash|statuscake|stumbleupon\.com|supercleaner|synapse|synthetic|taginspector\/|torrent|tracemyfile|transcoder|trendsmapresolver|twingly recon|url|virtuoso|wappalyzer|webglance|webkit2png|websitemetadataretriever|whatcms\/|wordpress|zgrab/;

let before = performance.now();
let c = 0;
for (let ua of uas) {
  c += re.test(ua);
}
let after = performance.now();
console.log(`${c} lines processed`); // prevent dead code stripping

console.log(`took ${after - before} ms`);
