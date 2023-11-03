import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'pokemon_data.g.dart';

PokemonsData pokemonsDataFromJson(String str) => PokemonsData.fromJson(jsonDecode(str));
Pokemon pokemonFromJson(String str) => Pokemon.fromJson(jsonDecode(str));
PokemonsType pokemonsTypeFromJson(String str) => PokemonsType.fromJson(jsonDecode(str));

@JsonSerializable()
class PokemonsType {
  List<PokemonElement> pokemon;

  PokemonsType({
    required this.pokemon,
  });

  factory PokemonsType.fromJson(Map<String,dynamic> data) => _$PokemonsTypeFromJson(data);

  Map<String,dynamic> toJson() => _$PokemonsTypeToJson(this);
}

@JsonSerializable()
class PokemonElement {
  Result pokemon;
  int slot;

  PokemonElement({
    required this.pokemon,
    required this.slot,
  });

  factory PokemonElement.fromJson(Map<String,dynamic> data) => _$PokemonElementFromJson(data);

  Map<String,dynamic> toJson() => _$PokemonElementToJson(this);
}

@JsonSerializable()
class PokemonsData {
  dynamic count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  PokemonsData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonsData.fromJson(Map<String,dynamic> data) => _$PokemonsDataFromJson(data);

  Map<String,dynamic> toJson() => _$PokemonsDataToJson(this);
}

@JsonSerializable()
class Result {
  String name;
  String url;

  Result({
    required this.name,
    required this.url,
  });

  factory Result.fromJson(Map<String,dynamic> data) => _$ResultFromJson(data);

