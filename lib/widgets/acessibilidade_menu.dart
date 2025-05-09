import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class AcessibilidadeMenu extends StatelessWidget {
  const AcessibilidadeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Alternar Tema',
          icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }
}
