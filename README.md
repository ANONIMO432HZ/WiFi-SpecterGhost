# 🚀 WiFi-SpecterGhost

Este proyecto es una herramienta de auditoría local para recuperar contraseñas de redes WiFi guardadas en el sistema. Utiliza un motor de PowerShell robusto que funciona en sistemas Windows tanto en español como en inglés.

## 📂 Estructura del Proyecto

- **`Normal.bat`**: La versión estándar. Te muestra el progreso en la consola y deja el archivo `wpsd.txt` en la raíz.
- **`Discreto.bat`**: Versión semi-oculta. Muestra el progreso pero guarda el resultado en una carpeta oculta llamada `invisible`.
- **`Sutil.vbs`**: La versión "Ghost". No abre ventanas, no muestra nada. Trabaja en segundo plano y guarda todo en la carpeta oculta.
- **`core/`**: Contiene el motor (`engine.ps1`) que realiza el trabajo pesado.
- **`archive/`**: Carpeta con versiones obsoletas y experimentos previos.

## 🛠️ Requisitos

- Windows 10 o superior.
- Permisos estándar (netsh requiere permisos de usuario para ver perfiles).

## ⚠️ Disclaimer

Este software es para fines educativos y de auditoría personal. No me hago responsable del uso indebido que se le pueda dar. ¡Usalo con responsabilidad, fiera!

---
