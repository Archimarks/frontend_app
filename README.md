# 📱 Proyecto Flutter - Estructura de Carpetas

Este proyecto Flutter está organizado con una arquitectura modular que facilita el mantenimiento, la escalabilidad y la colaboración entre equipos.

## 📁 Estructura General

```FRONTEND_APP/
├── assets/
│   ├── Audio/       # Archivos de audio (ej. sonidos, efectos)
│   ├── Docs/        # Documentación en PDF, JSON u otros formatos
│   ├── Fonts/       # Tipografías personalizadas utilizadas por el proyecto
│   └── Images/      # Imágenes utilizadas en la app
│
├── lib/
│   ├── main.dart    # Punto de entrada de la aplicación Flutter
│   │
│   ├── app.dart     # Configuración principal de la aplicación (widgets, temas, etc.)
│   │
│   ├── i18n/        # Archivos de localización (ej. es.json para español)
│   │
│   └── src/
│       ├── Core/        # Infraestructura central y configuración global
│       │   ├── Api/         # Definiciones y configuración de API
│       │   ├── Barrels      # Archivos barrel para importar múltiples archivos
│       │   │    ├── base_cubit_barrel.dart      # Barrel para Cubit
│       │   │    └── configs_barrel.dart         # Barrel para Configs
│       │   ├── Configs/     # Configuraciones de entorno y globales
│       │   │    ├── api_config.dart      # Configuración de la API
│       │   │    └── app_storage.dart     # Configuración de almacenamiento local
│       │   ├── Errors/      # Manejo y definición de errores comunes
│       │   ├── Events/      # Definición de eventos para comunicación interna
│       │   ├── Keys/        # Claves (por ejemplo, para navegadores o formularios)
│       │   ├── Middlewares/ # Middlewares de la app (interceptores, validaciones, etc.)
│       │   └── Routes/      # Definición y manejo de rutas y navegación
│       │        ├── app_router.dart          # Configuración general del router
│       │        ├── routes_config.dart       # Lista de rutas por feature
│       │        └── route_names.dart         # Constantes de nombres de rutas
│       │
│       ├── Features/     # Módulos o funcionalidades de la app (feature-first architecture)
│       │   ├── <nombre_del_feature>/
│       │   │        ├── Data/
│       │   │        │   ├── Sources/           # Acceso a datos: API, BD, etc.
│       │   │        │   ├── Dtos/              # Modelos serializables (DTOs)
│       │   │        │   └── Repository_impl/   # Implementaciones concretas de contratos
│       │   │        ├── Domain/
│       │   │        │   ├── Entities/          # Entidades del dominio
│       │   │        │   ├── Contracts/       # Interfaces: repositorios, servicios, etc.
│       │   │        │   └── Usecases/        # Casos de uso del negocio
│       │   │        └── Presentation/
│       │   │             ├── Cubit/   # Cubits o BLoC
│       │   │             ├── Pages/         # Vistas principales (pantallas)
│       │   │             └── Widgets/       # Componentes reutilizables
│       │   │
│       │   ├── Login/     # Módulo de inicio de sesión
│       │   │   ├── Data/           # Datos y repositorios relacionados con el login
│       │   │   │   ├── Sources/           # Acceso a datos: API, BD, etc.
│       │   │   │   ├── Dtos/              # Modelos serializables (DTOs)
│       │   │   │   └── Repository_impl/   # Implementaciones concretas de contratos
│       │   │   ├── Domain/         # Lógica de negocio y entidades del login
│       │   │   │   ├── Entities/          # Entidades del dominio
│       │   │   │   ├── Contracts/       # Interfaces: repositorios, servicios, etc.
│       │   │   │   └── Usecases/        # Casos de uso del negocio
│       │   │   └── Presentation/   # UI y lógica de presentación del login
│       │   │       ├── Cubit/        # Cubits o BLoC
│       │   │       ├── Pages/        # Vistas principales (pantallas)
│       │   │       │   └── login_view.dart  # Página principal del login
│       │   │       └── Widgets/     # Componentes reutilizables
│       │   │
│       │   └── /     #
│       │
│       ├── Shared/       # Componentes reutilizables a través del proyecto
│       │   ├── Animations/  # Animaciones personalizadas
│       │   ├── Themes/      # Temas y estilos visuales
│       │   └── Widgets/     # Widgets reutilizables y comunes
│       │
│       └── Utils/        # Herramientas y utilidades
│           ├── Base/        # Constantes para la lógica de BLoC y Cubit
│           │   ├── BLoC/    # Implementaciones de BLoC
│           │   └── Cubit/   # Implementaciones de Cubit
│           │        ├── multi_bloc_builder.dart  # MultiBlocBuilder para manejar múltiples Cubits
│           │        ├── Connectivity/      #
│           │        │       ├── connectivity_cubit.dart  # Cubit para manejar la conectividad
│           │        │       └── connectivity_state.dart  # Estado del Cubit de conectividad
│           │        └── Database/      #
│           │               ├── database_connection_cubit.dart  # Cubit para manejar la conexión a la base de datos
│           │               └── database_connection_state.dart  # Estado del Cubit de conexión a la base de datos
│           │
│           ├── Constants/   # Constantes globales del proyecto
│           ├── Enums/       # Enumeraciones usadas en la lógica de negocio
│           ├── Extensions/  # Extensiones de clases nativas de Dart
│           ├── Remote/      # Conexiones remotas auxiliares
│           ├── Serverless/  # Funciones o lógica orientada a serverless
│           └── Services/    # Servicios globales (ej. almacenamiento, navegación, etc.)
└── test/
    ├── Unit/          # Pruebas unitarias
    ├── Elements/        # Pruebas de Elements (widgets)
    └── Integration/   # Pruebas de integración
```

## Patrones de gestión usados

BloC y Cubit son patrones de gestión del estado (state management) que provienen de la librería flutter_bloc, diseñada para ayudar a separar la lógica de negocio de la interfaz de usuario de forma clara y mantenible.

### 🔷 ¿Qué es BloC?

BLoC significa Business Logic Component. Es un patrón que ayuda a manejar el estado de una aplicación usando:

- Eventos (Events): Lo que ocurre (acciones del usuario, llamadas, etc.).

- Estados (States): Cómo se ve la UI en un momento dado.

- Streams: Canal por el cual se comunica el cambio de estado.

#### 📌 Características BloC

- Maneja eventos y emite estados.

- Ideal para lógica compleja.

- Es más detallado, pero también más verboso.

### 🟦 ¿Qué es Cubit?

Cubit es una versión más simple de BloC. También se basa en Streams, pero no usa eventos, lo que lo hace más directo y fácil de escribir para casos menos complejos.

#### 📌 Características Cubit

- Solo define estados, no eventos.

- Es más simple y directo.

- Ideal para lógicas más sencillas y rápidas.

### Explicación del uso de BloC y Cubit en esta app

BLoC: Se usa para features con flujos de eventos complejos, múltiples acciones que modifican el estado (ej: login con validación, loading, success, failure).

Cubit: Se usa para casos más simples o localizados, como mostrar/ocultar contraseña, cambiar un índice de tab, abrir un modal, etc.
