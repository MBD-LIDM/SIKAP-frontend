# CI/CD Workflows

This directory contains GitHub Actions workflows for automated testing, building, and releasing the SIKAP Flutter application.

## Workflows

### 1. Build and Release (`build-and-release.yml`)

**Triggers:**
- Push to `main` branch
- Push tags matching `v*.*.*` pattern
- Pull requests to `main` branch (tests only)

**Jobs:**

#### Test
- Runs on every push and PR
- Checks code formatting
- Runs static analysis
- Executes all tests

#### Build Android
- Builds release APK (for direct installation)
- Builds release AAB (for Play Store or internal distribution)
- Uploads artifacts for download

#### Build Web
- Builds optimized web version
- Creates zip archive
- Ready for deployment to any static hosting

#### Release
- Only runs on push to main branch
- Downloads all build artifacts
- Generates automatic version from pubspec.yaml
- Creates GitHub Release with:
  - Auto-generated release notes
  - All platform builds attached
  - Version information
  - Commit history since last release

### 2. PR Checks (`pr-checks.yml`)

**Triggers:**
- Pull requests to `main` or `develop` branches

**Jobs:**
- Quick validation checks
- Code formatting verification
- Static analysis with strict rules
- Test execution with coverage
- Optional coverage upload to Codecov

## Version Management

Versions are automatically managed based on:
- **Base version**: From `pubspec.yaml` (currently: `0.1.0`)
- **Build number**: Auto-incremented based on commit count
- **Tag format**: `v{version}-build.{build_number}` (e.g., `v0.1.0-build.42`)

## Release Assets

Each release includes:

1. **app-release.apk** - Android APK for direct installation
2. **app-release.aab** - Android App Bundle for distribution
3. **web-release.zip** - Web build (extract and deploy)

## How to Use

### Automatic Releases

Simply push to main:
```bash
git push origin main
```

A new release will be automatically created with all platform builds.

### Manual Version Bump

To update the version, edit `pubspec.yaml`:
```yaml
version: 0.2.0  # Update this line
```

Then commit and push:
```bash
git add pubspec.yaml
git commit -m "chore: bump version to 0.2.0"
git push origin main
```

### Creating Tagged Releases

For official releases, create a git tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Downloading Builds

1. Go to the [Releases page](../../releases)
2. Find the desired release
3. Download the appropriate build for your platform
4. Extract and use as needed

## Configuration

### Flutter Version

Update Flutter version in workflow files:
```yaml
env:
  FLUTTER_VERSION: '3.27.1'  # Change this
```

### Java Version (for Android builds)

```yaml
env:
  JAVA_VERSION: '17'  # Change this if needed
```

## Troubleshooting

### Build Failures

1. Check the Actions tab for error details
2. Ensure all dependencies are compatible
3. Verify Flutter version compatibility
4. Check for platform-specific issues

### Release Not Created

- Ensure push is to `main` branch
- Check GitHub Actions permissions
- Verify `GITHUB_TOKEN` has write access

## Best Practices

✅ **DO:**
- Keep Flutter version updated
- Run tests locally before pushing
- Use meaningful commit messages
- Review build artifacts before distribution

❌ **DON'T:**
- Push directly to main without PR (configure branch protection)
- Skip version bumps for significant changes
- Ignore test failures
- Commit large binary files

## Future Enhancements

Consider adding:
- [ ] iOS builds (if needed in the future)
- [ ] Play Store deployment (when needed)
- [ ] App Store deployment (when needed)
- [ ] Fastlane integration
- [ ] Automated screenshot testing
- [ ] Performance testing
- [ ] Slack/Discord notifications
- [ ] Dependency scanning
- [ ] Security scanning

## Cost Optimization

To reduce GitHub Actions minutes:

1. **Use self-hosted runners** for private repos (if needed)
2. **Cache dependencies** (already implemented)
3. **Run tests selectively** for specific file changes

**Note**: iOS builds have been disabled to save on macOS runner costs. Enable them in the workflow if needed in the future.

## Support

For issues with the CI/CD pipeline:
1. Check the [Actions tab](../../actions)
2. Review the workflow logs
3. Open an issue with the workflow run URL
