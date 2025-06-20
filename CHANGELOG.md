# Changelog

All notable changes to the Smart Release Documentation Generator will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **🕒 Version Fallback Feature** - Automatic date-time based version generation when version files are missing
- **⚙️ Custom Date Formats** - Configurable fallback version format using standard date format patterns
- Initial release of Smart Release Documentation Generator
- Automated release notes generation from git commits
- JIRA/ticket integration with automatic linking
- Confluence wiki markup conversion and publishing
- Slack notifications with release highlights
- Git tagging with comprehensive metadata
- Smart categorization of commits by type
- Support for multiple project types (Flutter, React Native, Node.js, etc.)
- Comprehensive configuration options
- Marketplace-ready documentation and examples

### Features
- 📝 **Automated Release Notes** - Generate comprehensive release notes from git commits
- 🕒 **Smart Version Fallback** - Never fails! Auto-generates date-time versions when version files are missing
- 🎫 **JIRA Integration** - Automatically detect and link JIRA tickets
- 📚 **Confluence Publishing** - Upload formatted documentation to Confluence
- 💬 **Slack Notifications** - Send release announcements with highlights
- 🏷️ **Git Tagging** - Create annotated release tags automatically
- 📂 **Smart Categorization** - Organize commits by type (features, bugs, etc.)
- 🔧 **Highly Configurable** - Extensive customization options including custom date formats
- 📱 **Mobile-Friendly** - Perfect for Flutter, React Native, and mobile projects

### Enhanced
- **Error Handling** - Robust fallback mechanism ensures documentation is always generated
- **Test Coverage** - Added comprehensive tests for version fallback scenarios

### Supported Project Types
- Flutter applications (pubspec.yaml)
- React Native applications (package.json)
- Node.js projects (package.json)
- Python projects (setup.py, pyproject.toml)
- Java/Kotlin projects (gradle.properties, pom.xml)
- iOS applications (Info.plist)
- Android applications (build.gradle)
- Custom version files with regex patterns

### Configuration Options
- Version file detection and extraction
- Commit range specification
- Ticket pattern customization
- Release categorization
- Confluence integration
- Slack integration
- Git tagging options
- Output format selection

## [1.0.0] - 2025-06-20

### Added
- Initial public release
- Core functionality for release documentation generation
- GitHub Actions marketplace compatibility
- Comprehensive documentation and examples
