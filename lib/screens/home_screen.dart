import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isLocalSource = true;
  int _currentIndex = 0;

  // URL del servidor local de Docker Backend o GitHub Pages como alternativa remota
  final String _remoteUrl = 'http://10.0.2.2:3000';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Sincronizar tema con WebView al finalizar la carga
            _updateWebViewTheme();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Error en WebView: ${error.description}');
          },
        ),
      );

    _loadContent();
  }

  void _loadContent() {
    if (_isLocalSource) {
      _controller.loadFlutterAsset('assets/web/index.html');
    } else {
      _controller.loadRequest(Uri.parse(_remoteUrl));
    }
  }

  void _toggleSource() {
    setState(() {
      _isLocalSource = !_isLocalSource;
    });
    _loadContent();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLocalSource
              ? '📂 Fuente cambiada a Assets Locales (Offline)'
              : '🌐 Fuente cambiada a Servidor Remoto ($_remoteUrl)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateWebViewTheme() {
    final themeMode = widget.isDarkMode ? 'dark' : 'light';
    _controller.runJavaScript('''
      document.documentElement.setAttribute('data-theme', '$themeMode');
    ''');
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    String targetAnchor = '#resumen';
    switch (index) {
      case 0:
        targetAnchor = '#resumen';
        break;
      case 1:
        targetAnchor = '#experiencia';
        break;
      case 2:
        targetAnchor = '#aptitudes';
        break;
      case 3:
        targetAnchor = '#contacto';
        break;
    }

    _controller.runJavaScript('''
      window.location.hash = '$targetAnchor';
    ''');
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '0995921363');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo realizar la llamada')),
        );
      }
    }
  }

  void _shareProfile() {
    Share.share(
      'Hoja de Vida Profesional de Javier Orlando Bolaños Tucanes - Estudiante de Ingeniería en Computación UPEC. Contacto: 0995921363 | sotgg45@gmail.com',
      subject: 'Hoja de Vida - Javier Bolaños',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Javier Bolaños - CV Embed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              _isLocalSource ? '📂 Contenedor Híbrido (Local)' : '🌐 Servidor Remoto (Docker)',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isLocalSource ? Icons.folder : Icons.language),
            tooltip: _isLocalSource ? 'Cambiar a Servidor Remoto' : 'Cambiar a Assets Locales',
            onPressed: _toggleSource,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            tooltip: 'Cambiar Tema Nativo & Web',
            onPressed: () {
              widget.onToggleTheme();
              _updateWebViewTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar WebView',
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartir Perfil',
            onPressed: _shareProfile,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _makePhoneCall,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        icon: const Icon(Icons.call, color: Colors.white),
        label: const Text('Llamar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarThemeData(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Resumen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Experiencia',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flash_on),
                label: 'Aptitudes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'Contacto',
              ),
            ],
          ),
        ].first.items,
      ),
    );
  }
}
