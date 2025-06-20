# Contributing to Smart Release Documentation Generator

Thank you for your interest in contributing! This document provides guidelines for contributing to the Smart Release Documentation Generator GitHub Action.

## 🚀 Getting Started

### Development Setup

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/smart-release-docs-action.git
   cd smart-release-docs-action
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Testing Your Changes

1. **Create a test repository** with sample commits and version files
2. **Test the action locally** using [act](https://github.com/nektos/act)
3. **Validate different scenarios**:
   - Different project types (Flutter, React Native, Node.js)
   - Various commit message formats
   - Different ticket patterns
   - Confluence and Slack integrations

### Code Standards

- **Bash Scripts**: Follow shellcheck recommendations
- **Documentation**: Update README.md for any new features
- **Comments**: Add clear comments for complex logic
- **Error Handling**: Include proper error messages and exit codes

## 📝 Types of Contributions

### 🐛 Bug Reports

When reporting bugs, please include:

- **Clear description** of the issue
- **Steps to reproduce** the problem
- **Expected vs actual behavior**
- **Environment details** (OS, Action version, project type)
- **Sample workflow** that demonstrates the issue

### ✨ Feature Requests

For new features, please provide:

- **Use case description** - why is this needed?
- **Proposed solution** - how should it work?
- **Alternatives considered** - what other options exist?
- **Impact assessment** - who would benefit?

### 🔧 Code Contributions

#### New Features

1. **Open an issue first** to discuss the feature
2. **Follow the development setup** above
3. **Implement with tests** covering the new functionality
4. **Update documentation** including README.md
5. **Submit a pull request** with clear description

#### Bug Fixes

1. **Reference the issue** being fixed
2. **Include test cases** that reproduce the bug
3. **Verify the fix** works across different scenarios
4. **Update documentation** if behavior changes

## 🧪 Testing Guidelines

### Local Testing

Use [act](https://github.com/nektos/act) to test GitHub Actions locally:

```bash
# Install act
# macOS
brew install act

# Test the action
act -j test-action --secret-file .secrets
```

### Test Cases to Cover

1. **Version Extraction**
   - `pubspec.yaml` (Flutter)
   - `package.json` (Node.js/React Native)
   - Custom version files
   - Invalid version files

2. **Commit Analysis**
   - Various commit message formats
   - Different ticket patterns
   - Empty repositories
   - Large commit ranges

3. **Integration Testing**
   - Confluence API (with mock/test environment)
   - Slack webhooks (with test channels)
   - Git operations (tagging, history)

4. **Error Scenarios**
   - Missing configuration
   - Invalid API credentials
   - Network failures
   - Malformed inputs

## 📚 Documentation Standards

### README.md Updates

When adding features, update:
- **Feature list** in the overview
- **Input parameters** table
- **Usage examples** with the new feature
- **Use cases** if applicable

### Code Documentation

- **Function headers** with parameter descriptions
- **Inline comments** for complex logic
- **Error message clarity** for user understanding
- **Example configurations** in comments

## 🔄 Pull Request Process

### Before Submitting

1. **Test thoroughly** with different scenarios
2. **Update documentation** for any changes
3. **Run shellcheck** on bash scripts
4. **Verify examples** in README.md work
5. **Check for breaking changes**

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Refactoring

## Testing
- [ ] Tested with Flutter project
- [ ] Tested with React Native project
- [ ] Tested with Node.js project
- [ ] Tested Confluence integration
- [ ] Tested Slack integration
- [ ] Tested error scenarios

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated checks** must pass (if implemented)
2. **Manual review** by maintainers
3. **Testing verification** in different environments
4. **Documentation review** for clarity
5. **Final approval** and merge

## 🏷️ Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist

1. **Update version** in action.yml
2. **Update CHANGELOG.md** with release notes
3. **Test final version** thoroughly
4. **Create release tag** following v{MAJOR}.{MINOR}.{PATCH}
5. **Publish to marketplace** (maintainers only)

## 🤝 Community Guidelines

### Code of Conduct

- **Be respectful** and inclusive
- **Provide constructive feedback**
- **Help others learn and grow**
- **Focus on the issue, not the person**

### Communication

- **Issues**: For bug reports and feature requests
- **Discussions**: For questions and general discussion
- **Pull Requests**: For code contributions
- **Email**: For security issues or private matters

## 📞 Getting Help

- **Documentation**: Check README.md and wiki
- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Search existing issues before creating new ones
- **Community**: Join our community channels (if available)

## 🎯 Roadmap

Check our [project roadmap](https://github.com/your-org/smart-release-docs-action/projects) for:
- Planned features
- Current priorities
- Ways to contribute

## 🏆 Recognition

Contributors will be:
- **Listed in CONTRIBUTORS.md**
- **Mentioned in release notes**
- **Given credit** in documentation
- **Invited to maintainer team** (for significant contributions)

---

Thank you for helping make the Smart Release Documentation Generator better! 🚀
