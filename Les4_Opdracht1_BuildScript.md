# OPDRACHT 1: BUILD-SCRIPT MAKEN
## Les 4 - Build-scripts & Continuous Integration


## Leerdoel

Je leert een build-script maken dat alle build-stappen automatiseert en consistent uitvoert, ongeacht wie of waar het draait.

---

## Opdracht

Maak een build-script voor een Node.js applicatie (of je eigen) dat **alle build-stappen** automatiseert.

### Kies ÉÉN van de volgende opties:

#### **Optie A: NPM Scripts** (Aanbevolen voor beginners)
Voeg scripts toe aan je `package.json`

#### **Optie B: Makefile** (Voor wie universeel wil werken)
Maak een `Makefile` met build targets

#### **Optie C: Shell Script** (Voor maximale controle)
Maak een `build.sh` met bash scripting

---

## Requirements

Je build-script MOET de volgende stappen uitvoeren:

1. **Dependencies installeren**
   - Gebruik `npm ci` (niet `npm install`)
   - Zorgt voor reproduceerbare builds

2. **Linting uitvoeren**
   - Run `npm run lint` (of ESLint direct)
   - Script moet stoppen bij lint errors

3. **Tests uitvoeren**
   - Run `npm test` (of Jest direct)
   - Script moet stoppen bij failing tests

4. **Docker image bouwen**
   - Build een Docker image met tag `latest`
   - Gebruik je applicatie naam als image naam

5. **Error handling**
   - Script moet stoppen bij de eerste fout
   - Duidelijke error messages tonen

---

## Optie A: NPM Scripts

### Wat je gaat maken

Voeg scripts toe aan je `package.json`:

```json
{
  "name": "mijn-devops-app",
  "version": "1.0.0",
  "scripts": {
    "clean": "rm -rf node_modules dist coverage",
    "lint": "eslint src/**/*.js",
    "test": "jest",
    "build": "npm run lint && npm run test",
    "docker:build": "docker build -t mijn-app:latest .",
    "ci": "npm ci && npm run build && npm run docker:build"
  }
}
```

### Stappen

1. **Open je package.json**

2. **Voeg de scripts toe** (pas namen aan naar je project)

3. **Test elk script apart:**
   ```bash
   npm run lint
   npm run test
   npm run docker:build
   ```

4. **Test de complete build:**
   ```bash
   npm run ci
   ```

5. **Verifieer dat het stopt bij errors:**
   - Maak expres een lint error → script moet falen
   - Fix de error → script moet slagen

### Uitleg

- `&&` zorgt dat volgende commando alleen draait als vorige slaagt
- `npm ci` installeert exact de versies uit package-lock.json
- Scripts kunnen andere scripts aanroepen

---

## Optie B: Makefile

### Wat je gaat maken

Maak een `Makefile` in de root van je project:

```makefile
.PHONY: help install clean lint test build docker-build ci

help:
	@echo "Available targets:"
	@echo "  make build       - Run lint and tests"
	@echo "  make docker-build - Build Docker image"
	@echo "  make ci          - Full CI pipeline"

install:
	@echo "📦 Installing dependencies..."
	npm ci

clean:
	@echo "🧹 Cleaning..."
	rm -rf node_modules dist coverage

lint:
	@echo "🔍 Running linter..."
	npm run lint

test: install
	@echo "🧪 Running tests..."
	npm test

build: lint test
	@echo "✅ Build successful!"

docker-build: build
	@echo "🐳 Building Docker image..."
	docker build -t mijn-app:latest .

ci: install lint test docker-build
	@echo "🎉 CI pipeline completed!"
```

### Stappen

1. **Maak een nieuw bestand** genaamd `Makefile` (geen extensie!)

2. **Kopieer de content** (pas `mijn-app` aan naar je app naam)

3. **Test de targets:**
   ```bash
   make help
   make build
   make docker-build
   make ci
   ```

4. **Let op de syntax:**
   - Gebruik TABS, niet spaces voor indentation
   - `.PHONY` voorkomt conflicten met bestanden met dezelfde namen

### Uitleg

- `target: dependencies` → target draait pas na dependencies
- `@echo` print zonder het commando zelf te tonen
- `build: lint test` → build draait eerst lint, dan test

---

## Optie C: Shell Script

### Wat je gaat maken

Maak een `build.sh` bestand:

