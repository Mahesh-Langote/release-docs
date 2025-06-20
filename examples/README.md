# Example Workflows

This directory contains example workflows demonstrating how to use the Smart Release Documentation Generator in different scenarios.

## � Quick Demo

### Version Fallback Demo

The [`demo-fallback.yml`](demo-fallback.yml) workflow demonstrates the automatic version fallback feature:

- **Version Fallback**: Shows how the action generates date-time versions when version files are missing
- **Custom Format**: Demonstrates custom date format configuration
- **Normal Version**: Compares with standard version file extraction

**Run the demo**: Navigate to Actions → "Release Documentation with Fallback Demo" → "Run workflow"

## �📱 Mobile Applications

### Flutter App Release

```yaml
# .github/workflows/flutter-release-docs.yml
name: Flutter Release Documentation

on:
  push:
    branches: [main, release/*]
  pull_request:
    branches: [main]

jobs:
  release-docs:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Required for git history
          
      - name: Generate Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # Flutter-specific configuration
          version-file: 'pubspec.yaml'
          version-pattern: 'version:\s*(.+)\+.*'  # Extract version without build number
          
          # Project information
          project-name: 'MyFlutter App'
          app-short-name: 'MyApp'
          
          # Ticket integration
          ticket-pattern: 'FLUTTER-[0-9]+'
          ticket-base-url: 'https://mycompany.atlassian.net/browse/'
          
          # Confluence integration
          confluence-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          confluence-space-key: 'MOBILE'
          confluence-parent-page-id: ${{ secrets.FLUTTER_PARENT_PAGE_ID }}
          
          # Slack integration
          slack-enabled: true
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          slack-channel: '#mobile-releases'
          slack-icon: 'https://mycompany.com/flutter-icon.png'
          
          # Tagging
          create-tag: true
          tag-prefix: 'flutter-v'
          tag-suffix: '-release'
```

### React Native App Release

```yaml
# .github/workflows/react-native-release-docs.yml
name: React Native Release Documentation

on:
  workflow_dispatch:
    inputs:
      release_type:
        description: 'Release type'
        required: true
        default: 'patch'
        type: choice
        options:
          - patch
          - minor
          - major

jobs:
  release-docs:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # React Native configuration
          version-file: 'package.json'
          
          # Project information
          project-name: 'MyReactNative App'
          app-short-name: 'RNApp'
          
          # Ticket integration
          ticket-pattern: 'RN-[0-9]+'
          
          # Custom commit categories
          category-config: |
            {
              "features": {
                "keywords": ["feat", "feature", "add", "new"],
                "emoji": "🚀",
                "title": "New Features",
                "max_entries": 20
              },
              "bugs": {
                "keywords": ["fix", "bug", "issue", "hotfix"],
                "emoji": "🐛",
                "title": "Bug Fixes",
                "max_entries": 25
              },
              "performance": {
                "keywords": ["perf", "performance", "optimize"],
                "emoji": "⚡",
                "title": "Performance",
                "max_entries": 10
              }
            }
          
          # Integrations
          confluence-enabled: true
          slack-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          
          # Tagging
          tag-prefix: 'rn-'
          tag-suffix: '-${{ github.event.inputs.release_type }}'
```

## 🌐 Web Applications

### Next.js App Release

```yaml
# .github/workflows/nextjs-release-docs.yml
name: Next.js Release Documentation

on:
  release:
    types: [published]

jobs:
  release-docs:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # Next.js configuration
          version-file: 'package.json'
          
          # Use release tag for commit range
          commit-range: '${{ github.event.release.target_commitish }}^..${{ github.event.release.target_commitish }}'
          
          # Project information
          project-name: 'MyNext.js App'
          app-short-name: 'NextApp'
          
          # Web-specific tickets
          ticket-pattern: 'WEB-[0-9]+'
          
          # Only Confluence for web releases
          confluence-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          confluence-space-key: 'WEB'
          
          # No additional tagging (using GitHub releases)
          create-tag: false
```

### Vue.js App Release

```yaml
# .github/workflows/vue-release-docs.yml
name: Vue.js Release Documentation

on:
  schedule:
    - cron: '0 9 * * 1'  # Weekly on Monday at 9 AM
  workflow_dispatch:

jobs:
  weekly-release-docs:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate Weekly Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # Vue.js configuration
          version-file: 'package.json'
          
          # Weekly release range
          commit-range: 'HEAD~50..HEAD'  # Last 50 commits
          
          # Project information
          project-name: 'MyVue.js App'
          app-short-name: 'VueApp'
          
          # Ticket integration
          ticket-pattern: 'VUE-[0-9]+'
          
          # Weekly release settings
          tag-prefix: 'weekly-'
          tag-suffix: '-$(date +%Y%m%d)'
          
          # Integrations
          confluence-enabled: true
          slack-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          slack-channel: '#weekly-updates'
```

## 🔧 Backend Applications

### Node.js API Release

