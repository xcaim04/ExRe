import '../../../core/constants/categories.dart';
import '../../../domain/entities/resource.dart';
import '../models/resource_model.dart';

/// Fuente local original con 24 recursos de prueba.
///
/// Se siembra una sola vez, en el primer arranque (`COUNT(*) == 0`).
/// A partir de ahí toda la app lee/escribe de SQLite, de modo que los datos
/// provienen de este archivo local y los cambios de favorito/completado
/// persisten entre sesiones.
const List<ResourceModel> seedResources = [
  // ---------------------------------------------------------------- Flutter
  ResourceModel(
    id: 'flt-01',
    title: 'Tu primer aplicación en Flutter',
    category: ResourceCategory.flutter,
    author: 'Equipo ExRE',
    durationMinutes: 45,
    level: ResourceLevel.basico,
    description:
        'Recorre el flujo completo de una app Flutter: crear el proyecto, '
        'entender el árbol de widgets y ejecutar el primer build en Android.',
    type: ResourceType.video,
  ),
  ResourceModel(
    id: 'flt-02',
    title: 'Widgets, StatelessWidget y StatefulWidget',
    category: ResourceCategory.flutter,
    author: 'Equipo ExRE',
    durationMinutes: 60,
    level: ResourceLevel.basico,
    description:
        'Diferencia entre widgets con y sin estado, cuándo usar setState y '
        'por qué la UI debe ser una función del estado.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'flt-03',
    title: 'StatefulWidget: ciclo de vida',
    category: ResourceCategory.flutter,
    author: 'Equipo ExRE',
    durationMinutes: 80,
    level: ResourceLevel.intermedio,
    description:
        'initState, didUpdateWidget, build, dispose y buildContext. Practica '
        'con un controlador de texto y observa cada transición.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'flt-04',
    title: 'Manejo de estado sin paquetes externos',
    category: ResourceCategory.flutter,
    author: 'Equipo ExRE',
    durationMinutes: 95,
    level: ResourceLevel.avanzado,
    description:
        'ChangeNotifier, ValueNotifier e InheritedNotifier resuelto con el '
        'propio SDK. Cuándo elegir cada uno y cómo evitar recreaciones.',
    type: ResourceType.lectura,
  ),

  // ---------------------------------------------------------------- Android
  ResourceModel(
    id: 'and-01',
    title: 'Estructura de un proyecto Android',
    category: ResourceCategory.android,
    author: 'Equipo ExRE',
    durationMinutes: 50,
    level: ResourceLevel.basico,
    description:
        'Gradle, manifest, MainActivity y el ciclo de la activity. Qué '
        'archivos toca Flutter y cuáles son solo Android nativo.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'and-02',
    title: 'Permisos y.platform channels',
    category: ResourceCategory.android,
    author: 'Equipo ExRE',
    durationMinutes: 85,
    level: ResourceLevel.avanzado,
    description:
        'Cómo invocar código Kotlin desde Dart con MethodChannel, y el '
        'proceso de declarar y pedir permisos en tiempo de ejecución.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'and-03',
    title: 'Compilar un APK release firmado',
    category: ResourceCategory.android,
    author: 'Equipo ExRE',
    durationMinutes: 40,
    level: ResourceLevel.intermedio,
    description:
        'Genera una clave, configura key.properties, construye el release y '
        'reduce el tamaño del APK con las reglas de ofuscación.',
    type: ResourceType.video,
  ),
  ResourceModel(
    id: 'and-04',
    title: 'Depuración con ADB y logs de Flutter',
    category: ResourceCategory.android,
    author: 'Equipo ExRE',
    durationMinutes: 35,
    level: ResourceLevel.basico,
    description:
        'Conecta un dispositivo real, filtra logs por tag y localiza errores '
        'de plataforma que no aparecen en el inspector de Flutter.',
    type: ResourceType.documento,
  ),

  // ---------------------------------------------------------------- Layouts
  ResourceModel(
    id: 'lay-01',
    title: 'Column, Row y Expanded',
    category: ResourceCategory.layouts,
    author: 'Equipo ExRE',
    durationMinutes: 55,
    level: ResourceLevel.basico,
    description:
        'Los dos widgets más usados de Flutter: eje principal, eje cruzado y '
        'cómo repartir el espacio con flex.',
    type: ResourceType.video,
  ),
  ResourceModel(
    id: 'lay-02',
    title: 'Stack, Positioned y capas',
    category: ResourceCategory.layouts,
    author: 'Equipo ExRE',
    durationMinutes: 50,
    level: ResourceLevel.intermedio,
    description:
        'Superposición de widgets, control de la posición y el orden de '
        'pintado con zIndex.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'lay-03',
    title: 'Flexible, Expanded y desbordamiento',
    category: ResourceCategory.layouts,
    author: 'Equipo ExRE',
    durationMinutes: 45,
    level: ResourceLevel.intermedio,
    description:
        'Diagnóstico de RenderFlex overflowed, causas habituales y las tres '
        'formas de resolverlo sin romper la maquetación.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'lay-04',
    title: 'Responsive: MediaQuery y LayoutBuilder',
    category: ResourceCategory.layouts,
    author: 'Equipo ExRE',
    durationMinutes: 70,
    level: ResourceLevel.avanzado,
    description:
        'Adapta la interfaz a distintos anchos usando MediaQuery, '
        'LayoutBuilder y puntos de ruptura propios.',
    type: ResourceType.lectura,
  ),

  // ------------------------------------------------------------ Scrollables
  ResourceModel(
    id: 'scr-01',
    title: 'SingleChildScrollView y Column',
    category: ResourceCategory.scrollables,
    author: 'Equipo ExRE',
    durationMinutes: 30,
    level: ResourceLevel.basico,
    description:
        'La forma más simple de lograr una pantalla desplazable y en qué '
        'situaciones se queda corta.',
    type: ResourceType.video,
  ),
  ResourceModel(
    id: 'scr-02',
    title: 'ListView.builder y itemExtent',
    category: ResourceCategory.scrollables,
    author: 'Equipo ExRE',
    durationMinutes: 65,
    level: ResourceLevel.intermedio,
    description:
        'Construcción diferida de listas largas, caché de elementos y el '
        'beneficio de itemExtent cuando la altura es homogénea.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'scr-03',
    title: 'ListView.separated y divisores',
    category: ResourceCategory.scrollables,
    author: 'Equipo ExRE',
    durationMinutes: 40,
    level: ResourceLevel.basico,
    description:
        'Separadores visuales entre elementos, y la diferencia con un '
        'ListView.builder normal.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'scr-04',
    title: 'ScrollController y control del desplazamiento',
    category: ResourceCategory.scrollables,
    author: 'Equipo ExRE',
    durationMinutes: 75,
    level: ResourceLevel.avanzado,
    description:
        'Escucha el desplazamiento, salta a un índice concreto y detén el '
        'comportamiento con physics personalizadas.',
    type: ResourceType.practica,
  ),

  // --------------------------------------------------------------- Slivers
  ResourceModel(
    id: 'slv-01',
    title: 'CustomScrollView: la pieza clave',
    category: ResourceCategory.slivers,
    author: 'Equipo ExRE',
    durationMinutes: 60,
    level: ResourceLevel.intermedio,
    description:
        'Qué es un sliver, por qué Flutter separa la geometría del layout y '
        'cómo se combinan varios en una sola vista.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'slv-02',
    title: 'SliverAppBar y collapsing toolbar',
    category: ResourceCategory.slivers,
    author: 'Equipo ExRE',
    durationMinutes: 80,
    level: ResourceLevel.intermedio,
    description:
        'Barra superior que se contrae al desplazarse, con flexibleSpace, '
        'pinned y expandedHeight.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'slv-03',
    title: 'SliverGrid y SliverList combinados',
    category: ResourceCategory.slivers,
    author: 'Equipo ExRE',
    durationMinutes: 70,
    level: ResourceLevel.avanzado,
    description:
        'Mezcla rejillas y listas en un mismo scroll, con '
        'SliverGridDelegateWithFixedCrossAxisCount y delegate automático.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'slv-04',
    title: 'SliverToBoxAdapter y secciones',
    category: ResourceCategory.slivers,
    author: 'Equipo ExRE',
    durationMinutes: 45,
    level: ResourceLevel.basico,
    description:
        'Inserta widgets de tamaño fijo entre secciones sliver para crear '
        'encabezados y separadores.',
    type: ResourceType.video,
  ),

  // ------------------------------------------------------------ Navegación
  ResourceModel(
    id: 'nav-01',
    title: 'Navegación con rutas nombradas',
    category: ResourceCategory.navegacion,
    author: 'Equipo ExRE',
    durationMinutes: 55,
    level: ResourceLevel.basico,
    description:
        'Navigator.pushNamed, onGenerateRoute y paso de argumentos entre '
        'pantallas sin depender de paquetes externos.',
    type: ResourceType.lectura,
  ),
  ResourceModel(
    id: 'nav-02',
    title: 'BottomNavigationBar con IndexedStack',
    category: ResourceCategory.navegacion,
    author: 'Equipo ExRE',
    durationMinutes: 65,
    level: ResourceLevel.intermedio,
    description:
        'Implementa una barra inferior de cinco pestañas conservando el '
        'estado de cada una con IndexedStack.',
    type: ResourceType.practica,
  ),
  ResourceModel(
    id: 'nav-03',
    title: 'Diálogos,hojas modales y pop',
    category: ResourceCategory.navegacion,
    author: 'Equipo ExRE',
    durationMinutes: 40,
    level: ResourceLevel.basico,
    description:
        'showDialog, showModalBottomSheet, Navigator.pop y la pila de rutas '
        'de Android y iOS.',
    type: ResourceType.video,
  ),
  ResourceModel(
    id: 'nav-04',
    title: 'Patrones de navegación en apps grandes',
    category: ResourceCategory.navegacion,
    author: 'Equipo ExRE',
    durationMinutes: 90,
    level: ResourceLevel.avanzado,
    description:
        'Comparación entre Navigator 1.0, 2.0 y go_router, y cuándo cada '
        'enfoque resuelve mejor un caso real.',
    type: ResourceType.lectura,
  ),
];
