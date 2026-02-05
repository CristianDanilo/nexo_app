# Nexo - Rick & Morty Multiverse App

Una aplicación de Flutter que permite explorar el multiverso de Rick & Morty, implementando autenticación segura, persistencia de datos local y una interfaz de usuario estilo "Neon Dark".



##  Características principaless
- **Autenticación con Firebase:** Sistema de Login y Registro dinámico.
- **Gestión de Estado con GetX:** Navegación y reactividad eficiente.
- **Persistencia Local (Hive):** Los personajes se guardan en caché para permitir la visualización sin conexión inmediata.
- **Scroll Infinito:** Paginación automática para explorar los cientos de personajes de la API.
- **Diseño Premium:** Interfaz oscura con efectos neón, animaciones Hero y optimización de imágenes con `CachedNetworkImage`.

##  Stack Tecnológico
- **Lenguaje:** Dart
- **Framework:** Flutter
- **Backend:** Firebase Auth
- **Base de Datos Local:** Hive
- **API:** [The Rick and Morty API](https://rickandmortyapi.com/)



## Instalación y Configuración

Sigue estos pasos para correr el proyecto localmente:

1. **Clonar el repositorio:**
   ```bash
    git clone https://github.com/CristianDanilo/nexo_app.git
   ```
2. **Instalar dependencias:**
   ```bash
    flutter pub get
   ```
## Configuración de Firebase:
1. **Crea un proyecto en Firebase Console.**
2. **Añade una app de Android/iOS.**
3. **Descarga el archivo google-services.json (Android) o GoogleService-Info.plist (iOS) y colócalo en las carpetas correspondientes (android/app/ o ios/Runner/).**
4.  **Habilita Email/Password en el apartado de Authentication.**

##Ejecutar la aplicación:
  ```bash
   flutter run
  ```
## Estructura del Proyecto (Clean Architecture)
1. **lib/app/data/: Modelos de datos y proveedores de API.**
2. **lib/app/modules/: Vistas y controladores (Login, Home, Details).**
3. **lib/app/routes/: Configuración de rutas de navegación.**
