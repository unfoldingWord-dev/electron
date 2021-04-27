<<<<<<< HEAD
const { app, BrowserWindow } = require('electron')

let win
app.on('ready', function () {
  win = new BrowserWindow({})
  win.setMenuBarVisibility(false)

  setTimeout(() => {
    if (win.isMenuBarVisible()) {
      console.log('Window has a menu')
    } else {
      console.log('Window has no menu')
    }
    app.quit()
  })
})
=======
const { app, BrowserWindow } = require('electron');

let win;
// This test uses "app.once('ready')" while the |test-menu-null| test uses
// "app.whenReady()", the 2 APIs have slight difference on timing to cover
// more cases.
app.once('ready', function () {
  win = new BrowserWindow({});
  win.setMenuBarVisibility(false);

  setTimeout(() => {
    if (win.isMenuBarVisible()) {
      console.log('Window has a menu');
    } else {
      console.log('Window has no menu');
    }
    app.quit();
  });
});
>>>>>>> def6684f27920982d222b2710d41ad182a465925