```yaml
# .github/workflows/nodejs-api-release-docs.yml
name: Node.js API Release Documentation

on:
  push:
    tags:
      - 'api-v*'

jobs:
  api-release-docs:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Extract version from tag
        id: version
        run: |
          VERSION=${GITHUB_REF#refs/tags/api-v}
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          
      - name: Generate API Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # API configuration
          version-file: 'package.json'
          
          # Use tag-based range
          commit-range: '${{ github.ref }}^..${{ github.ref }}'
          
          # Project information
          project-name: 'MyNode.js API'
          app-short-name: 'API'
          
          # API-specific tickets
          ticket-pattern: 'API-[0-9]+'
          
          # Comprehensive documentation
          confluence-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          confluence-space-key: 'API'
          
          # Team notifications
          slack-enabled: true
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          slack-channel: '#api-releases'
          
          # No additional tagging (triggered by existing tag)
          create-tag: false
```

### Python API Release

```yaml
# .github/workflows/python-api-release-docs.yml
name: Python API Release Documentation

on:
  push:
    branches: [main]
    paths:
      - 'setup.py'
      - 'pyproject.toml'
      - 'src/**'

jobs:
  python-release-docs:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate Python API Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # Python configuration
          version-file: 'setup.py'
          version-pattern: 'version=[\'""]([^\'""]+)[\'""]'
          
          # Project information
          project-name: 'MyPython API'
          app-short-name: 'PyAPI'
          
          # Python-specific tickets
          ticket-pattern: 'PY-[0-9]+'
          
          # Custom categories for Python
          category-config: |
            {
              "features": {
                "keywords": ["feat", "add", "new", "implement"],
                "emoji": "✨",
                "title": "New Features"
              },
              "bugs": {
                "keywords": ["fix", "bug", "issue"],
                "emoji": "🐛",
                "title": "Bug Fixes"
              },
              "security": {
                "keywords": ["security", "sec", "vulnerability"],
                "emoji": "🔒",
                "title": "Security"
              },
              "deps": {
                "keywords": ["deps", "dependencies", "requirements"],
                "emoji": "📦",
                "title": "Dependencies"
              }
            }
          
          # Integrations
          confluence-enabled: true
          slack-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          
          # Python versioning
          tag-prefix: 'py-v'
```

## 🔄 Multi-Environment Releases

### Staging and Production Release

```yaml
# .github/workflows/multi-env-release-docs.yml
name: Multi-Environment Release Documentation

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options:
          - staging
          - production
      version:
        description: 'Release version'
        required: true
        type: string

jobs:
  release-docs:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Generate Environment-Specific Release Documentation
        uses: your-org/smart-release-docs-action@v1
        with:
          # Dynamic configuration based on environment
          version-file: 'package.json'
          
          # Project information
          project-name: 'MyApp (${{ github.event.inputs.environment }})'
          app-short-name: 'MyApp'
          
          # Environment-specific settings
          confluence-space-key: ${{ github.event.inputs.environment == 'production' && 'PROD' || 'STAGING' }}
          slack-channel: ${{ github.event.inputs.environment == 'production' && '#releases' || '#staging-releases' }}
          
          # Tagging
          tag-prefix: '${{ github.event.inputs.environment }}-v'
          
          # Integrations
          confluence-enabled: true
          slack-enabled: true
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 🚀 Advanced Examples

### Custom Ticket Patterns

```yaml
# Multiple ticket systems
ticket-pattern: '(JIRA-[0-9]+|GITHUB-[0-9]+|TRELLO-[a-zA-Z0-9]+)'

# Case-insensitive patterns
ticket-pattern: '(?i)(task-[0-9]+|bug-[0-9]+|story-[0-9]+)'

# Complex patterns with prefixes
ticket-pattern: '(PROJ|TASK|BUG|STORY)-[0-9]+'
```

### Custom Version Extraction

```yaml
# iOS Info.plist
version-file: 'ios/MyApp/Info.plist'
version-pattern: '<key>CFBundleShortVersionString</key>\s*<string>([^<]+)</string>'

# Android build.gradle
version-file: 'android/app/build.gradle'
version-pattern: 'versionName\s*["\']([^"\']+)["\']'

# Custom version file
version-file: 'VERSION'
version-pattern: '^(.+)$'  # Entire file content
```

### Environment-Specific Configurations

```yaml
# Use different configurations per environment
- name: Set Environment Variables
  run: |
    if [ "${{ github.ref }}" == "refs/heads/main" ]; then
      echo "ENV=production" >> $GITHUB_ENV
      echo "CONFLUENCE_SPACE=PROD" >> $GITHUB_ENV
      echo "SLACK_CHANNEL=#releases" >> $GITHUB_ENV
    else
      echo "ENV=staging" >> $GITHUB_ENV
      echo "CONFLUENCE_SPACE=DEV" >> $GITHUB_ENV
      echo "SLACK_CHANNEL=#dev-releases" >> $GITHUB_ENV
    fi

- name: Generate Release Documentation
  uses: your-org/smart-release-docs-action@v1
  with:
    confluence-space-key: ${{ env.CONFLUENCE_SPACE }}
    slack-channel: ${{ env.SLACK_CHANNEL }}
    tag-suffix: '-${{ env.ENV }}'
```

## 📋 Tips and Best Practices

1. **Use fetch-depth: 0** to ensure full git history is available
2. **Test with different commit ranges** to find optimal settings
3. **Use environment-specific configurations** for different deployment stages
4. **Validate API credentials** in test environments first
5. **Monitor action outputs** to ensure successful execution
6. **Use conditional execution** to avoid unnecessary runs

For more examples and advanced configurations, check our [documentation wiki](https://github.com/your-org/smart-release-docs-action/wiki).
