const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');

const widget = fs.readFileSync(path.join(__dirname, '..', 'phonebox-chatgpt-widget.html'), 'utf8');
const match = widget.match(/<script>([\s\S]*?)<\/script>/);
assert.ok(match, 'widget must have a script');

function build({ connected = true } = {}) {
  const ids = new Map();
  function node(id = '') {
    return {
      id,
      textContent: '',
      className: '',
      children: [],
      classList: { values: [], add(x) { this.values.push(x); } },
      appendChild(child) { this.children.push(child); },
      addEventListener(ev, fn) { this[ev] = fn; }
    };
  }
  const element = (id) => {
    if (!ids.has(id)) ids.set(id, node(id));
    return ids.get(id);
  };
  const callbacks = {};
  const sent = [];
  const phonebox = connected ? {
    on(type, fn) { callbacks[type] = fn; },
    run(id) { sent.push(id); }
  } : undefined;
  const context = {
    window: { phonebox },
    document: { getElementById: element, createElement: () => node() },
    setInterval: () => 0,
    Date, Object, Number, String, Array,
  };
  vm.runInNewContext(match[1], context, { timeout: 1000 });
  return { element, callbacks, sent };
}

test('registers data handlers and displays only supplied metrics', () => {
  const ui = build();
  assert.equal(typeof ui.callbacks.state, 'function');
  assert.equal(typeof ui.callbacks.work, 'function');
  ui.callbacks.state({ pc: { cpu: 23.6, ram: 57.1, gpu: 4.9 } });
  assert.equal(ui.element('cpu').textContent, '24%');
  assert.equal(ui.element('ram').textContent, '57%');
  assert.equal(ui.element('gpu').textContent, '5%');
  assert.equal(ui.element('connection').textContent, 'PC connected');
});

test('unknown telemetry remains blank (no fake readings)', () => {
  const ui = build();
  ui.callbacks.state({ pc: {} });
  assert.equal(ui.element('cpu').textContent, '—');
  assert.equal(ui.element('ram').textContent, '—');
  assert.equal(ui.element('gpu').textContent, '—');
});

test('only Codex session entries are rendered, never Claude as ChatGPT', () => {
  const ui = build();
  ui.callbacks.work({ sessions: [
    { provider: 'claude', project: 'Private Claude', status: 'working' },
    { provider: 'codex', project: 'My Code', status: 'idle' },
  ] });
  const box = ui.element('sessionsDetail');
  assert.equal(box.children.length, 1);
  assert.match(box.children[0].textContent, /My Code/);
  assert.doesNotMatch(box.children[0].textContent, /Claude/);
});

test('launch button submits the ID-only shortcut', () => {
  const ui = build();
  ui.element('launch').click();
  assert.deepEqual(ui.sent, ['chatgpt-open']);
});

test('without PhoneBox, launch shows a clear explanation', () => {
  const ui = build({ connected: false });
  ui.element('launch').click();
  assert.match(ui.element('feedback').textContent, /inside the PhoneBox/);
});