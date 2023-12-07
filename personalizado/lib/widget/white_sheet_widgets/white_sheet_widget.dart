
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:personalizado/models/pokemon_basic_data.dart';
import 'package:personalizado/widget/white_sheet_widgets/evolution_widget.dart';
import 'package:personalizado/widget/white_sheet_widgets/stats_row_widget.dart';
import '../../services/http_calls.dart';
import 'about_widget.dart';
import 'more_info_widget.dart';
import 'moves_widget.dart';

class WhiteSheetWidget extends StatefulWidget {
  final PokemonBasicData pokemon;

  const WhiteSheetWidget({super.key, required this.pokemon});

  @override
  State<WhiteSheetWidget> createState() => _WhiteSheetWidgetState();
}

class _WhiteSheetWidgetState extends State<WhiteSheetWidget> {
  final httpCalls = HttpCalls();
  final _tabController = PageController();
  int _currentTabIndex = 0;
  bool loading = false;
  final List<String> _tabs = [
    'About',
    'Stats',
    'Moves',
    'More Info',
    'Evolution'
  ];

  Future<void> _fetchData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    final pokemon = widget.pokemon;
    // fetch pokemon more info data
    await httpCalls.fetchPokemonMoreIndoData(pokemon);
    if (!mounted) return;
    // fetch pokemon about data
    await httpCalls.getPokemonAboutData(pokemon);
    if (!mounted) return;
    // fetch pokemon evolution data
    await httpCalls.getPokemonEvolutionData(pokemon);
    if (!mounted) return;
    // fetch pokemon stats data
    await httpCalls.fetchPokemonStats(pokemon);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    // get screen height and width
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    if (!loading) {
      return ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(getBackgroundImage(
                      widget.pokemon.pokemonMoreInfoData!.types != null
                          ? widget.pokemon.pokemonMoreInfoData!.types!.first
                          : "default")),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Ajusta el valor de opacidad según tus necesidades
                    BlendMode.darken,
                  ),),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      ' ${widget.pokemon.id}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.pokemon.name[0].toUpperCase() + widget.pokemon.name.substring(1)} ',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl:
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            value: downloadProgress.progress,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.black)),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl:
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemon.id}.png",
                      progressIndicatorBuilder: (context, url,
                          downloadProgress) =>
                          CircularProgressIndicator(
                              value: downloadProgress.progress,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.black)),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl:
                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png",
                        progressIndicatorBuilder: (context, url,
                            downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.black)),
                        errorWidget: (context, url, error) => const Text(""),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.6,
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.010,
                ),
                SizedBox(
                    height: screenHeight * .06,
                    child: Center(child: customScrollerBuilder())),
                // display circular indicator when loading
                if (loading)
                  const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.black)),
                  ),
                // display the pageView when finish loading
                if (!loading)
                  Expanded(
                    child: PageView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (int index) {
                        setState(() {
                          // update the tab index
                          _currentTabIndex = index;
                        });
                      },
                      children: [
                        AboutWidget(pokemon: pokemon),
                        StatsWidget(pokemon: pokemon),
                        MovesWidget(pokemon: pokemon),
                        MoreInfoWidget(pokemon: pokemon),
                        EvolutionWidget(pokemon: pokemon)
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(
          child: CircularProgressIndicator(color: Colors.black));
    }
  }

  Widget customScrollerBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ..._tabs.map((tab) {
          int tabIndex = _tabs.indexOf(tab);
          return Expanded(child: tabBuilder(tabIndex, _tabs));
        }),
      ],
    );
  }

  Widget tabBuilder(int tabIndex, List<String> scrollTabs) {
    return GestureDetector(
      onTap: () {
        updateTabIndex(tabIndex);
      },
      child: Column(
        children: [
          Text(scrollTabs[tabIndex],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _currentTabIndex == tabIndex
                      ? (Colors.black)
                      : Colors.grey)),
          if (tabIndex == _currentTabIndex)
            Container(
              width: scrollTabs[tabIndex].length * 10,
              height: 2,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  void updateTabIndex(int tabIndex) {
    if (!loading) {
      setState(() {
        _currentTabIndex = tabIndex;
        // add animation
        _tabController.animateToPage(tabIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }

  String getBackgroundImage(String type) {
    switch (type.toLowerCase()) {
      case "normal":
        return "lib/images/normal.png";
      case "fighting":
        return "lib/images/fighting.png";
      case "flying":
        return "lib/images/flying.png";
      case "poison":
        return "lib/images/poison.png";
      case "ground":
        return "lib/images/ground.png";
      case "rock":
        return "lib/images/rock.png";
      case "bug":
        return "lib/images/bug.png";
      case "ghost":
        return "lib/images/ghost.png";
      case "steel":
        return "lib/images/steel.png";
      case "fire":
        return "lib/images/fire.png";
      case "water":
        return "lib/images/water.png";
      case "grass":
        return "lib/images/grass.png";
      case "electric":
        return "lib/images/electric1.png";
      case "psychic":
        return "lib/images/psychic.png";
      case "ice":
        return "lib/images/ice.png";
      case "dragon":
        return "lib/images/dragon.png";
      case "dark":
        return "lib/images/dark.png";
      case "fairy":
        return "lib/images/fairy.png";
      case "unknown":
        return "lib/images/unknown.png";
      case "shadow":
        return "lib/images/shadow.png";
      default:
        return "lib/images/default.png";
    }
  }
}
