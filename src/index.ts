import { Elm } from "./Main";

import "./index.scss";

// MODE is a compile time constant defined by DefinePlugin.
// see webpack.config.json
declare const MODE: string;

console.log(`MODE=${MODE}`);

const node = document.getElementById("main");

if (!node) {
  throw new Error("#main not found");
}

const count = localStorage.getItem("count");

const elm = Elm.Main.init({ node, flags: count ? parseInt(count) : 0 });

elm.ports.requestItem.subscribe((key: string) => {
  const value = localStorage.getItem(key);
  elm.ports.receiveItem.send({ key, value });
});

elm.ports.setItem.subscribe(({ key, value }) => {
  localStorage.setItem(key, value);
});
