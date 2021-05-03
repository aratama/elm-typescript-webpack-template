import { Elm, User } from "./Main";

import "./index.scss";

// MODE is a compile time constant defined by DefinePlugin.
// see webpack.config.json
declare const MODE: string;

console.log(`MODE=${MODE}`);

const main = async () => {
  onAuthStateChanged((user: User | null) => {
    const node = document.getElementById("main");

    if (!node) {
      throw new Error("#main not found");
    }

    const elm = Elm.Main.init({ node, flags: { user } });

    elm.ports.requestItem.subscribe((key: string) => {
      elm.ports.receiveItem.send({ key, value: localStorage.getItem(key) });
    });

    elm.ports.setItem.subscribe(({ key, value }) => {
      localStorage.setItem(key, value);
    });

    elm.ports.signIn.subscribe(async ({ email, password }) => {
      const user = await signInEmailAndPassword(email, password);
      elm.ports.authStateChanged.send(user);
    });

    elm.ports.signOut.subscribe(async () => {
      await signOut();
      elm.ports.authStateChanged.send(null);
    });
  });
};

///////////////////////////////////////////////////////////////////////////////
// stub function
///////////////////////////////////////////////////////////////////////////////

// TODO: replace with a callback function like `onAuthStateChanged` of firebase
const onAuthStateChanged = (callback: (user: User | null) => void) => {
  setTimeout(() => {
    const user = localStorage.getItem("user");
    callback(user ? JSON.parse(user) : null);
  }, 100);
};

// TODO: replace with a function like `signOut` of firebase
const signOut = async () => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  localStorage.removeItem("user");
};

// TODO: replace with a function like `signInEmailAndPassword` of firebase
/* eslint @typescript-eslint/no-unused-vars: "off" */
const signInEmailAndPassword = async (email: string, password: string) => {
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const user = { email, displayName: email, emailVerified: true };
  localStorage.setItem("user", JSON.stringify(user));
  return user;
};

main().catch((err) => console.error(err));