```bash
#!/bin/bash
# build.sh - Complete build script

set -e  # Exit on any error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        log_error "$1 is not installed"
        exit 1
    fi
}

log_info "Starting build process..."

# Check required tools
check_dependency node
check_dependency npm
check_dependency docker

# Clean previous builds
log_info "Cleaning previous builds..."
rm -rf dist coverage

# Install dependencies
log_info "Installing dependencies..."
npm ci

# Run linter
log_info "Running linter..."
if npm run lint; then
    log_info "Linting passed ✅"
else
    log_error "Linting failed ❌"
    exit 1
fi

# Run tests
log_info "Running tests..."
if npm test; then
    log_info "Tests passed ✅"
else
    log_error "Tests failed ❌"
    exit 1
fi

# Build Docker image
log_info "Building Docker image..."
docker build -t mijn-app:latest .

log_info "Build completed successfully! 🎉"
```

### Stappen

1. **Maak build.sh** in de root van je project

2. **Kopieer de content** (pas `mijn-app` aan)

3. **Maak het executable:**
   ```bash
   chmod +x build.sh
   ```

4. **Run het script:**
   ```bash
   ./build.sh
   ```

5. **Test error handling:**
   - Maak een fout → script moet stoppen
   - Fix de fout → script moet slagen

### Uitleg

- `set -e` zorgt dat script stopt bij eerste error
- `if npm test; then` controleert exit code
- Colored output maakt logs leesbaarder

---

## Testen

### Test je script met deze scenario's:

1. **Happy path:**
   ```bash
   # Voor NPM:
   npm run ci
   
   # Voor Make:
   make ci
   
   # Voor Shell:
   ./build.sh
   ```
   → Moet succesvol afronden

2. **Failing lint:**
   - Maak expres een lint error (bijv. dubbele quotes i.p.v. enkele)
   - Run je script
   → Moet stoppen met error message

3. **Failing test:**
   - Pas een test aan zodat hij faalt
   - Run je script
   → Moet stoppen bij tests

4. **Multiple runs:**
   - Run je script 2x achter elkaar
   → Moet beide keren werken (idempotent)

---

## Acceptatiecriteria

Je script is klaar als:

- [ ] Het alle 5 stappen uitvoert (install, lint, test, docker build, error handling)
- [ ] Het stopt bij de eerste fout
- [ ] Het meerdere keren achter elkaar kan draaien
- [ ] De output duidelijk is (je ziet wat er gebeurt)
- [ ] Docker image succesvol gebouwd wordt

---

## Tips

### Algemeen
- **Start simpel**, voeg stappen één voor één toe
- **Test elk onderdeel** voordat je verder gaat
- **Gebruik echo/log statements** om te zien wat er gebeurt

### NPM Scripts
- Scripts kunnen elkaar aanroepen met `npm run <script>`
- `npm ci` is sneller en betrouwbaarder dan `npm install`
- Pre/post scripts: `pretest` draait automatisch voor `test`

### Makefile
- Gebruik **TABS**, niet spaces voor indentation
- Test targets apart: `make lint`, `make test`, etc.
- Op Windows? Gebruik Git Bash

### Shell Script
- Test op Linux/Mac EN Windows (via Git Bash)
- `set -e` is essentieel voor error handling
- Gebruik variabelen voor herhaling te voorkomen

---

## 🐛 Veelvoorkomende Problemen

### "npm ci failed"
**Oplossing:** Zorg dat `package-lock.json` bestaat
```bash
npm install  # Genereert package-lock.json
```

### "docker command not found"
**Oplossing:** Start Docker Desktop

### "Makefile: missing separator"
**Oplossing:** Gebruik tabs in plaats van spaces

### "Permission denied: build.sh"
**Oplossing:** 
```bash
chmod +x build.sh
```

---

## Extra Uitdagingen

Als je klaar bent, probeer:

1. **Parameters toevoegen:**
   ```bash
   ./build.sh v1.2.3  # Build met version tag
   ```

2. **Environment variables:**
   ```bash
   NODE_ENV=production npm run ci
   ```

3. **Build tijd meten:**
   ```bash
   time npm run ci
   ```

4. **Cleanup target toevoegen:**
   ```bash
   make clean
   ```

---

## Reflectie

Na de opdracht, bespreek:

1. **Welke optie heb je gekozen en waarom?**
2. **Wat was het lastigste deel?**
3. **Hoe zou dit je dagelijkse werk verbeteren?**
4. **Wat zou je anders doen in een echt project?**

---

## Hulp Nodig?

- Check de error messages zorgvuldig
- Vraag je breakout room collega's
- Roep de docent in je breakout room
- Gebruik de chat voor snelle vragen

