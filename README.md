# Gestion de Vehiculos

Aplicacion movil desarrollada en Flutter como proyecto academico del ITLA orientada a la administracion de vehiculos, consulta de noticias automotrices y participacion comunitaria mediante foro.

---

## Descripcion General

La aplicacion permite a los usuarios gestionar informacion de sus vehiculos de manera organizada desde un dispositivo movil. Tambien integra contenido informativo y educativo del area automotriz.

El sistema consume una API REST proporcionada para manejar autenticacion, datos de usuarios, vehiculos, foro, noticias y catalogo.

---

## Integrantes

- Ramses Ambiorix Arno Rosario  
  Matricula: 20240078

- Geraldo Familia  
  Matricula: 20210145

---

## Funcionalidades Implementadas

### Modulos Publicos

- Pantalla Splash inicial
- Noticias automotrices
- Detalle de noticias
- Videos educativos
- Catalogo de vehiculos
- Detalle de vehiculos del catalogo
- Foro comunitario
- Detalle de temas del foro
- Pantalla Acerca de

### Modulos Privados

- Registro de usuario
- Activacion de cuenta
- Inicio de sesion
- Perfil del usuario
- Cambio de foto de perfil
- Mis vehiculos
- Crear vehiculo
- Editar vehiculo
- Subir foto de vehiculo
- Crear tema en foro
- Responder tema
- Cierre de sesion

---

## Tecnologias Utilizadas

- Flutter
- Dart
- Provider
- Dio
- SharedPreferences
- CachedNetworkImage
- Image Picker
- Flutter HTML
- URL Launcher
- YouTube Player Flutter

---

## Arquitectura del Proyecto

El proyecto fue estructurado por modulos para facilitar mantenimiento y escalabilidad.

```text
lib/
 ├── core/
 ├── models/
 ├── modules/
 ├── providers/
 ├── repositories/
 ├── services/
 └── utils/
