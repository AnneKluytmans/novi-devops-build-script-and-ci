# OPDRACHT 2: GITHUB ACTIONS CI WORKFLOW
## Les 4 - Build-scripts & Continuous Integration

## Leerdoel

Je leert een Continuous Integration workflow opzetten met GitHub Actions die automatisch bij elke code push je applicatie build en test.

---

## Opdracht

Maak een GitHub Actions workflow die je build-script automatisch uitvoert wanneer je code pusht.

### Wat je gaat bouwen

Een `.github/workflows/ci.yml` bestand dat:
- Automatisch draait bij pushes en pull requests
- Je applicatie build
- Tests uitvoert
- Docker image maakt
- Duidelijke feedback geeft

---

## Requirements

Je CI workflow MOET:

1. **Triggeren op de juiste events:**
   - Bij push naar `main` branch
   - Bij pull requests naar `main`

2. **Draaien op ubuntu-latest runner**

3. **De volgende steps uitvoeren:**
   - Checkout de code
   - Setup Node.js 20
   - Install dependencies (npm ci)
   - Run linter
   - Run tests
   - Build Docker image (bonus)

4. **Duidelijke namen hebben** voor elke step

5. **Falen als één van de stappen faalt**

---

## Stap-voor-Stap Instructies

### Stap 1: Maak de Workflow File

1. **In je repository, maak deze map structuur:**
   ```
   .github/
     └── workflows/
         └── ci.yml
   ```

2. **Let op:**
   - De map MOET `.github` heten (met punt)
   - De submap MOET `workflows` heten
   - De extensie MOET `.yml` of `.yaml` zijn

### Stap 2: Basis Workflow

**Kopieer deze basis structuur in `ci.yml`:**

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run linter
      run: npm run lint

    - name: Run tests
      run: npm test

    - name: Build Docker image
      run: |
        docker build -t ${{ github.event.repository.name }}:${{ github.sha }} .
        docker tag ${{ github.event.repository.name }}:${{ github.sha }} ${{ github.event.repository.name }}:latest
```

### Stap 3: Workflow Activeren

1. **Commit de workflow:**
   ```bash
   git add .github/workflows/ci.yml
   git commit -m "Add CI workflow"
   ```

2. **Push naar GitHub:**
   ```bash
   git push origin main
   ```

3. **GitHub Actions start automatisch!**

### Stap 4: Workflow Bekijken

1. **Ga naar je repository op GitHub**

2. **Klik op "Actions" tab** (bovenaan)

3. **Je ziet je workflow draaien** met deze statussen:
   - 🟡 Geel = Running
   - 🟢 Groen = Success
   - 🔴 Rood = Failed

4. **Klik op de workflow run** om details te zien

5. **Klik op de "build" job** om logs van elke step te zien

---

## Uitleg van de Workflow

### De Structuur

```yaml
name: CI                    # Naam die je ziet in GitHub
```

### Events (Triggers)

```yaml
on:                         # Wanneer draait de workflow?
  push:                     # Bij elke push...
    branches: [ main ]      # ...naar de main branch
  pull_request:             # EN bij pull requests
    branches: [ main ]      # ...naar main
```

### Job Configuratie

```yaml
jobs:                       # Één of meer jobs
  build:                    # Job naam (zelf te kiezen)
    runs-on: ubuntu-latest  # Welk OS?
```

### Steps

```yaml
steps:
- name: Checkout code            # Stap naam (beschrijvend!)
  uses: actions/checkout@v4      # Gebruik bestaande Action

- name: Setup Node.js
  uses: actions/setup-node@v4    # Action voor Node.js
  with:                          # Configuratie voor de Action
    node-version: '20'           # Welke Node versie?
    cache: 'npm'                 # Cache npm dependencies

- name: Install dependencies
  run: npm ci                    # Voer commando uit

- name: Run linter
  run: npm run lint              # NPM script

- name: Run tests
  run: npm test                  # Tests draaien

- name: Build Docker image
  run: |                         # Multi-line commando
    docker build -t myapp:${{ github.sha }} .
    docker tag myapp:${{ github.sha }} myapp:latest
```

### GitHub Context Variables

```yaml
${{ github.sha }}                     # Commit SHA
${{ github.event.repository.name }}   # Repository naam
${{ github.ref }}                     # Branch naam
${{ github.actor }}                   # Wie heeft push gedaan
```

---

## Testen

### Test 1: Succesvolle Build

1. **Maak een kleine wijziging:**
   ```bash
   echo "# CI Test" >> README.md
   git add README.md
   git commit -m "Test CI workflow"
   git push
   ```

2. **Check GitHub Actions tab**
   - Workflow moet starten
   - Alle steps moeten groen worden
   - Build moet succesvol zijn ✅

### Test 2: Failing Lint

1. **Maak expres een lint error:**
   ```javascript
   // In je code, gebruik dubbele quotes als je single quotes moet gebruiken
   const test = "should be single quotes";
   ```

2. **Commit en push:**
   ```bash
   git add .
   git commit -m "Test failing lint"
   git push
   ```

3. **Check GitHub Actions:**
   - Workflow moet draaien
   - Lint step moet falen 🔴
   - Volgende steps worden niet uitgevoerd
   - Je ziet duidelijke error message

4. **Fix de error en push opnieuw:**
   ```javascript
   const test = 'fixed';
   ```

5. **Workflow moet nu weer slagen** ✅

### Test 3: Failing Test

1. **Pas een test aan zodat hij faalt**

2. **Push de wijziging**

3. **Verifieer:**
   - Test step faalt
   - Docker build wordt niet uitgevoerd
   - Clear error message

4. **Fix en verifieer dat het weer werkt**

### Test 4: Pull Request

1. **Maak een nieuwe branch:**
   ```bash
   git checkout -b feature/test-ci
   ```

2. **Maak een wijziging en push:**
   ```bash
   echo "PR test" >> README.md
   git add README.md
   git commit -m "Test PR workflow"
   git push origin feature/test-ci
   ```

3. **Maak een Pull Request op GitHub**

4. **Check:**
   - Workflow draait automatisch
   - Status wordt getoond in de PR
   - Je ziet checks passed/failed

---

## Workflow Verbeteren

### Caching voor Snellere Builds

Je workflow gebruikt al caching:

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'              # ← Dit cachet node_modules
```

