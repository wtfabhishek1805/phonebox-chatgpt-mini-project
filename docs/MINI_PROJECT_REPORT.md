# Mini Project Report: PhoneBox ChatGPT Companion

## Abstract

Many retired Android smartphones still have usable screens but limited day-to-day utility. This mini project demonstrates reusing one as a USB-connected companion screen for a Windows PC using PhoneBox. An independently authored ChatGPT-themed HTML/CSS/JavaScript widget replaces an AI sessions tile in PhoneBox while preserving the existing hardware-monitoring and automation ecosystem.

## Problem statement

A user wants a compact, always-visible PC companion panel without purchasing a dedicated monitoring display. The default AI Sessions widget primarily focuses on developer-agent sessions; it does not provide a ChatGPT-themed home panel.

## Objectives

1. Reuse an older Android phone as a desktop control/display panel.
2. Create a readable, touch-friendly ChatGPT companion interface.
3. Use the existing PhoneBox widget interface and trusted shortcut API rather than running arbitrary phone-triggered shell commands.
4. Safeguard existing user settings with a backup-first installer.
5. Keep real machine telemetry and unavailable account data distinguishable.

## Technologies

- Frontend: HTML5, CSS3, JavaScript.
- Host platform: PhoneBox Windows agent and Android client (third-party open source).
- Install automation: Windows PowerShell.
- Testing: Python `html.parser`, Node.js built-in test module with mock widget API.
- Version control/distribution: Git and GitHub.

## Hardware and software used

- An Android smartphone, such as a Samsung Galaxy J5 Prime, with a functional USB data connection.
- Windows 10/11 computer running PhoneBox v0.9.22.
- Browser to configure widget pages through PhoneBox settings.

## Module description

**Display module:** Dark responsive layout showing ChatGPT launch control, PC statistics, and explicit Codex activity placeholders.

**Data adapter:** Subscribes to `phonebox.on('state', ...)` and `phonebox.on('work', ...)` events; missing data stays empty rather than being invented.

**Action module:** Calls `phonebox.run('chatgpt-open')`, where the trusted shortcut is configured on the PC to open `https://chatgpt.com/`.

**Installer:** Reads the existing PhoneBox JSON config, identifies the first `sessions` widget, makes a timestamped copy, and replaces only that widget with a custom HTML widget.

## Work flow

```text
Windows PC → PhoneBox agent → USB/Wi-Fi → PhoneBox Android panel
                     │                          │
                     └── event data → Custom HTML widget
                                                │
                                  Tap ChatGPT launch button
                                                │
                       PhoneBox validates PC shortcut ID
                                                │
                                   Opens ChatGPT in PC browser
```

## Results and testing status

- A static dashboard demonstration and preview screenshot were prepared.
- Automated structure checks and mocked UI event tests are included.
- Android/Windows device test and usability/performance measurements remain to be completed and documented; no fabricated success metrics are claimed.

## Limitations

- The project is an **add-on**, not a redesigned PhoneBox APK.
- It cannot read private ChatGPT web sessions, chat history, subscriber usage, or browser cookies.
- OpenAI Codex local coding activity is distinct from ChatGPT web conversations.
- Telemetry availability depends on the PhoneBox version, system monitoring interfaces and phone WebView.

## Future enhancements

- Real-device testing matrix for Android versions and landscape/portrait layouts.
- More accessible widget layouts and larger touch targets.
- Optional separately authenticated OpenAI API feature (with server-side secret handling), if a real chat capability is required.
- Upstream contribution after discussion with PhoneBox maintainers.

## Conclusion

The mini project illustrates how a low-cost companion dashboard can be built with an existing open-source phone-to-PC bridge and a custom widget. Its primary outcome is a customizable control/monitoring interface, not access to ChatGPT's private account data.

## References

- PhoneBox upstream: https://github.com/ersinkoc/phonebox
- PhoneBox setup docs: https://github.com/ersinkoc/phonebox/blob/main/docs/SETUP.md
- GitHub CLI: https://cli.github.com/