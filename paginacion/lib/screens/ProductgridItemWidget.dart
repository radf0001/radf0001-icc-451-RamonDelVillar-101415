import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paginacion/model/pokemon_data.dart';
import 'DetallePokemon.dart';
// ignore: unused_import
import 'package:paginacion/main.dart';

class ProductgridItemWidget extends StatelessWidget {
  final String pokemonName;
  final int pokemonNumber;
  final Future<Pokemon> Function(int pokemonNumber) getDetailsAndNavigate;

  const ProductgridItemWidget({
    Key? key,
    required this.pokemonName,
    required this.pokemonNumber,
    required this.getDetailsAndNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Define las URLs de las imágenes para el fallback
    final List<String> imageUrls = [
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonNumber.png",
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$pokemonNumber.png",
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png",
    ];

    return InkWell(
      onTap: () async {
        final pokemonDetails = await getDetailsAndNavigate(pokemonNumber);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetallePokemon(
              pokemonNumber: pokemonNumber.toString(),
              pokemonName: pokemonName,
              pokemonDetails: pokemonDetails,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "lib/images/img_group_95.svg",
                  height: 80.h,
                  width: 80.w,
                  fit: BoxFit.contain,
                ),
                FastCachedImage(
                  url: imageUrls.first,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(seconds: 0),
                  errorBuilder: (context, exception, stackTrace) {
                    // Si la primera URL falla, intenta con la siguiente
                    return FastCachedImage(
                      url: imageUrls[1],
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 0),
                      errorBuilder: (context, exception, stackTrace) {
                        // Si la segunda URL falla, intenta con la última
                        return FastCachedImage(
                          url: imageUrls.last,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(seconds: 0),
                          errorBuilder: (context, exception, stackTrace) {
                            // Si todas las URLs fallan, muestra un placeholder
                            return Text("");
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Text(
              pokemonName,
              style: theme.textTheme.labelLarge?.copyWith(fontSize: 14.sp),
            ),
            Text(
              "#${pokemonNumber.toString().padLeft(3, '0')}",
              style: theme.textTheme.labelLarge?.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
