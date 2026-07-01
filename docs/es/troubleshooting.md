---
title: Solución de problemas de Antigravity CLI (agy)
description: Errores comunes al instalar Antigravity CLI y cómo resolverlos: agy command not found, PATH, permisos, checksum, cuarentena de macOS, musl.
---

# Solución de problemas

## `agy: command not found` / `agy no se reconoce`

El binario se instaló pero no está en tu `PATH`, o la terminal aún no recargó el perfil.

=== "Linux / macOS"

    ```bash
    # 1) Confirma que el binario existe:
    ls -l ~/.local/bin/agy
    # 2) Añade al PATH y recarga:
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc   # o ~/.zshrc
    source ~/.bashrc                                            # o ~/.zshrc
    ```

=== "Windows"

    Abre una terminal **nueva** (el PATH no se actualiza en la sesión actual). Si sigue
    sin reconocerse, revisa que `%LOCALAPPDATA%\agy\bin` esté en el PATH de usuario
    ([ver Windows](windows.md)).

!!! info "Por qué pasa"
    Un script no puede cambiar el `PATH` de la terminal que lo invocó. Siempre necesitas
    una **terminal nueva** o `source` tras instalar.

## `agy --version` no imprime nada

Casi siempre es el mismo problema de PATH: estás invocando un `agy` que no existe en esta
sesión. Prueba con la ruta absoluta:

```bash
~/.local/bin/agy --version
```

Si con ruta absoluta sí imprime, es PATH (ver arriba).

## `Write Error: Permission denied`

El instalador no pudo escribir en `~/.local/bin`. Instala en otro directorio:

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$HOME/bin"
```

Recuerda añadir ese directorio a tu `PATH`.

## `Security Halt: checksum does not match`

El instalador detectó que el archivo descargado no coincide con el checksum SHA512
esperado. **No lo ignores.** Reintenta (pudo ser una descarga corrupta); si persiste,
revisa tu red/proxy/firewall o un posible problema en el servidor.

## macOS: "Apple no puede comprobar si contiene malware"

Quita la cuarentena de Gatekeeper:

```bash
xattr -d com.apple.quarantine ~/.local/bin/agy
```

## `Either curl or wget is required`

Instala uno de los dos:

```bash
sudo apt install -y curl     # Debian/Ubuntu
sudo dnf install -y curl     # Fedora
```

## "Ya está instalado" pero quiero reinstalar

El instalador es idempotente. Para forzar una instalación limpia, borra el binario primero:

```bash
rm ~/.local/bin/agy                       # Linux/macOS
Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force   # Windows (PowerShell)
```

## Linux musl / Alpine: el binario no ejecuta

El instalador oficial detecta musl automáticamente. Si lo descargaste a mano, asegúrate de
usar la variante `linux_<arch>_musl`. Más detalle en el [Manual técnico](manuales/tecnico.md).

## macOS: permitir grabación de pantalla para asistencia remota (Google Meet)

Si vas a recibir soporte remoto por **Google Meet** y necesitas **compartir tu pantalla**,
macOS exige que autorices explícitamente a tu navegador a grabar la pantalla.

!!! note "Para macOS Ventura y versiones posteriores (macOS 13+)"
    1. Haz clic en el menú **Apple** (el ícono de la manzana en la esquina superior izquierda).
    2. Selecciona **Configuración del Sistema** (*System Settings*).
    3. En el menú lateral izquierdo, haz clic en **Privacidad y seguridad** (*Privacy & Security*).
    4. Desplázate hacia abajo en el panel derecho y selecciona **Grabación de pantalla** (*Screen Recording*).
    5. Busca en la lista el navegador que usas para Google Meet (por ejemplo, **Google Chrome**).
    6. Activa el interruptor junto a ese navegador.
    7. Es posible que el sistema te pida ingresar la contraseña de tu Mac o usar **Touch ID** para confirmar el cambio.
    8. Aparecerá un mensaje indicando que el navegador no podrá grabar la pantalla hasta que se reinicie. Haz clic en **Salir y volver a abrir** (*Quit & Reopen*).

---

¿Tu caso no está aquí? Abre un *issue* en
[GitHub](https://github.com/varelaia/antigravity-installer/issues).
