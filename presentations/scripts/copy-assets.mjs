import { cp, mkdir, readdir } from 'node:fs/promises';
import path from 'node:path';

const root = process.cwd();
const distDir = path.join(root, 'dist');
const skipDirs = new Set(['dist', 'node_modules', '.git']);

async function walk(currentDir, results = []) {
  const entries = await readdir(currentDir, { withFileTypes: true });

  for (const entry of entries) {
    if (entry.name.startsWith('.')) {
      continue;
    }

    const fullPath = path.join(currentDir, entry.name);

    if (entry.isDirectory()) {
      const relative = path.relative(root, fullPath);
      const topLevel = relative.split(path.sep)[0];

      if (skipDirs.has(topLevel)) {
        continue;
      }

      if (entry.name === 'img') {
        results.push(fullPath);
        continue;
      }

      await walk(fullPath, results);
    }
  }

  return results;
}

async function copyImageDirs() {
  const imgDirs = await walk(root);

  for (const imgDir of imgDirs) {
    const rel = path.relative(root, imgDir);
    const target = path.join(distDir, rel);
    await mkdir(path.dirname(target), { recursive: true });
    await cp(imgDir, target, { recursive: true, force: true });
    console.log(`Copied ${rel} -> ${path.relative(root, target)}`);
  }

  if (imgDirs.length === 0) {
    console.log('No img directories found.');
  }
}

copyImageDirs().catch((error) => {
  console.error(error);
  process.exit(1);
});
