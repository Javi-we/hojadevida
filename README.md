# UNIVERSIDAD POLITÉCNICA ESTATAL DEL CARCHI
## CARRERA DE COMPUTACIÓN - DESARROLLO DE APLICACIONES MÓVILES

**PRÁCTICA N°:** 2  
**DOCENTE:** PhD. Samuel Lascano Rivera  
**INTEGRANTE:** Javier Orlando Bolaños Tucanes  
**TEMA:** Evolución de Hoja de Vida: De Nativo Android a Despliegue Web Embed en Flutter  

---

## 📋 INTRODUCCIÓN

En la práctica previa se desarrolló una hoja de vida interactiva como una aplicación móvil nativa pura en Android Studio (Kotlin + Retrofit + Docker Backend). En la presente práctica, dicho producto evoluciona hacia una arquitectura de **contenedor híbrido (Hybrid Container Wrapper)**.

Para ello, la interfaz se maquetó como una aplicación web responsiva (HTML5, CSS3, JavaScript) con diseño *Mobile-First*, la cual es integrada posteriormente como un componente embebido (**WebView**) dentro de un contenedor nativo desarrollado en **Flutter**. Este enfoque permite evaluar de primera mano las diferencias clave en experiencia de usuario, mantenimiento de código y rendimiento entre el desarrollo nativo puro y el desarrollo híbrido embebido.

---

## 🎯 OBJETIVOS

### Objetivo General
Transformar la hoja de vida interactiva desarrollada previamente en Android Studio nativo a un formato web responsivo, para posteriormente integrarla como un componente embebido (WebView) dentro de una aplicación móvil desarrollada en Flutter.

### Objetivos Específicos
1. **Diseñar y maquetar** una hoja de vida en tecnologías web estándares (HTML5, CSS3, JavaScript) priorizando un diseño *Mobile-First* con cambio de tema (Claro/Oscuro), filtrado de aptitudes y acordeón interactivo.
2. **Implementar un contenedor híbrido en Flutter** (`cv_flutter_wrapper`) capaz de renderizar el contenido web tanto en modo local (*Offline Assets*) como remoto (*Docker Server / URL*).
3. **Evaluar la diferencia técnica, de experiencia de usuario (UI/UX) y de rendimiento** entre el desarrollo nativo puro en Android y el enfoque embebido en Flutter mediante un análisis comparativo estructurado.

---

## 📁 ESTRUCTURA DEL PROYECTO

```text
cv_flutter_wrapper/
├── pubspec.yaml                       # Configuración de dependencias (webview_flutter, url_launcher, share_plus)
├── README.md                          # Informe completo de la práctica y cuadro comparativo
├── web_cv/                            # FASE 1: Código fuente de la Web CV Responsiva
│   ├── index.html                     # HTML5 Semántico (header, section, article, footer)
│   ├── styles.css                     # CSS3 Flexbox/Grid con variables Light/Dark mode
│   ├── script.js                      # JS para filtro de aptitudes, acordeón y formulario
│   └── assets/
│       └── profile_photo.jpg          # Foto oficial de Javier Orlando Bolaños Tucanes
├── assets/
│   └── web/                           # FASE 2: Assets web embebidos en el paquete Flutter
│       ├── index.html
│       ├── styles.css
│       ├── script.js
│       └── profile_photo.jpg
├── lib/                               # Código fuente de la App en Flutter
│   ├── main.dart                      # Configuración de MaterialApp y gestión del tema
│   └── screens/
│       └── home_screen.dart           # Pantalla principal con AppBar, WebView, BottomNav y FAB
└── android/                           # Configuración nativa para Android
    └── app/src/main/AndroidManifest.xml
```

---

## 🛠️ DESARROLLO DE LA PRÁCTICA

### FASE 1: Rediseño a Formato Web (Web CV Responsiva)
- **Estructura Semántica:** Se utilizó HTML5 puro (`<header>`, `<main>`, `<section>`, `<article>`, `<footer>`) estructurado en secciones clave: *Resumen Profesional*, *Historial Laboral*, *Formación Académica*, *Aptitudes Técnicas*, *Pasatiempos* y *Contacto Directo*.
- **Diseño Mobile-First:** Maquetado con CSS3 (Flexbox y CSS Grid), garantizando adaptabilidad completa desde pantallas pequeñas de teléfonos (320px) hasta monitores de escritorio.
- **Interactividad en JS:**
  - **Filtro dinámico de habilidades:** Clasificación en tiempo real (*Todas*, *Desarrollo Web & .NET*, *Bases de Datos*, *Hardware & Redes*, *CNC & Láser*).
  - **Acordeón en Experiencia:** Expansión/colapso de las responsabilidades laborales en *Extreme Design* y la *UPEC*.
  - **Cambiador de Tema:** Toggle en tiempo real entre Modo Claro y Modo Oscuro.
  - **Formulario de Contacto:** Validación y retroalimentación interactiva.

