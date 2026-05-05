# 🚀 WiFi-SpecterGhost

[🇺🇸 English](README_EN.md) | [🇪🇸 Español](README.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)

**WiFi-SpecterGhost** is an advanced auditing suite for Windows designed for retrieving and organizing WiFi network credentials. Unlike other scripts, it features a **Universal Engine** that ensures 100% effectiveness regardless of the operating system language.

> [!IMPORTANT]
> **Universal Engine v2.0**: We implemented a language-agnostic parsing logic that detects profiles through data structure, eliminating dependency on local text strings (Spanish, English, etc.).

---

## 🌟 Pro Features

- **🌍 Language Agnostic**: Works on any version of Windows (ES, EN, RU, CN, DE, etc.).
- **🥷 Stealth Modes**: Three execution levels based on the required discretion.
- **📦 Zero-Dependencies**: Self-contained and portable `.bat` and `.vbs` files.
- **🛡️ No-Overwrite**: Intelligent incremental log system (`wpsd.1.txt`, `wpsd.2.txt`).
- **🧹 Maintenance**: Integrated cleaner to erase audit traces with one click.

---

## 📂 Execution Modes

| Mode | Script | Visibility | Destination |
| :--- | :--- | :--- | :--- |
| **Audit** | `Normal.bat` | Visible Console | Project Root |
| **Stealth** | `Discreto.bat` | Minimized | `logs/` folder (Hidden) |
| **Ghost** | `Sutil.vbs` | 100% Invisible | `logs/` folder (Hidden) |

---

## 📊 Log Management

All results are automatically organized. Files generated in **Stealth** and **Ghost** modes are saved in the **`logs/`** folder, which is automatically marked as **hidden** by the system.

To view hidden logs:

1. Open File Explorer.
2. Go to **View** > **Show** > **Hidden items**.


---

## 🛠️ Requirements and Usage

- **System**: Windows 10 / 11 (PowerShell 5.1+).
- **Permissions**: Works with standard user permissions (user profile networks) or Administrator (all profiles).
- **Usage**: Simply run the desired mode. No installation required.

> [!TIP]
> If you need to quickly delete all generated reports, run `Limpiar.bat`.

---

## ⚠️ Legal Disclaimer

This software has been created exclusively for **educational and personal auditing purposes**. The author is not responsible for the misuse or illegal use of this tool. **Always use it at your own risk and in authorized environments.**

---

Developed with ❤️ by [4N0N1M0](https://github.com/ANONIMO432HZ)

