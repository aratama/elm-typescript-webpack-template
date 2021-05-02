import { Elm } from "./Main";

import "./index.scss";

// MODE is a compile time constant defined by DefinePlugin.
// see webpack.config.json
declare const MODE: string;

console.log(`MODE=${MODE}`);

// TODO: replace with a callback function like `onAuthStateChanged` of firebase
setTimeout(() => {
  const user = localStorage.getItem("user");

  const node = document.getElementById("main");

  if (!node) {
    throw new Error("#main not found");
  }

  const elm = Elm.Main.init({ node, flags: { user: user ? JSON.parse(user) : null } });

  elm.ports.requestItem.subscribe((key: string) => {
    const value = localStorage.getItem(key);
    elm.ports.receiveItem.send({ key, value });
  });

  elm.ports.setItem.subscribe(({ key, value }) => {
    localStorage.setItem(key, value);
  });

  elm.ports.signIn.subscribe(({ email, password }) => {
    // TODO: replace with a function like `signInEmailAndPassword` of firebase
    setTimeout(() => {
      const user = { email, displayName: email, emailVerified: true };
      localStorage.setItem("user", JSON.stringify(user));
      elm.ports.authStateChanged.send(user);
    }, 1000);
  });

  elm.ports.signOut.subscribe(() => {
    // TODO: replace with a function like `signOut` of firebase
    setTimeout(() => {
      localStorage.removeItem("user");
      elm.ports.authStateChanged.send(null);
    }, 1000);
  });
}, 100);
