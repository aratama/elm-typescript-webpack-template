import { exec } from "child_process";

const allowedLicenses = [
  "MIT",
  "ISC",
  "0BSD",
  "BSD-2-Clause",
  "BSD-3-Clause",
  "Apache-2.0",
  "CC-BY-4.0",
  "CC-BY-3.0",
  "CC0-1.0",
  "(MIT OR CC0-1.0)",
  "(MIT AND CC-BY-3.0)",
  "(BSD-3-Clause OR GPL-2.0)",
  "(MIT OR Apache-2.0)",
  "(WTFPL OR MIT)",
];

exec("license-checker --json", (error, stdout, stderr) => {
  if (error) {
    console.log(`error: ${error.message}`);
    return;
  }
  if (stderr) {
    console.log(`stderr: ${stderr}`);
    return;
  }
  const licenses = JSON.parse(stdout);
  for (const npmModule in licenses) {
    if (!allowedLicenses.includes(licenses[npmModule].licenses)) {
      console.error(`${npmModule} has a not allowed license: ${licenses[npmModule].licenses}`);
    }
  }
});
