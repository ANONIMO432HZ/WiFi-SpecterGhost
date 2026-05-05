# 🚀 WiFi-SpecterGhost

[🇺🇸 English](README_EN.md) | [🇪🇸 Español](README.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)

**WiFi-SpecterGhost** es una suite de auditoría avanzada para Windows diseñada para la recuperación y organización de credenciales de redes WiFi. A diferencia de otros scripts, cuenta con un **Motor Universal** que garantiza el 100% de efectividad sin importar el idioma del sistema operativo.

> [!IMPORTANT]
> **Motor Universal v2.0**: Implementamos una lógica de parsing agnóstica al idioma que detecta perfiles por estructura de datos, eliminando la dependencia de cadenas de texto locales (español, inglés, etc.).

---

## 🌟 Características Pro

- **🌍 Agnóstico al Idioma**: Funciona en cualquier versión de Windows (ES, EN, RU, CN, DE, etc.).
- **🥷 Modos de Sigilo**: Tres niveles de ejecución según la discreción requerida.
- **📦 Zero-Dependencies**: Archivos `.bat` y `.vbs` autocontenidos y portables.
- **🛡️ No-Overwrite**: Sistema inteligente de logs incrementales (`wpsd.1.txt`, `wpsd.2.txt`).
- **🧹 Mantenimiento**: Limpiador integrado para borrar rastros de auditoría con un click.

---

## 📂 Modos de Ejecución

| Modo | Script | Visibilidad | Destino |
| :--- | :--- | :--- | :--- |
| **Auditoría** | `Normal.bat` | Consola Visible | Raíz del proyecto |
| **Sigilo** | `Discreto.bat` | Minimizado | Carpeta `logs/` (Oculta) |
| **Ghost** | `Sutil.vbs` | 100% Invisible | Carpeta `logs/` (Oculta) |

---

## 📊 Gestión de Logs

Todos los resultados se organizan automáticamente. Los archivos generados en modo **Sigilo** y **Ghost** se guardan en la carpeta **`logs/`**, la cual se marca automáticamente como **oculta** por el sistema.

Para ver los logs ocultos:

1. Abrir Explorador de Archivos.
2. Ir a **Vista** > **Mostrar** > **Elementos ocultos**.

---

## 🛠️ Requisitos y Uso

- **Sistema**: Windows 10 / 11 (PowerShell 5.1+).
- **Permisos**: Funciona con usuario estándar (redes del perfil) o Administrador (todas las redes).
- **Uso**: Simplemente ejecutá el modo deseado. No requiere instalación.

> [!TIP]
> Si necesitás borrar todos los reportes generados rápidamente, ejecutá `Limpiar.bat`.

---

## ⚠️ Aviso Legal

Este software ha sido creado exclusivamente para fines **educativos y de auditoría personal**. El autor no se responsabiliza por el uso indebido o ilegal de esta herramienta. **Usala siempre bajo tu propia responsabilidad y en entornos autorizados.**

---
<p align="center">
  Developed with ❤️ by <a href="https://github.com/ANONIMO432HZ">4N0N1M0</a>
</p>
