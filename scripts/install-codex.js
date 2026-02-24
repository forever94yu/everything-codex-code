#!/usr/bin/env node
/**
 * Cross-platform installer for everything-codex-code.
 *
 * Usage:
 *   node scripts/install-codex.js [--target codex] <language> [<language> ...]
 *   npx eccx-install [--target codex] <language> [<language> ...]
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const ROOT_DIR = path.resolve(__dirname, '..');
const RULES_DIR = path.join(ROOT_DIR, 'rules');

function listLanguages() {
  if (!fs.existsSync(RULES_DIR)) return [];
  return fs.readdirSync(RULES_DIR, { withFileTypes: true })
    .filter(d => d.isDirectory() && d.name !== 'common')
    .map(d => d.name)
    .sort();
}

function usage(exitCode = 1) {
  console.log('Usage: eccx-install [--target codex] <language> [<language> ...]');
  console.log('');
  console.log('Available languages:');
  for (const lang of listLanguages()) {
    console.log(`  - ${lang}`);
  }
  process.exit(exitCode);
}

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function copyDir(src, dst) {
  ensureDir(path.dirname(dst));
  fs.cpSync(src, dst, { recursive: true, force: true });
}

function main() {
  const args = process.argv.slice(2);

  // Optional compatibility flag
  if (args[0] === '--target') {
    const target = args[1];
    if (target !== 'codex') {
      console.error(`Error: only '--target codex' is supported. Got '${target || ''}'.`);
      process.exit(1);
    }
    args.splice(0, 2);
  }

  if (args.length === 0) {
    usage(1);
  }

  const codexHome = process.env.CODEX_HOME
    ? path.resolve(process.env.CODEX_HOME)
    : path.join(os.homedir(), '.codex');
  const rulesDest = process.env.CODEX_RULES_DIR
    ? path.resolve(process.env.CODEX_RULES_DIR)
    : path.join(codexHome, 'rules');
  const skillsDest = process.env.CODEX_SKILLS_DIR
    ? path.resolve(process.env.CODEX_SKILLS_DIR)
    : path.join(codexHome, 'skills');
  const bundleDest = process.env.CODEX_BUNDLE_DIR
    ? path.resolve(process.env.CODEX_BUNDLE_DIR)
    : path.join(codexHome, 'everything-codex-code');

  // Common rules
  const commonRulesSrc = path.join(RULES_DIR, 'common');
  if (!fs.existsSync(commonRulesSrc)) {
    console.error(`Error: missing common rules at ${commonRulesSrc}`);
    process.exit(1);
  }
  console.log(`Installing common rules -> ${path.join(rulesDest, 'common')}`);
  copyDir(commonRulesSrc, path.join(rulesDest, 'common'));

  // Language-specific rules
  for (const lang of args) {
    if (!/^[a-zA-Z0-9_-]+$/.test(lang)) {
      console.error(`Warning: invalid language name '${lang}', skipping.`);
      continue;
    }
    const src = path.join(RULES_DIR, lang);
    const dst = path.join(rulesDest, lang);
    if (!fs.existsSync(src)) {
      console.error(`Warning: rules/${lang} does not exist, skipping.`);
      continue;
    }
    console.log(`Installing ${lang} rules -> ${dst}`);
    copyDir(src, dst);
  }

  // Skills
  const skillsSrc = path.join(ROOT_DIR, 'skills');
  if (fs.existsSync(skillsSrc)) {
    console.log(`Installing skills -> ${skillsDest}`);
    copyDir(skillsSrc, skillsDest);
  }

  // Reference bundle
  console.log(`Installing reference bundle -> ${bundleDest}`);
  ensureDir(bundleDest);
  for (const name of ['agents', 'commands', 'contexts', 'hooks', 'mcp-configs', 'rules', 'examples', 'schemas']) {
    const src = path.join(ROOT_DIR, name);
    const dst = path.join(bundleDest, name);
    if (fs.existsSync(src)) {
      copyDir(src, dst);
    }
  }

  const agentsFile = path.join(ROOT_DIR, 'AGENTS.md');
  if (fs.existsSync(agentsFile)) {
    fs.copyFileSync(agentsFile, path.join(bundleDest, 'AGENTS.md'));
  }

  console.log(`Done. Codex assets installed to ${codexHome}`);
}

main();
