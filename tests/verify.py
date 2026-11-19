"""Simple offline structural checks (no phone or agent required)."""
from pathlib import Path
from html.parser import HTMLParser
root = Path(__file__).resolve().parents[1]
html = (root / 'phonebox-chatgpt-widget.html').read_text('utf-8')
ps = (root / 'Install-ChatGPTWidget.ps1').read_text('utf-8')
assert '<main class="app">' in html
assert 'ChatGPT' in html
assert "phonebox.on('state'" in html and "phonebox.on('work'" in html
assert "window.phonebox.run(SHORTCUT_ID)" in html
assert 'chatgpt-open' in html and 'chatgpt-open' in ps
assert 'https://chatgpt.com/' in ps
assert "Copy-Item -LiteralPath $cfgPath -Destination $backup" in ps
assert 'ChatGPT web history / Plus limits are not exposed' in html
assert 'No local OpenAI Codex sessions detected.' in html
assert 'Claude' not in html.split('<main class="app">',1)[1].split('</main>',1)[0]
class Parser(HTMLParser): pass
Parser().feed(html)
print('PASS: widget/installer structural checks')