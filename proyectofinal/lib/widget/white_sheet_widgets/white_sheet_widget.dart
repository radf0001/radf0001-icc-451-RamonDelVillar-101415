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

  const WhiteSheetWidget({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<WhiteSheetWidget> createState() => _WhiteSheetWidgetState();
}

class _WhiteSheetWidgetState extends State<WhiteSheetWidget> {
  final httpCalls = HttpCalls();
  final _tabController = PageController();
  int _currentTabIndex = 0;
  bool loading = false;
  final List<String> _tabs = ['About', 'Stats', 'Moves', 'More Info', 'Evolution'];

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
    return SizedBox(
      height: screenHeight * 0.6,
      width: screenWidth,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.010,
          ),
          SizedBox(
              height: screenHeight * .06,
              child: Center(child: customScrollerBuilder())
          ),
          // display circular indicator when loading
          if (loading)
            const Expanded(
              child: Center(
                  child: CircularProgressIndicator(
                      color: Colors.white)
              ),
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
    );
  }


  Widget customScrollerBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ..._tabs.map((tab) {
          int tabIndex = _tabs.indexOf(tab);
          return Expanded(child: tabBuilder(tabIndex, _tabs));
        }).toList(),
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
                      ? (Colors.white)
                      : Colors.grey)),
          if (tabIndex == _currentTabIndex)
            Container(
              width: scrollTabs[tabIndex].length * 10,
              height: 2,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  void updateTabIndex(int tabIndex) {
    if(!loading){
      setState(() {
        _currentTabIndex = tabIndex;
        // add animation
        _tabController.animateToPage(tabIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }
}


