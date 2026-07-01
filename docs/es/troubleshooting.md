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

!!! warning "macOS: el instalador oficial dice `~/.bashrc`, pero macOS usa `zsh`"
    El instalador oficial de Google (`curl … | bash`) corre bajo `bash` y sugiere añadir el
    PATH a `~/.bashrc`. Pero desde macOS Catalina el shell por defecto es **`zsh`**, que **no
    lee `~/.bashrc`** → el binario queda instalado en `~/.local/bin/agy` pero ninguna terminal
    nueva lo encuentra. La solución es usar **`~/.zshrc`**:

    ```bash
    # 1) Verifica tu shell (en macOS suele ser /bin/zsh):
    echo $SHELL
    # 2) Confirma que el binario ejecuta por ruta absoluta:
    ~/.local/bin/agy --version
    # 3) Añade el PATH al archivo correcto de zsh y recarga:
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    ```

    No hace falta borrar la línea que quedó en `~/.bashrc`; es inofensiva. Nuestro wrapper
    `scripts/install_antigravity.sh` ya detecta el shell y escribe en el archivo correcto.

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

## macOS: `agy --version` funciona pero `agy` "no hace nada" (crash en macOS &lt; 12)

Síntoma típico: `agy --version` imprime la versión, pero `agy` (o `agy -p "hola"`) **regresa
al prompt sin mostrar nada** — ni salida ni error visible. El error real queda en el log:

```bash
tail -40 ~/.gemini/antigravity-cli/cli.log
```

Si ves algo como:

```
dyld: Symbol not found: _SecTrustCopyCertificateChain
  Referenced from: /Users/<tu-usuario>/.local/bin/agy (which was built for Mac OS X 12.0)
```

…es **incompatibilidad de versión de macOS**, no un problema de PATH, permisos ni librerías:

- `agy` está compilado para **macOS 12.0 (Monterey)**. El símbolo `_SecTrustCopyCertificateChain`
  es una API que Apple introdujo en macOS 12.0.
- En **macOS 11 (Big Sur) o anterior** ese símbolo no existe → en cuanto `agy` hace una conexión
  **HTTPS** (verificar el certificado TLS) **crashea** (SIGABRT). Por eso `--version` (que no
  usa red) sí funciona, pero cualquier acción real muere.

**Verifica tu versión SIEMPRE primero:**

```bash
sw_vers
```

**Solución:** es incompatibilidad de sistema operativo — **no hay librería instalable que lo
arregle**. Actualiza macOS a **12.0+** (Ajustes → Actualización de software) o usa un Mac más
nuevo (o Linux / Windows).

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
