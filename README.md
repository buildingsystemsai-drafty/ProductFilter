# Product Filter
# Product Filter

A small static web app that loads `products1.csv` and provides a dynamic filter UI for browsing products.

Repository

https://github.com/buildingsystemsai-drafty/ProductFilter

Quick start (PowerShell)

Prerequisites:
- Python 3.x on your PATH (command: `python`)
- PowerShell (Windows)

Start the server (recommended, uses the convenience script):

```powershell
# Start the server in the background and save state to .serve_state.json
.\serve.ps1 start
```

Open the app in your browser:

http://localhost:8000

Stop the server:

```powershell
.\serve.ps1 stop
```

Check server status:

```powershell
.\serve.ps1 status
```

Manual start/stop (alternative)

If you prefer not to use the script, you can manually start a Python HTTP server from the project folder:

```powershell
# Start in foreground
python -m http.server 8000

# Run in background (PowerShell):
Start-Process -FilePath python -ArgumentList '-m','http.server','8000' -NoNewWindow -PassThru
```

Troubleshooting

- If `python` isn't found, install Python 3 and add it to your PATH, or edit `serve.ps1` and set `$PythonCmd` to the full path to your python executable.
- If the port 8000 is already in use, stop the process using that port or edit `serve.ps1` and change `$Port`.
- If the UI shows an "Error loading data" message, confirm `products1.csv` exists in the same folder as `index.html` and contains CSV rows.
- If you can't push to GitHub, ensure your Git credentials are configured (HTTPS or SSH). You can run `git remote -v` to check remotes.

Files in this repo

- `index.html` — Main UI
- `products1.csv` — Product dataset used by the UI
- `serve.ps1` — PowerShell helper to start/stop/status the Python server
- `.gitignore` — Ignored files

License

Add a license file if you plan to make this public. Common choices: MIT, Apache-2.0. I can add one for you if you want.

Contact / next steps

If you'd like, I can:
- Add a `.bat` wrapper for double-click launching on Windows
- Add a `LICENSE` file and expand the README with contributor guidance
- Add a GitHub Actions workflow to serve/preview the site (or deploy to GitHub Pages)

---
Last updated: October 20, 2025
