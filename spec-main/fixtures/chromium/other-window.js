<<<<<<< HEAD
const { app, BrowserWindow } = require('electron')

const ints = (...args) => args.map(a => parseInt(a, 10))

const [x, y, width, height] = ints(...process.argv.slice(2))

let w
=======
const { app, BrowserWindow } = require('electron');

const ints = (...args) => args.map(a => parseInt(a, 10));

const [x, y, width, height] = ints(...process.argv.slice(2));

let w;
>>>>>>> def6684f27920982d222b2710d41ad182a465925

app.whenReady().then(() => {
  w = new BrowserWindow({
    x,
    y,
    width,
    height
<<<<<<< HEAD
  })
  console.log('__ready__')
})

process.on('SIGTERM', () => {
  process.exit(0)
})
=======
  });
  console.log('__ready__');
});

process.on('SIGTERM', () => {
  process.exit(0);
});
>>>>>>> def6684f27920982d222b2710d41ad182a465925
