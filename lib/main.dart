import 'package:achieve_takehome_test/pages/assets_page.dart';
import 'package:achieve_takehome_test/providers/AssetsProvider.dart';
import 'package:achieve_takehome_test/services/ApiService.dart';
import 'package:achieve_takehome_test/services/serviceFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssetsProvider>(
      create: (_) => AssetsProvider(
        apiService: sl.get<ApiService>(),
      ),
      child: MaterialApp(
        title: 'CoinCap Assets',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(elevation: 0.5),
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            systemOverlayStyle:SystemUiOverlayStyle.dark,
            color: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: AssetsPage(),
      ),
    );
  }
}
