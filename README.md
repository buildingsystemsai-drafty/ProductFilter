# Product Filter

A small static app that loads `products1.csv` and displays a dynamic product filter UI.

Quick start (PowerShell)

1. Start the server (serves current folder on port 8000):

```powershell
# Start server in background
.\serve.ps1 start
```

2. Open the app in your browser:

http://localhost:8000

3. Stop the server:

```powershell
.\serve.ps1 stop
```

Notes

- The script assumes you have `python` on your PATH (Python 3.x). If your python executable is `python3` or located elsewhere, edit `serve.ps1` to point to the correct path.
- The server uses `python -m http.server 8000` and runs in the background using PowerShell jobs. Logs are printed to the console.

Files

- `index.html` - The main UI
- `products1.csv` - Product data
- `serve.ps1` - PowerShell script to start/stop the server
