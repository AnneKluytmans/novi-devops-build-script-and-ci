# DevOps Les 4 - Code Voorbeelden

Deze map bevat alle code voorbeelden voor Les 4: Build-scripts & Continuous Integration.

## Inhoud

- `package.json` - NPM scripts voor build automatisering
- `Makefile` - Make-based build systeem
- `build.sh` - Shell script voor CI/CD
- `ci.yml` - GitHub Actions workflow (plaats in `.github/workflows/`)
- `index.js` - Express API voorbeeld
- `index.test.js` - Jest tests
- `Dockerfile` - Docker configuratie
- `.eslintrc.json` - ESLint configuratie
- `jest.config.js` - Jest configuratie

## Quick Start

### Optie 1: NPM Scripts

```bash
# Installeer dependencies
npm install

# Run development server
npm run dev

# Run build (lint + test)
npm run build

# Full CI pipeline
npm run ci
```

### Optie 2: Makefile

```bash
# Zie beschikbare commando's
make help

# Run build
make build

# Full CI pipeline
make ci

# Clean build artifacts
make clean
```

### Optie 3: Shell Script

```bash
# Make executable
chmod +x build.sh

# Run build
./build.sh

# Build with specific version
./build.sh v1.2.3
```

## GitHub Actions

1. Maak `.github/workflows/` directory in je project
2. Kopieer `ci.yml` naar `.github/workflows/ci.yml`
3. Commit en push
4. Bekijk de workflow in de "Actions" tab op GitHub

## Docker

```bash
# Build image
docker build -t devops-app:latest .

# Run container
docker run -p 3000:3000 devops-app:latest

# Test health endpoint
curl http://localhost:3000/health
```

## Tests

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage
```

## Linting

```bash
# Check code style
npm run lint

# Auto-fix issues
npm run lint:fix
```

## Troubleshooting

### npm ci faalt
- Zorg dat `package-lock.json` aanwezig is
- Run `npm install` om het te genereren

### Makefile werkt niet op Windows
- Installeer Git Bash (meegeleverd met Git for Windows)
- Of gebruik WSL (Windows Subsystem for Linux)
- Of gebruik NPM scripts als alternatief

### Tests falen
- Check of alle dependencies geïnstalleerd zijn: `npm ci`
- Verify Node.js versie: `node --version` (moet 18+ zijn)

## Structuur voor Je Project

```
je-project/
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/                    # Of root directory
│   ├── index.js
│   └── index.test.js
├── package.json
├── Makefile               # Optioneel
├── build.sh              # Optioneel
├── Dockerfile
├── .eslintrc.json
├── jest.config.js
└── README.md
```

## Tips voor de Opdracht

1. **Start Simpel**: Begin met NPM scripts, voeg Makefile of shell script later toe
2. **Test Lokaal Eerst**: Zorg dat alles lokaal werkt voordat je CI opzet
3. **Kleine Stappen**: Commit na elke werkende stap
4. **Check de Logs**: Als CI faalt, bekijk de logs in GitHub Actions
5. **Gebruik Caching**: De workflow gebruikt al npm caching voor snelheid

## Veelvoorkomende Fouten

❌ **Fout**: Workflow file op verkeerde plek  
✅ **Fix**: Moet exact `.github/workflows/ci.yml` zijn

❌ **Fout**: YAML indentation errors  
✅ **Fix**: Gebruik spaces, geen tabs. Check met een YAML validator

❌ **Fout**: Tests falen in CI maar niet lokaal  
✅ **Fix**: Gebruik `npm ci` in plaats van `npm install`

## Resources

- [GitHub Actions Documentatie](https://docs.github.com/actions)
- [NPM Scripts Docs](https://docs.npmjs.com/cli/v8/using-npm/scripts)
- [Make Tutorial](https://makefiletutorial.com/)
- [Jest Documentatie](https://jestjs.io/)
- [ESLint Rules](https://eslint.org/docs/rules/)
