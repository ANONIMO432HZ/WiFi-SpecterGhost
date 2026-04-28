# 🚀 WiFi-SpecterGhost

**WiFi-SpecterGhost** es una suite de auditoria local diseñada para recuperar y organizar las contraseñas de redes WiFi guardadas en sistemas Windows. Utiliza un motor de PowerShell optimizado que garantiza compatibilidad tanto en sistemas en español como en ingles.

## 🌟 Caracteristicas Principales

- **Motor Robusto**: Detecta automaticamente el idioma del sistema para una extraccion precisa.
- **Portabilidad**: Los archivos `.bat` son autocontenidos y funcionan sin dependencias externas.
- **No-Overwrite**: Logica inteligente de incremento de archivos para evitar que pierdas tus reportes anteriores.
- **Sin Tildes**: Interfaz de consola limpia y compatible con cualquier configuracion regional de Windows.

## 📂 Modos de Ejecucion

El proyecto ofrece tres niveles de visibilidad segun tu necesidad:

1. **`Normal.bat` (Modo Auditoria)**:
    - Muestra SSIDs y contraseñas directamente en la terminal.
    - Genera un archivo de reporte en la raiz del proyecto.
    - Ideal para consultas rapidas y verificacion visual.

2. **`Discreto.bat` (Modo Sigilo)**:
    - Se ejecuta minimizado en la barra de tareas.
    - No muestra datos en la terminal (consola limpia).
    - Guarda los resultados automaticamente en la carpeta oculta `logs/`.

3. **`Sutil.vbs` (Modo Ghost)**:
    - Ejecucion 100% invisible (sin ventana de consola).
    - Trabaja totalmente en segundo plano.
    - Guarda los resultados en la carpeta oculta `logs/`.
    - Posee un sistema de fallback para encontrar el motor incluso si se cambia la estructura de carpetas.

4. **`Limpiar.bat` (Mantenimiento)**:
    - Borra instantaneamente todos los reportes generados y la carpeta `logs`.
    - Solicita confirmacion antes de proceder.

## 📊 Gestion de Logs

Todos los resultados se guardan siguiendo un patron de nombre incremental para evitar sobreescrituras:

- Primer reporte: `wpsd.txt`
- Siguientes: `wpsd.1.txt`, `wpsd.2.txt`, etc.

Los archivos generados por los modos **Discreto** y **Sutil** se encuentran en la carpeta **`logs/`**, la cual esta marcada como **oculta** por el sistema. Para verla, asegurate de tener activada la opcion "Mostrar archivos ocultos" en tu explorador de Windows.

## 🛠️ Requisitos y Uso

- **OS**: Windows 10 / 11.
- **Permisos**: Funciona con permisos de usuario estándar (para redes del perfil de usuario) o Administrador (para todos los perfiles).
- **Ejecucion**: Simplemente hace doble click en el modo que prefieras. No requiere instalacion.

## ⚠️ Aviso Legal

Este software ha sido creado exclusivamente para fines educativos y de auditoria personal. El autor no se responsabiliza por el uso indebido o ilegal de esta herramienta. **Usala siempre bajo tu propia responsabilidad y en entornos autorizados.**

---
*Developed for educational purposes only by [4N0N1M0](https://github.com/ANONIMO432HZ)*