### FASE 2: Integración Embed en Flutter (Mobile App Wrapper)
- **Creación del Proyecto:** Proyecto Flutter denominado `cv_flutter_wrapper`.
- **Dependencias:** Paquete oficial `webview_flutter` para el motor WebView, `url_launcher` para llamadas telefónicas y `share_plus` para la función nativa de compartir.
- **Doble Esquema de Carga (Local + Remoto):**
  - **Opción A (Assets Locales):** Carga instantánea sin internet consumiendo `assets/web/index.html`.
  - **Opción B (Servidor Remoto):** Carga dinámica consumiendo `http://10.0.2.2:3000` (Backend Docker).
- **Controles Nativos en Flutter:**
  - **AppBar Nativa:** Indicador de estado (*Local/Remoto*), botón para cambiar fuente de carga, botón de recarga (*Reload*), toggle de tema global y botón para compartir perfil.
  - **BottomNavigationBar Nativa:** 4 botones de navegación rápida con desplazamiento automático (*Smooth Scroll*) a los anclas HTML (`#resumen`, `#experiencia`, `#aptitudes`, `#contacto`).
  - **FloatingActionButton:** Botón flotante nativo de llamada directa al `0995921363`.

---

## 📊 ANÁLISIS COMPARATIVO: NATIVO ANDROID VS. EMBEBIDO FLUTTER WEBVIEW

| Criterio / Dimensión | Desarrollo Nativo Puro (Android / Kotlin) | Enfoque Embebido / Hybrid Container (Flutter WebView) |
| :--- | :--- | :--- |
| **Rendimiento y FPS** | **Excelente (60 - 120 FPS constante).** Acceso directo a la GPU sin capas intermedias. Menor consumo de RAM. | **Aceptable (50 - 60 FPS).** Leve sobrecarga de memoria debido al motor del navegador (*Chromium/WebKit*) ejecutándose dentro de Flutter. |
| **Experiencia de Usuario (UI/UX)** | **Nativa y Fluida.** Componentes del sistema operativo (Material Design nativo), animaciones táctiles inmediatas y sin scroll stutter. | **Buena.** Sensación cercana a nativo si el CSS es ligero, aunque los eventos táctiles y desplazamientos web pueden diferir sutilmente de los gestos del SO. |
| **Tiempo de Desarrollo** | **Mayor.** Requiere diseñar layouts XML/Compose específicos para Android y reescribir si se migra a iOS. | **Muy Rápido.** Reutilización inmediata de la base de código web en Android, iOS, Web y Desktop. |
| **Reutilización de Código** | **Baja (Específica de la plataforma).** El código Kotlin/XML no corre directamente en la web. | **Máxima (100% de la UI).** Una única web HTML/CSS/JS sirve para el sitio web en línea y para la App móvil dentro del WebView. |
| **Acceso a APIs Nativas** | **Directo e Ilimitado.** Acceso nativo a Bluetooth, sensores, cámara, almacenamiento y background tasks sin intermediarios. | **Mediante Puente / Wrapper.** El contenedor Flutter debe exponer las APIs nativas (llamadas, compartir, GPS) e interactuar con el WebView mediante Javascript Channels. |
| **Mantenibilidad** | Requiere mantener dos repositorios separados si existe una plataforma web. | Facilita actualizaciones centralizadas: cambiar el HTML/CSS del servidor actualiza automáticamente la App sin recompilar la APK. |

---

## 💡 CONCLUSIONES

En conclusión, el uso de Flutter con webview_flutter permitió aprovechar una página web que ya estaba desarrollada con HTML, CSS y JavaScript. Esto ayudó a reducir el tiempo necesario para crear la aplicación y también facilitó su mantenimiento, ya que no fue necesario desarrollar todo nuevamente desde cero.

También se pudo comprobar que, aunque una aplicación desarrollada de forma nativa puede tener un mejor rendimiento y consumir menos memoria, el uso de un contenedor híbrido ofrece una ventaja importante. Las actualizaciones de la interfaz pueden hacerse directamente desde el servidor, sin tener que crear y publicar una nueva versión de la aplicación cada vez que se realiza un cambio.

Finalmente, la combinación de elementos propios de Flutter con el contenido web dentro del WebView permitió crear una aplicación más completa y funcional. De esta manera, se pueden aprovechar las ventajas del desarrollo web junto con herramientas nativas como botones, navegación, enlaces y opciones para compartir contenido.
---

## 📚 BIBLIOGRAFÍA

- **Flutter Team.** (2025). *webview_flutter [Paquete de Dart]*. pub.dev. https://pub.dev/packages/webview_flutter
- **Flutter.** (2025). *Flutter documentation*. Google. https://docs.flutter.dev
- **Marcotte, E.** (2011). *Responsive Web Design*. A Book Apart.
- **Mozilla.** (2025). *MDN Web Docs: HTML, CSS y JavaScript*. https://developer.mozilla.org/es/
- **Windmill, E.** (2020). *Flutter in Action*. Manning Publications.
