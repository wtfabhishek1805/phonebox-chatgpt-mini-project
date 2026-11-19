# Device validation checklist — PhoneBox ChatGPT Companion

> **Status: PENDING on a physical Samsung Galaxy J5 Prime / Windows machine.**
> The automated CI tests exercise JavaScript behavior with mocks and basic file structure. They do **not** establish that PhoneBox accepts the edited configuration on a real machine.

## Test environment to record

- Windows version:
- PhoneBox agent version (target: 0.9.22):
- Android version:
- USB debugging authorized on this PC: yes / no
- Date tested:
- Tester:

## Preflight

- [ ] Install the original PhoneBox release from [ersinkoc/phonebox](https://github.com/ersinkoc/phonebox).
- [ ] Confirm the phone displays the original PhoneBox pages over USB.
- [ ] Open PhoneBox settings at http://127.0.0.1:8765.
- [ ] Save the Pages settings once so a local configuration exists.
- [ ] Back up the PhoneBox configuration and avoid publishing local config files containing pairing data or shortcuts.
- [ ] Review the installer source; do not run a PowerShell script you have not reviewed.

## Dry run and installation

1. Extract or clone this add-on repository locally.
2. Open PowerShell in the repository folder.
3. Run the dry-run check:

       .\Install-ChatGPTWidget.ps1 -WhatIf

4. Confirm the dry run reports the targeted Sessions widget, makes **no changes**, and leaves PhoneBox responsive.
5. When ready, exit PhoneBox from the system tray, then run:

       .\Install-ChatGPTWidget.ps1

6. Enter YES only if you accept the local configuration edit.
7. Start PhoneBox, refresh its Settings page and open the Sessions page on the phone.

## Acceptance tests

- [ ] The ChatGPT-themed card renders on the phone without layout overflow.
- [ ] The card shows accurate availability/empty states when local Codex data is absent.
- [ ] Tapping the card's ChatGPT control opens the configured browser shortcut.
- [ ] If PC sensors are available, CPU/RAM/GPU values update with real agent data.
- [ ] Original GitHub widget remains unchanged.
- [ ] Other PhoneBox pages, shortcuts, music controls and USB access still work.
- [ ] Closing/reopening PhoneBox does not silently revert the new widget.
- [ ] No ChatGPT session history, account cookies or Plus usage are accessed.
- [ ] PhoneBox configuration backup is present.

## Rollback

1. Close the PhoneBox desktop agent.
2. Locate the timestamped file alongside %APPDATA%\PhoneBox\config.json:
   config.json.chatgpt-backup-YYYYMMDD-HHMMSS.json
3. Copy the selected backup over config.json.
4. Restart PhoneBox and confirm the original Sessions panel is restored.

Restoring the backup can also roll back unrelated PhoneBox settings changed after that backup.

## Troubleshooting and disclosure

- If the expected widget cannot be found, do **not** edit the configuration by guessing paths or object types. Open an issue with the PhoneBox version and a sanitized error message.
- Do **not** upload your actual PhoneBox config, GitHub tokens, ADB keys, Wi-Fi pairing secrets, or system logs containing identifiers.
- Attach only a redacted screenshot and the installer error text when filing a bug.
- Open source code and mocked CI do not guarantee compatibility, security, or release readiness.

When tests are completed, publish a test summary with the exact versions, result and limitations.