Dit maakt je builds veel sneller!

### Build Matrix (Bonus)

Test op meerdere Node versies:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 21]
    
    steps:
    - uses: actions/checkout@v4
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
    # ... rest van steps
```

Dit draait je workflow 3x parallel voor 3 Node versies!

### Environment Variables

```yaml
env:
  NODE_ENV: production
  APP_NAME: mijn-app

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Build
      run: echo "Building ${{ env.APP_NAME }}"
```

### Secrets (voor later)

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
```

---

## Acceptatiecriteria

Je workflow is klaar als:

- [ ] Workflow file staat in `.github/workflows/ci.yml`
- [ ] Workflow draait automatisch bij push naar main
- [ ] Workflow draait bij pull requests
- [ ] Alle steps hebben duidelijke namen
- [ ] Dependencies worden geïnstalleerd
- [ ] Linter draait en faalt bij errors
- [ ] Tests draaien en falen bij failing tests
- [ ] Docker image wordt gebouwd
- [ ] Je kunt de logs bekijken in GitHub
- [ ] Build status is zichtbaar in commits/PRs

---

## Tips

### YAML Syntax
- **Gebruik spaces, GEEN tabs**
- **Indentation is belangrijk** (2 spaces per level)
- **Use** voor Actions, **run** voor commando's
- **Validate je YAML:** https://www.yamllint.com/

### Debugging
- **Check de logs** in GitHub Actions tab
- **Klik op de failing step** voor details
- **Scroll naar boven** voor de eerste error
- **Error messages zijn usually duidelijk**

### Testing Lokaal
- Je kunt Actions niet lokaal testen
- Maar je kunt wel je build-script lokaal testen!
- Push small changes om snel te itereren

### Common Issues
- **Workflow draait niet?** Check bestandslocatie en naam
- **YAML error?** Check indentation (spaces!)
- **Step faalt?** Kijk naar de error message in logs
- **Cache issues?** Soms moet je cache clearen (Actions settings)

---

## Veelvoorkomende Problemen

### Probleem: "Workflow not found"
**Oorzaak:** Verkeerde bestandslocatie  
**Oplossing:** 
- MOET zijn: `.github/workflows/ci.yml`
- Check: mapnaam heeft punt voor github
- Check: workflows is meervoud

### Probleem: YAML parsing error
**Oorzaak:** Syntax fout in YAML  
**Oplossing:**
- Check indentation (gebruik spaces)
- Validate op yamllint.com
- Check dat strings met speciale tekens quoted zijn

### Probleem: "npm ci failed"
**Oorzaak:** package-lock.json ontbreekt  
**Oplossing:**
```bash
npm install  # Genereert package-lock.json
git add package-lock.json
git commit -m "Add package-lock.json"
git push
```

### Probleem: Tests falen in CI maar niet lokaal
**Oorzaak:** Environment verschillen  
**Oplossing:**
- Gebruik `npm ci` in plaats van `npm install`
- Check environment variables
- Test met NODE_ENV=test lokaal

---

## Extra Uitdagingen

Als je klaar bent, probeer:

### 1. Build Badge Toevoegen

Voeg dit toe aan je README.md:

```markdown
![CI](https://github.com/username/repo/workflows/CI/badge.svg)
```

Vervang `username` en `repo` met jouw gegevens.

### 2. Conditional Steps

Run bepaalde steps alleen op main branch:

```yaml
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: echo "Deploy only on main"
```

### 3. Artifacts Uploaden

Bewaar test coverage:

```yaml
- name: Upload coverage
  uses: actions/upload-artifact@v4
  with:
    name: coverage
    path: coverage/
```

### 4. Slack Notification

Stuur bericht naar Slack bij failed build:

```yaml
- name: Slack notification
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Build failed!'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## Reflectie

Na de opdracht, denk na over:

1. **Wat is het voordeel van automatische CI?**
   - Geen handmatige builds meer
   - Direct feedback bij fouten
   - Consistente builds voor iedereen

2. **Hoe zou dit je team helpen?**
   - Minder "works on my machine" problemen
   - Vroeger bugs detecteren
   - Snellere code reviews

3. **Wat zou je toevoegen in een echt project?**
   - Code coverage checks
   - Security scanning
   - Automatic deployment
   - Slack/email notifications

---

## Resources

### Documentatie
- [GitHub Actions Docs](https://docs.github.com/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)

### Handige Actions
- `actions/checkout@v4` - Checkout code
- `actions/setup-node@v4` - Setup Node.js
- `actions/cache@v4` - Cache dependencies
- `docker/build-push-action@v5` - Build/push Docker
- `codecov/codecov-action@v4` - Upload coverage

---

## Hulp Nodig?

### Debug Checklist
1. ✅ Bestand in `.github/workflows/ci.yml`?
2. ✅ YAML syntax correct? (validate online)
3. ✅ Workflow gecommit en gepusht?
4. ✅ Check GitHub Actions tab voor errors
5. ✅ Bekijk logs van failing steps

### Vraag Hulp
- Check de error message (vaak heel duidelijk!)
- Vraag je collega
- Roep de docent
- Post in Teams chat
