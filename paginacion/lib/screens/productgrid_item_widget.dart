import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:paginacion/core/app_export.dart';
import 'DetallePokemon.dart';

class ProductgridItemWidget extends StatelessWidget {
  final String pokemonName;
  final String pokemonImageUrl;
  final int pokemonNumber;

  const ProductgridItemWidget({
    Key? key,
    required this.pokemonName,
    required this.pokemonImageUrl,
    required this.pokemonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context) to get the current theme if necessary.
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetallePokemon(pokemonNumber: pokemonNumber),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath:
                      ImageConstant.imgGroup95, // Imagen de fondo (pokebola)
                  height: 60.v,
                  width: SizeExtension(60).h,
                  fit: BoxFit.cover,
                ),
                CustomImageView(
                  imagePath: pokemonImageUrl, // Imagen del Pokémon
                  height: 50.v,
                  width: SizeExtension(50).h,
                ),
              ],
            ),
            Text(
              pokemonName,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14,
              ),
            ),
            Text(
              "#${pokemonNumber.toString().padLeft(3, '0')}",
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
