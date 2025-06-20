# Release Docs

🚀 **A comprehensive GitHub Action for automated release documentation with JIRA integration, Confluence publishing, and Slack notifications.**

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Release%20Docs-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=github)](https://github.com/marketplace/actions/release-docs)
[![GitHub release](https://img.shields.io/github/release/your-org/release-docs.svg)](https://github.com/your-org/release-docs/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- **📝 Automated Release Notes** - Generate comprehensive release notes from git commits
- **🎫 JIRA Integration** - Automatically detect and link JIRA tickets (MDO, PROJ, etc.)
- **📚 Confluence Publishing** - Upload formatted documentation to Confluence
- **💬 Slack Notifications** - Send release announcements with highlights
- **🏷️ Git Tagging** - Create annotated release tags automatically
- **📂 Smart Categorization** - Organize commits by type (features, bugs, etc.)
- **🔧 Highly Configurable** - Extensive customization options
- **📱 Mobile-Friendly** - Perfect for Flutter, React Native, and mobile projects

## 🚀 Quick Start

### Basic Usage

```yaml
name: Release Documentation
on:
  push:
    branches: [main]

jobs:
  documentation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Required for git history analysis
        - name: Generate Release Documentation
        uses: your-org/release-docs@v1
        with:
          # Basic configuration
          version-file: 'pubspec.yaml'  # or package.json, version.txt, etc.
          project-name: 'My Awesome App'
          
          # Optional: Enable integrations
          confluence-enabled: true
          slack-enabled: true
          
          # Confluence settings (if enabled)
          confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
          confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
          confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
          confluence-space-key: 'DEV'
          
          # Slack settings (if enabled)
          slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
          slack-channel: 'releases'
```

### Advanced Configuration

```yaml
- name: Generate Release Documentation
  uses: your-org/release-docs@v1
  with:
    # Version Configuration
    version-file: 'pubspec.yaml'
    version-pattern: 'version:\s*(.+)'
    
    # Git Configuration
    max-commits: 150
    commit-range: 'v1.0.0..HEAD'  # Optional: specify exact range
    
    # Ticket Integration
    ticket-pattern: 'PROJ-[0-9]+'
    ticket-base-url: 'https://mycompany.atlassian.net/browse/'
    
    # Release Categories
    enable-categories: true
    category-config: |
      {
        "features": {
          "keywords": ["feat", "feature", "add", "new"],
          "emoji": "🚀",
          "max_entries": 25
        },
        "bugs": {
          "keywords": ["fix", "bug", "issue", "hotfix"],
          "emoji": "🐛",
          "max_entries": 30
        }
      }
    
    # Confluence Integration
    confluence-enabled: true
    confluence-base-url: ${{ secrets.CONFLUENCE_BASE_URL }}
    confluence-email: ${{ secrets.CONFLUENCE_EMAIL }}
    confluence-api-token: ${{ secrets.CONFLUENCE_API_TOKEN }}
    confluence-space-key: 'MYPROJECT'
    confluence-parent-page-id: '123456789'
    
    # Slack Integration
    slack-enabled: true
    slack-webhook: ${{ secrets.SLACK_WEBHOOK_URL }}
    slack-channel: '#releases'
    slack-icon: 'https://mycompany.com/logo.png'
    project-name: 'My Mobile App'
    app-short-name: 'MyApp'
    
    # Git Tagging
    create-tag: true
    tag-prefix: 'release-'
    tag-suffix: '-prod'
    
    # Output Configuration
    output-format: 'both'  # markdown, confluence, or both
    include-summary: true
```

## 📋 Inputs

### Core Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `version-file` | Path to version file (pubspec.yaml, package.json, etc.). **Auto-fallback**: If file doesn't exist or version can't be extracted, automatically uses date-time version | No | `pubspec.yaml` |
| `version-pattern` | Regex pattern to extract version from file | No | `version:\s*(.+)` |
| `fallback-version-format` | Date format for auto-generated version when version file is missing (uses `date` command format) | No | `%Y.%m.%d.%H%M` |
| `project-name` | Project name for notifications | No | - |
| `app-short-name` | Short app name for notifications | No | - |

### Git Configuration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `commit-range` | Git commit range for analysis | No | Auto-detected |
| `max-commits` | Maximum commits to analyze | No | `100` |

### Ticket Integration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `ticket-pattern` | Regex pattern for ticket detection | No | `MDO-[0-9]+` |
| `ticket-base-url` | Base URL for ticket links | No | `https://musterdekho.atlassian.net/browse/` |

### Confluence Integration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `confluence-enabled` | Enable Confluence integration | No | `false` |
| `confluence-base-url` | Confluence base URL | Conditional | - |
| `confluence-email` | Confluence user email | Conditional | - |
| `confluence-api-token` | Confluence API token | Conditional | - |
| `confluence-space-key` | Confluence space key | No | `DEV` |
| `confluence-parent-page-id` | Parent page ID for release notes | No | - |

### Slack Integration

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `slack-enabled` | Enable Slack notifications | No | `false` |
| `slack-webhook` | Slack webhook URL | Conditional | - |
| `slack-channel` | Slack channel name | No | - |
| `slack-icon` | Slack notification icon URL | No | - |

### Other Options

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `create-tag` | Create git tag for release | No | `true` |
| `tag-prefix` | Prefix for git tags | No | `v` |
| `tag-suffix` | Suffix for git tags | No | - |
| `output-format` | Output format: markdown, confluence, both | No | `both` |
| `enable-categories` | Enable commit categorization | No | `true` |
| `include-summary` | Include release summary | No | `true` |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `release-notes-path` | Path to generated release notes file |
| `confluence-url` | URL to Confluence page (if enabled) |
| `tag-name` | Created git tag name |
| `tag-created` | Whether a new tag was created |
| `release-version` | Extracted release version |
| `total-commits` | Total number of commits analyzed |
| `ticket-count` | Number of unique tickets found |

## 🕒 Version Fallback Feature

When the specified version file doesn't exist or version extraction fails, the action automatically generates a date-time based version to ensure your release documentation is always created.

### Default Behavior

- **Format**: `YYYY.MM.DD.HHMM` (UTC)
- **Example**: `2025.06.20.1430` (June 20, 2025 at 14:30 UTC)

### Custom Date Formats

You can customize the fallback version format using the `fallback-version-format` input:

```yaml
- name: Generate Release Documentation
  uses: your-org/release-docs@v1
  with:
    version-file: 'nonexistent.yaml'  # File doesn't exist
    fallback-version-format: '%Y%m%d-%H%M%S'  # Custom format
    # Results in version like: 20250620-143045
```

### Common Format Examples

| Format | Example Output | Description |
|--------|----------------|-------------|
| `%Y.%m.%d.%H%M` | `2025.06.20.1430` | Default: Year.Month.Day.HourMin |
| `%Y%m%d-%H%M%S` | `20250620-143045` | Compact: YYYYMMDD-HHMMSS |
| `%Y.%j.%H%M` | `2025.171.1430` | Year.DayOfYear.HourMin |
| `v%Y%m%d` | `v20250620` | Daily versioning with 'v' prefix |

### Benefits

- **Never fails**: Always generates documentation even without version files
- **Unique versions**: Date-time ensures no duplicate versions
- **Flexible**: Customize format to match your project needs
- **Trackable**: Easy to identify when releases were created

## 🎯 Use Cases

### Mobile App Releases

Perfect for Flutter, React Native, and native mobile apps:

```yaml
- name: Mobile App Release Documentation
  uses: your-org/release-docs@v1
  with:
    version-file: 'pubspec.yaml'  # Flutter
    # version-file: 'package.json'  # React Native
    # version-file: 'ios/MyApp/Info.plist'  # iOS
    ticket-pattern: 'MOBILE-[0-9]+'
    slack-enabled: true
    create-tag: true
    tag-suffix: '-mobile'
```

### Web Application Releases

Great for Next.js, React, Vue, and other web frameworks:

```yaml
- name: Web App Release Documentation
  uses: your-org/release-docs@v1
  with:
    version-file: 'package.json'
    ticket-pattern: 'WEB-[0-9]+'
    confluence-enabled: true
    tag-prefix: 'web-v'
```

### API/Backend Releases

Ideal for REST APIs, microservices, and backend applications:

```yaml
- name: API Release Documentation
  uses: your-org/release-docs@v1
  with:
    version-file: 'version.txt'
    ticket-pattern: 'API-[0-9]+'
    confluence-enabled: true
    slack-enabled: true
    tag-prefix: 'api-'
```

### Quick Deployment (No Version File)

Perfect for rapid prototyping or repositories without version files:

```yaml
- name: Quick Release Documentation
  uses: your-org/release-docs@v1
  with:
    version-file: 'nonexistent-file.txt'  # File doesn't exist
    fallback-version-format: '%Y%m%d-%H%M'  # Custom date format
    project-name: 'My Prototype App'
    create-tag: true
    tag-prefix: 'prototype-'
    # Automatically generates version like: 20250620-1430
    # Creates tag like: prototype-20250620-1430
```

## 🏗️ Project Structure Support

The action automatically detects and works with various project types:

- **Flutter**: `pubspec.yaml`
- **React Native**: `package.json`
- **Node.js**: `package.json`
- **Python**: `setup.py`, `pyproject.toml`
- **Java/Kotlin**: `gradle.properties`, `pom.xml`
- **iOS**: `Info.plist`
- **Android**: `build.gradle`
- **Custom**: Any text file with version pattern

## 🔧 Advanced Configuration

### Custom Commit Categories

```yaml
category-config: |
  {
    "features": {
      "keywords": ["feat", "feature", "add", "new", "implement"],
      "emoji": "🚀",
      "title": "New Features",
      "max_entries": 25
    },
    "bugs": {
      "keywords": ["fix", "bug", "issue", "resolve", "hotfix"],
      "emoji": "🐛", 
      "title": "Bug Fixes",
      "max_entries": 30
    },
    "performance": {
      "keywords": ["perf", "performance", "optimize", "speed"],
      "emoji": "⚡",
      "title": "Performance Improvements", 
      "max_entries": 15
    }
  }
```

### Multiple Ticket Patterns

```yaml
ticket-pattern: '(PROJ-[0-9]+|TASK-[0-9]+|BUG-[0-9]+)'
```

### Custom Version Extraction

```yaml
# For custom version files
version-file: 'src/version.py'
version-pattern: '__version__\s*=\s*["\']([^"\']+)["\']'
```

## 🔐 Security & Secrets

Required secrets for full functionality:

```yaml
# Confluence Integration
CONFLUENCE_BASE_URL: https://yourcompany.atlassian.net/wiki
CONFLUENCE_EMAIL: your-email@company.com
CONFLUENCE_API_TOKEN: your-api-token

# Slack Integration  
SLACK_WEBHOOK_URL: https://hooks.slack.com/services/...
SLACK_CHANNEL_NAME: releases

# Project Information
PROJECT_NAME: "My Awesome App"
APP_SHORT_NAME: "MyApp"
```

## 📊 Sample Output

### Generated Markdown

```markdown
# Release Notes - v2.1.0

**Release Date:** June 20, 2025
**Version:** v2.1.0
**Commits Analyzed:** 45
**Tickets Found:** 12

## 🚀 New Features
* [PROJ-123](https://company.atlassian.net/browse/PROJ-123) Add dark mode support
* [PROJ-124](https://company.atlassian.net/browse/PROJ-124) Implement push notifications

## 🐛 Bug Fixes  
* [PROJ-125](https://company.atlassian.net/browse/PROJ-125) Fix login issue on iOS
* [PROJ-126](https://company.atlassian.net/browse/PROJ-126) Resolve crash on startup

## 📊 Release Statistics
* **Total Commits:** 45
* **Unique Tickets:** 12
* **Generated By:** John Doe
```

### Slack Notification

```
🚀 New My Awesome App Release
• Version: v2.1.0 (commit: abc1234)
• Built by: John Doe

📦 Release v2.1.0 Summary:
• Analyzed 45 commits
• Found 12 unique tickets
• Commit range: v2.0.0..HEAD

📖 Release Notes: https://company.atlassian.net/wiki/...
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📚 [Documentation](https://github.com/your-org/release-docs/wiki)
- 🐛 [Issue Tracker](https://github.com/your-org/release-docs/issues)
- 💬 [Discussions](https://github.com/your-org/release-docs/discussions)
- 📧 Email: support@yourcompany.com

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

---

**Made with ❤️ by the Release Automation Team**
