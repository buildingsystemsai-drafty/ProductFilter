param(
    [Parameter(Mandatory=$true)][ValidateSet('start','stop','status')]
    [string]$Action
)

$StateFile = Join-Path $PSScriptRoot '.serve_state.json'
$Port = 8000
$PythonCmd = 'python' # change if you need python3 or a full path

function Save-State($job, $pid) {
    $state = @{ JobId = $job.Id; PID = $pid; StartedAt = (Get-Date).ToString('o'); Port = $Port }
    $state | ConvertTo-Json | Out-File -FilePath $StateFile -Encoding UTF8
}

function Load-State() {
    if (Test-Path $StateFile) {
        try { Get-Content $StateFile -Raw | ConvertFrom-Json } catch { $null }
    } else { $null }
}

switch ($Action) {
    'start' {
        $existing = Load-State
        if ($existing -and (Get-Process -Id $existing.PID -ErrorAction SilentlyContinue)) {
            Write-Output "Server already running (PID=$($existing.PID)) on port $Port. Use './serve.ps1 stop' to stop it."; break
        }

        Write-Output "Starting python HTTP server on port $Port..."
        # Start the server as a background job and capture the process id
        $job = Start-Job -ScriptBlock {
            param($pythonCmd, $port)
            & $pythonCmd -m http.server $port
        } -ArgumentList $PythonCmd, $Port

        Start-Sleep -Milliseconds 300

        # Find the python child process for the job
        $jobChild = Get-Process -Name python -ErrorAction SilentlyContinue | Where-Object { $_.StartTime -gt (Get-Date).AddSeconds(-10) } | Sort-Object StartTime -Descending | Select-Object -First 1
        $pid = if ($jobChild) { $jobChild.Id } else { $null }

        Save-State $job $pid
        Write-Output "Started. PID=$pid. Open http://localhost:$Port"
    }
    'stop' {
        $state = Load-State
        if (-not $state) { Write-Output "No running server state file found."; break }
        $pid = $state.PID
        if ($pid -and (Get-Process -Id $pid -ErrorAction SilentlyContinue)) {
            Write-Output "Stopping server PID=$pid..."
            Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
            # Also remove any background jobs started by this script
            Get-Job | Where-Object { $_.Command -match 'http.server' } | Remove-Job -Force -ErrorAction SilentlyContinue
            Remove-Item $StateFile -ErrorAction SilentlyContinue
            Write-Output "Stopped."
        } else {
            Write-Output "No running process found for PID $pid. Cleaning state file.";
            Remove-Item $StateFile -ErrorAction SilentlyContinue
        }
    }
    'status' {
        $state = Load-State
        if ($state -and $state.PID -and (Get-Process -Id $state.PID -ErrorAction SilentlyContinue)) {
            Write-Output "Server running (PID=$($state.PID)) on port $Port since $($state.StartedAt)."
        } else {
            Write-Output "Server is not running.";
        }
    }
}
