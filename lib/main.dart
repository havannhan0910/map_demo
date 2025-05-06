import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_demo/mbtiles_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:vector_tile_renderer/src/themes/theme.dart' as tiles;
import 'package:vector_tile_renderer/src/themes/theme_reader.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MbTilesProvider.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  tiles.Theme? _theme;

  final _mapController = MapController();

  @override
  void initState() {
    _initTheme();
    super.initState();
  }

  Future<void> _initTheme() async {
    try {
      final response = await rootBundle.loadString("assets/style.json");

      setState(() {
        _theme =
            ThemeReader().read(jsonDecode(response) as Map<String, Object?>);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return _theme == null
        ? Container()
        : Scaffold(
            body: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(21.033333, 105.849998),
                initialZoom: 14,
                minZoom: 3,
                maxZoom: 14,
              ),
              children: [
                // TileLayer(
                //   urlTemplate:
                //       "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                //   subdomains: const ['a', 'b', 'c'],
                // ),
                VectorTileLayer(
                  theme: _theme!,
                  tileProviders: TileProviders({
                    'openmaptiles': MbTilesVectorTileProvider(
                      mbtiles: MbTiles(mbtilesPath: MbTilesProvider.dbPath),
                    ),
                  }),
                ),
              ],
            ),
          );
  }
}
