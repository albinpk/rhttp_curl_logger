# Contributing to rhttp_curl_logger

🎉 Thanks for your interest in contributing to **rhttp_curl_logger**! We welcome contributions to improve the package and make it more useful for everyone.

---

## 📌 Before You Start

- Please read this guide carefully before submitting issues or pull requests.
- Ensure your contributions align with the purpose of this package: **logging HTTP requests as cURL commands in apps using `rhttp`**.

---

## 🛠️ How to Contribute

### 1. Fork & Clone

Fork the repository and clone it locally:

```bash
git clone https://github.com/albinpk/rhttp_curl_logger.git
cd rhttp_curl_logger/packages/rhttp_curl_logger
```

### 2. Set Up the Project

Make sure you have Flutter installed. Then get dependencies:

```bash
fvm install
flutter pub get
```

Run tests to verify everything is working:

```bash
flutter test
```

### 3. Make Your Changes

- Add your feature or fix.
- Write tests for your changes if applicable.
- Format the code using:

```bash
dart format .
```

- Analyze the code to ensure there are no warnings or errors:

```bash
dart analyze
```

### 4. Commit Your Changes

Use clear and descriptive commit messages:

```bash
git commit -m "feat: add option to toggle logging headers"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation updates
- `refactor:` for code restructuring
- `test:` for adding/modifying tests
- `chore:` for maintenance tasks

---

## ✅ Pull Request Checklist

Before submitting your PR:

- [ ] All tests pass.
- [ ] Code is formatted and analyzed with no issues.
- [ ] The feature/fix is relevant and focused.
- [ ] `README.md` and/or example is updated if necessary.

Open a pull request with a clear title and description. Reference any related issues.

---

## 🗣 Code of Conduct

We expect all contributors to adhere to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

---

## 🙌 Thank You!

Your help makes this project better. Whether it's filing an issue, fixing a bug, or suggesting an enhancement — you're appreciated!
