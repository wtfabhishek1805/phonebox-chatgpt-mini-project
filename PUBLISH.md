# Publish this mini project to GitHub (Windows PowerShell)

Your GitHub CLI (`gh`) was already installed and signed in. These commands run **on your own Windows PC**, not in the browser's developer console.

## Step 1: Extract the ZIP and open PowerShell in this project folder

If it is in Downloads, in PowerShell run:

```powershell
cd "$env:USERPROFILE\Downloads\PhoneBox-ChatGPT-Mini-Project"
```

If the folder has a different name/location, open it in File Explorer, click its address bar, type `powershell` and press Enter.

## Step 2: Check prerequisites

```powershell
git --version
gh auth status
```

If `git` is not recognized, install Git using `winget install --id Git.Git -e` and reopen PowerShell. `gh` is the separate GitHub CLI, not Git itself.

Set your Git author identity if you have not already (use the email you use for GitHub or GitHub's private noreply email from Settings → Emails):

```powershell
git config --global user.name "wtfabhishek1805"
git config --global user.email "YOUR_GITHUB_EMAIL_OR_NOREPLY_ADDRESS"
```

## Step 3: Publish

**Simplest option:** After checking the contents, run ` .\Publish-To-GitHub.ps1 ` in this project folder and type `PUBLISH` when prompted. It creates a **public** repo and opens the page. If you prefer to do it manually, use the commands below.

Review `README.md`, `LICENSE`, `assets/dashboard-preview.png` and source files first. Don't upload personal PhoneBox config files or tokens.

Run these commands **in this folder**:

```powershell
git init -b main
git add .
git commit -m "Initial commit: PhoneBox ChatGPT Companion mini project"
gh auth setup-git
gh repo create phonebox-chatgpt-mini-project --public --source . --remote origin --push
```

A **public GitHub repository** will be created under the account you authenticated with. If the name is already taken, choose another, for example `phonebox-chatgpt-companion`.

## Step 4: Open your repository

```powershell
gh repo view --web
```

Check that README, screenshot, code, license and the Tests workflow appear. The project's status is a prototype; do not call it a fully tested ChatGPT account integration.

## Updating later

```powershell
git add .
git commit -m "Improve dashboard and documentation"
git push
```

## Suggested GitHub About text

Description: `Unofficial PhoneBox ChatGPT companion widget for turning an old Android phone into a Windows PC dashboard. Mini project.`

Topics: `phonebox`, `chatgpt`, `android`, `windows`, `dashboard`, `javascript`, `powershell`, `mini-project`, `open-source`.