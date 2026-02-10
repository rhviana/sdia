# Contributing to GDCR

Thank you for your interest in contributing to the Gateway Domain-Centric Routing (GDCR) project!

## 🎯 Ways to Contribute

### 1. 🐛 Report Bugs or Issues
- Search existing issues first
- Use the issue template
- Provide clear reproduction steps
- Include environment details (platform, version)

### 2. 💡 Suggest Enhancements
- Explain the use case
- Describe expected behavior
- Consider backward compatibility

### 3. 📝 Improve Documentation
- Fix typos or unclear explanations
- Add examples or diagrams
- Translate documentation

### 4. 🔧 Submit Code
- Platform-specific implementations
- Bug fixes
- Performance improvements
- New features (discuss first in Issues)

### 5. 📊 Share Results
- Implementation case studies
- Performance benchmarks
- ROI calculations

---

## 🚀 Getting Started

### 1. Fork the Repository
Click the "Fork" button at the top right of this page.

### 2. Clone Your Fork
```bash
git clone https://github.com/YOUR_USERNAME/gdcr.git
cd gdcr
```

### 3. Create a Branch
```bash
git checkout -b feature/your-feature-name
```

### 4. Make Changes
- Follow existing code style
- Add comments for complex logic
- Update documentation if needed

### 5. Commit Changes
```bash
git add .
git commit -m "Description of your changes"
```

Use conventional commit format:
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation changes
- `refactor:` code refactoring
- `test:` adding tests
- `chore:` maintenance tasks

### 6. Push to Your Fork
```bash
git push origin feature/your-feature-name
```

### 7. Create Pull Request
- Go to the original repository
- Click "New Pull Request"
- Select your fork and branch
- Fill out the PR template

---

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Code follows existing style
- [ ] All tests pass (if applicable)
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No merge conflicts

### PR Description Should Include
- **What:** Summary of changes
- **Why:** Reason for changes
- **How:** Implementation approach
- **Testing:** How you tested the changes

---

## 🎨 Code Style

### JavaScript
```javascript
// Use descriptive variable names
var routingKey = generateRoutingKey(metadata);

// Add comments for complex logic
// Normalize 241 unique actions to 15 standard verbs
var normalized = normalizeAction(action);

// Use consistent formatting
function extractMetadata(message) {
    var metadata = {};
    // ...
    return metadata;
}
```

### Documentation
- Use clear, concise language
- Include code examples
- Add diagrams where helpful
- Link to related sections

---

## 🧪 Testing

### For Code Contributions
1. Test on target platform (SAP BTP, Apigee, Kong, etc.)
2. Include test results in PR
3. Document test environment

### For Documentation
1. Check for typos and grammar
2. Verify all links work
3. Ensure formatting is correct

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the [CC BY 4.0 License](LICENSE).

### Attribution Requirement
All contributions must include proper attribution:
```
Based on Gateway Domain-Centric Routing (GDCR)
DOI: 10.5281/zenodo.18582469
Author: Ricardo Luz Holanda Viana
License: CC BY 4.0
```

---

## 🤝 Code of Conduct

### Our Standards
- **Be respectful** to all contributors
- **Be constructive** in feedback
- **Be patient** with new contributors
- **Be open** to different perspectives

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or insulting comments
- Personal attacks
- Spam or off-topic content

---

## 💬 Communication

### Questions?
- Open an [Issue](https://github.com/yourusername/gdcr/issues) with the "question" label
- Check [FAQ](docs/faq.md) first

### Discussions
- Use [Discussions](https://github.com/yourusername/gdcr/discussions) for:
  - Implementation strategies
  - Use case sharing
  - General questions

### Direct Contact
For sensitive matters, contact: [your-email@example.com]

---

## 🏆 Recognition

Contributors will be:
- Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Credited in release notes
- Mentioned in academic acknowledgments (if significant contribution)

---

## 📚 Resources

### Understanding GDCR
- [Architecture Overview](docs/architecture.md)
- [Full Academic Paper](https://zenodo.org/records/18582469)
- [Implementation Guide](docs/implementation-guide.md)

### Development
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## 🎯 Priority Areas

We especially welcome contributions in:

1. **Platform Implementations**
   - Kong Gateway
   - AWS API Gateway
   - Azure API Management
   - Apigee X
   - Tyk Gateway

2. **Documentation**
   - Translations (Portuguese, Spanish, German, Chinese)
   - Video tutorials
   - Interactive examples

3. **Tools**
   - Configuration generators
   - Migration scripts
   - Monitoring dashboards

4. **Testing**
   - Unit tests
   - Integration tests
   - Performance benchmarks

---

Thank you for contributing to GDCR! 🚀

**Questions?** Open an issue or start a discussion.

---

**Project DOI:** 10.5281/zenodo.18582469  
**License:** CC BY 4.0  
**Last Updated:** February 10, 2026
