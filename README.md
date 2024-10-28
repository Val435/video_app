# Aplicación de Grabación y Reproducción de Videos

Esta aplicación permite a los usuarios grabar videos usando la cámara del dispositivo, pausar y reanudar la grabación, guardar los videos en una carpeta personalizada del almacenamiento y reproducir los videos guardados. Fue desarrollada usando **Flutter** y probada en **API 35 (Android 14)**.

## Funcionalidades Principales

1. **Grabación de Video**: Los usuarios pueden iniciar una grabación de video desde la cámara del dispositivo.
2. **Pausar/Reanudar Grabación**: Durante la grabación, los usuarios pueden pausar y reanudar la grabación según sea necesario.
3. **Detener y Guardar Video**: Los videos grabados pueden ser detenidos y guardados en una carpeta personalizada en el almacenamiento del dispositivo.
4. **Reproducción de Videos Guardados**: Los usuarios pueden reproducir cualquier video guardado dentro de la aplicación con controles básicos (reproducir, pausar y detener).
5. **Notificaciones mediante SnackBar**: Se notifica al usuario cada acción importante como grabación iniciada, pausada, reanudada, detenida y video guardado.
6. **Almacenamiento Personalizado**: Los videos se guardan en una carpeta creada dentro del almacenamiento del dispositivo llamada `MisVideosGuardados` en la ruta `/storage/emulated/0/Movies/MisVideosGuardados/`.

## Requisitos del Sistema

### Requisitos para Android

- **API mínima**: 21 (Android 5.0 - Lollipop)
- **API objetivo**: 35 (Android 14)
- **Soporte completo para Android 10, Android 11 y superior** (incluyendo permisos de gestión de almacenamiento completo).

### Permisos requeridos

1. **Permiso de cámara**: La aplicación requiere acceso a la cámara del dispositivo para grabar videos.
2. **Permiso de almacenamiento**: Se requiere acceso al almacenamiento para guardar los videos grabados y acceder a ellos. En dispositivos con Android 11 (API 30) o superior, se solicita permiso de "Acceso a todos los archivos" (`manageExternalStorage`).
3. **Permiso de escritura en el almacenamiento**: Necesario para guardar los archivos de video en el almacenamiento externo.

### Tecnologías y dependencias

- **Flutter SDK**: 3.0+
- **Dart SDK**: 2.17+
- **Android SDK**: API 35 (Android 14)
- **Dependencias**:
  - `camera`: Para capturar videos desde la cámara del dispositivo.
  - `path_provider`: Para obtener los directorios del sistema de archivos.
  - `permission_handler`: Para solicitar permisos de cámara y almacenamiento.
  - `video_player`: Para reproducir los videos grabados dentro de la aplicación.
  - `device_info_plus`: Para obtener información del dispositivo y la API utilizada.

## Instrucciones de Instalación y Configuración

### Requisitos previos

- **Flutter instalado**: Asegúrate de tener instalado Flutter en tu sistema. Puedes seguir las instrucciones de instalación en la [documentación oficial de Flutter](https://flutter.dev/docs/get-started/install).
- **Android Studio o Visual Studio Code**: Es recomendable usar uno de estos IDEs para correr la aplicación en un emulador o dispositivo físico.
- **Dispositivo físico o emulador con cámara**: La aplicación requiere acceso a la cámara para funcionar correctamente.

### Clonación del Proyecto

Para descargar el proyecto localmente, utiliza el siguiente comando:

```bash
git clone https://github.com/Val435/video_app1.git
```

### Instalación de Dependencias

Una vez clonado el proyecto, navega hasta la carpeta raíz del proyecto y ejecuta el siguiente comando para instalar las dependencias:

```bash
flutter pub get
```

### Ejecución de la Aplicación

Para ejecutar la aplicación en un dispositivo físico o emulador, utiliza el siguiente comando:

```bash
flutter run
```

Asegúrate de que tu dispositivo o emulador tiene una cámara disponible, ya que la aplicación no funcionará correctamente sin acceso a la cámara.

### Recomendaciones para Android 11 o superior

En dispositivos con Android 11 (API 30) o superior, es necesario que el usuario otorgue permisos de "Acceso a todos los archivos" para que la aplicación pueda guardar y acceder a videos en el almacenamiento externo. La aplicación solicitará automáticamente este permiso cuando sea necesario.

En caso de que los permisos sean denegados permanentemente, se redirigirá al usuario a la configuración de la aplicación para habilitar manualmente los permisos requeridos.

## Funcionalidades Detalladas

### Grabación de Video

- El usuario puede iniciar la grabación de un video presionando el botón de grabación.
- Durante la grabación, el usuario puede pausar la grabación con el botón de pausa y reanudarla cuando lo desee.
- Una vez finalizada la grabación, el usuario puede detenerla y guardar el video en el almacenamiento local.

### Reproducción de Videos

- Los videos guardados se pueden reproducir dentro de la aplicación.
- La aplicación proporciona controles básicos como reproducir, pausar y detener el video.

### Guardar los Videos en Almacenamiento Local

- Los videos se guardan en la carpeta `/storage/emulated/0/Movies/MisVideosGuardados/` del dispositivo.
- Si esta carpeta no existe, la aplicación la creará automáticamente.
- Los videos se guardan con un nombre único que incluye la fecha y hora de la grabación para evitar sobreescribir archivos.

### Mensajes mediante SnackBar

- La aplicación muestra mensajes mediante SnackBar cada vez que el usuario inicia, pausa, reanuda o detiene una grabación.
- Cuando un video es guardado, se muestra un mensaje de confirmación informando que el video ha sido guardado en el almacenamiento.

## Ejemplo de Uso de la Aplicación

1. **Inicio de grabación**: Presiona el botón de grabación (ícono de cámara) para iniciar la grabación.
2. **Pausar grabación**: Durante la grabación, presiona el botón de pausa para pausar la grabación.
3. **Reanudar grabación**: Después de pausar, presiona el botón de reproducción para continuar la grabación.
4. **Detener grabación**: Presiona el botón de detener para finalizar y guardar la grabación.
5. **Guardar video**: Presiona el botón de guardar para almacenar el video en la carpeta MisVideosGuardados.
6. **Reproducir video**: Desde la aplicación, navega a la sección de videos guardados y selecciona un video para reproducirlo.

## Consideraciones de Seguridad

- La aplicación solicita permisos sensibles como la cámara y el almacenamiento. Estos permisos solo se utilizan para las funcionalidades descritas y no se recopilan datos del usuario.
- Los videos guardados permanecen en el almacenamiento del dispositivo y no se envían a ningún servidor externo.

## Problemas Comunes

- **Permiso de almacenamiento denegado**: Si el usuario no concede permisos de almacenamiento, no podrá guardar ni acceder a los videos guardados. En este caso, se mostrará un mensaje de error y se solicitará nuevamente el permiso.
- **Fallo en la grabación de video**: Asegúrate de que la cámara del dispositivo está funcionando correctamente. En dispositivos sin cámara, la aplicación no funcionará.

