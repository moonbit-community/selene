# Contributing to Selene

Thank you for your interest in contributing to Selene! This guide will help you understand how to contribute effectively to the project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [How to Contribute](#how-to-contribute)
- [Code Guidelines](#code-guidelines)
- [Commit Message Convention](#commit-message-convention)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

## Getting Started

Selene is an experimental game engine built with MoonBit, designed to encourage creativity through simple, modular, and efficient game development. Before contributing, please:

1. Read the [README](README.md) and [Selene README](selene-core/README.md) to understand the project goals
2. Follow the [tutorial](docs/tutorial-en.md) to get familiar with the engine
3. Explore the [example projects](examples/) to see Selene in action
4. Check existing [issues](https://github.com/moonbit-community/selene/issues) for ways to contribute

## Development Setup

### Prerequisites

- [MoonBit toolchain](https://www.moonbitlang.com/download/) (latest version)
- A modern web browser
- Git for version control

### Setting Up the Project

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/moonbit-community/selene.git
   cd selene
   ```

2. Build the core engine:
   ```bash
   cd selene-core
   moon build --target js
   ```

3. Build the canvas backend:
   ```bash
   cd ../selene-canvas
   moon build --target js
   ```

4. Run the example game:
   ```bash
   cd ../examples/pixeladventure
   moon build --target js
   python3 -m http.server 8000
   # Visit http://localhost:8000 in your browser
   ```

## Project Structure

```
selene/
├── selene-core/          # Core engine modules
│   └── src/
│       ├── system/       # ECS system and app management
│       ├── math/         # Mathematical utilities (vectors, transforms)
│       ├── sprite/       # Sprite rendering and animation
│       ├── collision/    # Collision detection and physics
│       ├── audio/        # Audio system
│       ├── camera/       # Camera and UI management
│       ├── tilemap/      # Tile map support
│       └── ...
├── selene-canvas/        # Canvas2D backend implementation
├── examples/              # Complete example games
├── docs/                 # Documentation and tutorials
└── README.md
```

### Key Components

- **selene-core**: The main engine with modular ECS architecture
- **selene-canvas**: Official Canvas2D rendering backend
- **examples**: A complete platform game demonstrating engine features

## How to Contribute

### Types of Contributions

1. **Bug Reports**: Report issues with detailed reproduction steps
2. **Feature Requests**: Suggest new engine features or improvements
3. **Code Contributions**: Fix bugs, add features, or improve performance
4. **Documentation**: Improve tutorials, API docs, or examples
5. **Examples**: Create new example games or demos

### Bug Reports

When reporting bugs, please include:

- MoonBit version and operating system
- Steps to reproduce the issue
- Expected vs. actual behavior
- Minimal code example if possible
- Screenshots or error messages

### Feature Requests

For new features:

- Describe the use case and benefit
- Consider if it fits the engine's philosophy (simple, modular, efficient)
- Propose an API design if applicable
- Check if similar functionality already exists

### Pull Requests

1. **Create an issue first** for significant changes to discuss the approach
2. **Fork the repository** and create a feature branch
3. **Make focused commits** that do one thing well
4. **Test your changes** thoroughly
5. **Update documentation** if needed
6. **Submit a pull request** with a clear description

## Code Guidelines

### MoonBit Style

- Use clear, descriptive names for functions and variables
- Follow existing code formatting and patterns
- Document public APIs with comments
- Format with `moon fmt` and `moon info`

### Architecture Principles

- **Modularity**: Keep components loosely coupled
- **Simplicity**: Prefer simple solutions over complex ones
- **Performance**: Consider efficiency, especially for core systems
- **Compatibility**: Maintain backward compatibility within version series

### Adding New Features

- Place new modules in appropriate directories under `selene-core/src/`
- Export public APIs through module interfaces (`.mbti` files)
- Add corresponding functionality to backends if needed
- Update the example project to demonstrate new features

## Commit Message Convention

Follow this format for commit messages:

```
<type>: <description>

[optional body]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `doc`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```
feat: add particle system support

Implements basic particle system with configurable emitters,
physics simulation, and batch rendering for performance.

fix: resolve camera boundary clamping issue

Camera now properly respects world boundaries when following
entities near map edges.

doc: update tutorial with audio system examples
```

## Testing

### Manual Testing

- Test your changes with the example projects
- Verify functionality across different browsers
- Check performance with complex scenes
- Test edge cases and error conditions

### Automated Testing

- Run existing tests: `moon test`
- Add unit tests for new mathematical functions
- Test collision detection algorithms thoroughly
- Verify ECS component behavior

## Documentation

### API Documentation

- Document all public functions and types
- Include usage examples for complex APIs
- Explain performance characteristics when relevant
- Keep documentation up-to-date with code changes

### Tutorials and Examples

- Update existing tutorials when adding features
- Create examples for new functionality
- Ensure examples are well-commented
- Test all code examples for correctness

## Community

### Communication

- **GitHub Issues**: For bug reports and feature requests
- **Pull Requests**: For code contributions and discussions
- **README**: For general project information

### Getting Help

- Check existing documentation and examples first
- Search issues for similar problems
- Create a new issue with detailed information
- Be patient and respectful in all interactions

### Code of Conduct

- Be respectful and inclusive to all contributors
- Focus on constructive feedback and suggestions
- Help newcomers get started with the project
- Celebrate contributions from the community

## Version Compatibility

- **0.10.x series**: Stable during MGPIC 2025 competition (until December 2025)
- **Future versions**: May introduce breaking changes
- Always document breaking changes clearly
- Provide migration guides when possible

## Release Process

For maintainers:

1. Update version numbers in `moon.mod.json` files
2. Update CHANGELOG with notable changes
3. Create git tag with version number
4. Publish packages to MoonBit registry

## Recognition

All contributors will be recognized in the project's acknowledgments. Significant contributions may result in becoming a project maintainer.

Thank you for contributing to Selene! Your efforts help make game development with MoonBit more accessible and enjoyable for everyone.