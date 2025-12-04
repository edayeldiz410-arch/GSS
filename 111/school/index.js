const { app, BrowserWindow } = require('electron');

function createWindow() {
  const win = new BrowserWindow({
    show: false, // we'll show when ready to avoid visual jank
    autoHideMenuBar: true, // hide menu bar on Windows/Linux
    width: 1280,
    height: 800,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
    }
  });

  // Default to local Django dev server; allow override with env var GSCHOOL_APP_URL
  const appURL = process.env.GSCHOOL_APP_URL || 'http://127.0.0.1:8000';
  win.loadURL(appURL).catch(err => {
    console.error('Failed to load URL', appURL, err);
  });

  // start maximized and apply a small zoom-out for a larger viewport feeling
  win.once('ready-to-show', () => {
    try {
      win.maximize();
      // zoomFactor < 1 => zoom out; configurable via GSCHOOL_ZOOM env var
  const zoom = parseFloat(process.env.GSCHOOL_ZOOM || '0.66');
      win.webContents.setZoomFactor(zoom);
    } catch (e) {
      console.error('Error applying window sizing/zoom', e);
    }
    win.show();
  });

  // optionally open devtools in development
  if (process.env.NODE_ENV === 'development') {
    win.webContents.openDevTools({ mode: 'detach' });
  }

  win.on('closed', () => {
    // dereference the window object if stored elsewhere
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  // On macOS it is common for apps to stay open until the user explicitly quits
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  // On macOS recreate a window if none are open
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});