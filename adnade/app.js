import {} from "dotenv/config";
import { chromium } from "playwright";

(async () => {
  log("==== playwright.launch ====");
  const browserConfig = {
    headless: true,
    ignoreDefaultArgs: ["--enable-automation"],
    acceptDownloads: true,
  };
  const browser = await chromium.launch(browserConfig);
  log("==== playwright.launch done ====");

  await openAdnade(
    browser,
    process.env.ADNADE_USERNAME,
    process.env.DEVICE_NAME
  );

  const proxyArray = (process.env.PROXY_LIST || "").split(",");
  const authArray = (process.env.PROXY_AUTH_LIST || "").split(", ");

  for (let i = 0; i < proxyArray.length; i++) {
    await openAdnade(
      browser,
      process.env.ADNADE_USERNAME,
      `${process.env.DEVICE_NAME}_${i}`,
      proxyArray[i],
      authArray[i]
    );
  }
})();

async function openAdnade(browser, username, subid, proxy = "", auth = "") {
  let browserContext;
  if (proxy) {
    const proxySetting = {
      server: proxy,
    };
    if (auth) {
      proxySetting.username = auth.split(":")[0];
      proxySetting.password = auth.split(":")[1];
    }
    browserContext = await browser.newContext({
      proxy: proxySetting,
    });
  } else {
    browserContext = await browser.newContext();
  }
  browserContext.setDefaultTimeout(0);
  const page = await browserContext.newPage();
  await page.goto(`https://adnade.net/view.php?user=${username}&multi=4`);
  setInterval(() => {
    page.screenshot({
      path: `screenshot/view_${proxy.replace("//", "")}.png`,
      fullPage: true,
    });
  }, 60000);
  log(`Open view with proxy ${proxy} successfully.`)

  if (!proxy) {
    // open ptp
    const page1 = await browserContext.newPage();
    await page1.goto(`https://adnade.net/ptp/?user=${username}&subid=${subid}`);
    setInterval(() => {
      page1.screenshot({
        path: `screenshot/ptp.png`,
        fullPage: true,
      });
    }, 60000);
    log("Open ptp successfully.")
  }
}

function log(...args) {
  console.log("[adnade] ", getCurrentTime(), ...args);
}

function getCurrentTime(date) {
  if (!date) {
    date = new Date();
  }
  return `${
    date.getMonth() + 1
  }-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
}

Date.prototype.format = function (fmt) {
  const o = {
    "M+": this.getMonth() + 1,
    "d+": this.getDate(),
    "h+": this.getHours(),
    "m+": this.getMinutes(),
    "s+": this.getSeconds(),
    "q+": Math.floor((this.getMonth() + 3) / 3),
    S: this.getMilliseconds(),
  };
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(
      RegExp.$1,
      (this.getFullYear() + "").substr(4 - RegExp.$1.length)
    );
  }
  for (const k in o) {
    if (new RegExp("(" + k + ")").test(fmt)) {
      fmt = fmt.replace(
        RegExp.$1,
        RegExp.$1.length === 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length)
      );
    }
  }
  return fmt;
};