  Map<String,dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Pokemon {
  List<Ability>? abilities;
  dynamic baseExperience;
  List<Result>? forms;
  List<dynamic>? gameIndices;
  dynamic height;
  List<dynamic>? heldItems;
  dynamic id;
  dynamic isDefault;
  dynamic locationAreaEncounters;
  List<dynamic>? moves;
  dynamic name;
  dynamic order;
  List<dynamic>? pastAbilities;
  List<dynamic>? pastTypes;
  Result species;
  Sprites sprites;
  List<Stat>? stats;
  List<Type>? types;
  dynamic weight;

  Pokemon({
    required this.abilities,
    required this.baseExperience,
    required this.forms,
    required this.gameIndices,
    required this.height,
    required this.heldItems,
    required this.id,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.moves,
    required this.name,
    required this.order,
    required this.pastAbilities,
    required this.pastTypes,
    required this.species,
    required this.sprites,
    required this.stats,
    required this.types,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String,dynamic> data) => _$PokemonFromJson(data);

  Map<String,dynamic> toJson() => _$PokemonToJson(this);
}

@JsonSerializable()
class Ability {
  Result? ability;
  dynamic isHidden;
  dynamic slot;

  Ability({
    required this.ability,
    required this.isHidden,
    required this.slot,
  });

  factory Ability.fromJson(Map<String,dynamic> data) => _$AbilityFromJson(data);

  Map<String,dynamic> toJson() => _$AbilityToJson(this);
}

@JsonSerializable()
class GenerationV {
  Sprites? blackWhite;

  GenerationV({
    required this.blackWhite,
  });

  factory GenerationV.fromJson(Map<String,dynamic> data) => _$GenerationVFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationVToJson(this);
}

@JsonSerializable()
class GenerationIv {
  Sprites? diamondPearl;
  Sprites? heartgoldSoulsilver;
  Sprites? platinum;

  GenerationIv({
    required this.diamondPearl,
    required this.heartgoldSoulsilver,
    required this.platinum,
  });

  factory GenerationIv.fromJson(Map<String,dynamic> data) => _$GenerationIvFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationIvToJson(this);

}

@JsonSerializable()
class Versions {
  GenerationI? generationI;
  GenerationIi? generationIi;
  GenerationIii? generationIii;
  GenerationIv? generationIv;
  GenerationV? generationV;
  Map<String, Home>? generationVi;
  GenerationVii? generationVii;
  GenerationViii? generationViii;

  Versions({
    required this.generationI,
    required this.generationIi,
    required this.generationIii,
    required this.generationIv,
    required this.generationV,
    required this.generationVi,
    required this.generationVii,
    required this.generationViii,
  });

  factory Versions.fromJson(Map<String,dynamic> data) => _$VersionsFromJson(data);

  Map<String,dynamic> toJson() => _$VersionsToJson(this);

}

@JsonSerializable()
class Sprites {
  dynamic backDefault;
  dynamic backFemale;
  dynamic backShiny;
  dynamic backShinyFemale;
  dynamic frontDefault;
  dynamic frontFemale;
  dynamic frontShiny;
  dynamic frontShinyFemale;
  Other? other;
  Versions? versions;
  Sprites? animated;

  Sprites({
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
    this.other,
    this.versions,
    this.animated,
  });

  factory Sprites.fromJson(Map<String,dynamic> data) => _$SpritesFromJson(data);

  Map<String,dynamic> toJson() => _$SpritesToJson(this);

}

@JsonSerializable()
class GenerationI {
  RedBlue? redBlue;
  RedBlue? yellow;

  GenerationI({
    required this.redBlue,
    required this.yellow,
  });

  factory GenerationI.fromJson(Map<String,dynamic> data) => _$GenerationIFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationIToJson(this);

}

@JsonSerializable()
class RedBlue {
  dynamic backDefault;
  dynamic backGray;
  dynamic backTransparent;
  dynamic frontDefault;
  dynamic frontGray;
  dynamic frontTransparent;

  RedBlue({
    required this.backDefault,
    required this.backGray,
    required this.backTransparent,
    required this.frontDefault,
    required this.frontGray,
    required this.frontTransparent,
  });

  factory RedBlue.fromJson(Map<String,dynamic> data) => _$RedBlueFromJson(data);

  Map<String,dynamic> toJson() => _$RedBlueToJson(this);
}

@JsonSerializable()
class GenerationIi {
  Crystal? crystal;
  Gold? gold;
  Gold? silver;

  GenerationIi({
    required this.crystal,
    required this.gold,
    required this.silver,
  });

  factory GenerationIi.fromJson(Map<String,dynamic> data) => _$GenerationIiFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationIiToJson(this);

}

@JsonSerializable()
class Crystal {
  dynamic backDefault;
  dynamic backShiny;
  dynamic backShinyTransparent;
  dynamic backTransparent;
  dynamic frontDefault;
  dynamic frontShiny;
  dynamic frontShinyTransparent;
  dynamic frontTransparent;

  Crystal({
    required this.backDefault,
    required this.backShiny,
    required this.backShinyTransparent,
    required this.backTransparent,
    required this.frontDefault,
    required this.frontShiny,
    required this.frontShinyTransparent,
    required this.frontTransparent,
  });

  factory Crystal.fromJson(Map<String,dynamic> data) => _$CrystalFromJson(data);

  Map<String,dynamic> toJson() => _$CrystalToJson(this);

}

@JsonSerializable()
class Gold {
  dynamic backDefault;
  dynamic backShiny;
  dynamic frontDefault;
  dynamic frontShiny;
  dynamic frontTransparent;

  Gold({
    required this.backDefault,
    required this.backShiny,
    required this.frontDefault,
    required this.frontShiny,
    this.frontTransparent,
  });

  factory Gold.fromJson(Map<String,dynamic> data) => _$GoldFromJson(data);

  Map<String,dynamic> toJson() => _$GoldToJson(this);

}

@JsonSerializable()
class GenerationIii {
  OfficialArtwork? emerald;
  Gold? fireredLeafgreen;
  Gold? rubySapphire;

  GenerationIii({
    required this.emerald,
    required this.fireredLeafgreen,
    required this.rubySapphire,
  });

  factory GenerationIii.fromJson(Map<String,dynamic> data) => _$GenerationIiiFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationIiiToJson(this);

}

@JsonSerializable()
class OfficialArtwork {
  dynamic frontDefault;
  dynamic frontShiny;

  OfficialArtwork({
    required this.frontDefault,
    required this.frontShiny,
  });

  factory OfficialArtwork.fromJson(Map<String,dynamic> data) => _$OfficialArtworkFromJson(data);

  Map<String,dynamic> toJson() => _$OfficialArtworkToJson(this);

}

@JsonSerializable()
class Home {
  dynamic frontDefault;
  dynamic frontFemale;
  dynamic frontShiny;
  dynamic frontShinyFemale;

  Home({
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
  });

  factory Home.fromJson(Map<String,dynamic> data) => _$HomeFromJson(data);

  Map<String,dynamic> toJson() => _$HomeToJson(this);

}

@JsonSerializable()
class GenerationVii {
  DreamWorld? icons;
  Home? ultraSunUltraMoon;

  GenerationVii({
    required this.icons,
    required this.ultraSunUltraMoon,
  });

  factory GenerationVii.fromJson(Map<String,dynamic> data) => _$GenerationViiFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationViiToJson(this);

}

@JsonSerializable()
class DreamWorld {
  dynamic frontDefault;
  dynamic frontFemale;

  DreamWorld({
    required this.frontDefault,
    required this.frontFemale,
  });

  factory DreamWorld.fromJson(Map<String,dynamic> data) => _$DreamWorldFromJson(data);

  Map<String,dynamic> toJson() => _$DreamWorldToJson(this);

}

@JsonSerializable()
class GenerationViii {
  DreamWorld? icons;

  GenerationViii({
    required this.icons,
  });

  factory GenerationViii.fromJson(Map<String,dynamic> data) => _$GenerationViiiFromJson(data);

  Map<String,dynamic> toJson() => _$GenerationViiiToJson(this);

}

@JsonSerializable()
class Other {
  DreamWorld? dreamWorld;
  Home? home;
  OfficialArtwork? officialArtwork;

  Other({
    required this.dreamWorld,
    required this.home,
    required this.officialArtwork,
  });

  factory Other.fromJson(Map<String,dynamic> data) => _$OtherFromJson(data);

  Map<String,dynamic> toJson() => _$OtherToJson(this);

}

@JsonSerializable()
class Stat {
  dynamic baseStat;
  dynamic effort;
  Result? stat;

  Stat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory Stat.fromJson(Map<String,dynamic> data) => _$StatFromJson(data);

  Map<String,dynamic> toJson() => _$StatToJson(this);

}

@JsonSerializable()
class Type {
  dynamic slot;
  Result? type;

  Type({
    required this.slot,
    required this.type,
  });

  factory Type.fromJson(Map<String,dynamic> data) => _$TypeFromJson(data);

  Map<String,dynamic> toJson() => _$TypeToJson(this);

}
