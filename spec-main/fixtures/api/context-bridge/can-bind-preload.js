<<<<<<< HEAD
const { contextBridge, ipcRenderer } = require('electron')

console.info(contextBridge)

let bound = false
try {
  contextBridge.exposeInMainWorld('test', {})
  bound = true
=======
const { contextBridge, ipcRenderer } = require('electron');

console.info(contextBridge);

let bound = false;
try {
  contextBridge.exposeInMainWorld('test', {});
  bound = true;
>>>>>>> def6684f27920982d222b2710d41ad182a465925
} catch {
  // Ignore
}

<<<<<<< HEAD
ipcRenderer.send('context-bridge-bound', bound)
=======
ipcRenderer.send('context-bridge-bound', bound);
>>>>>>> def6684f27920982d222b2710d41ad182a465925
