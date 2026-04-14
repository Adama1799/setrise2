// lib/presentation/screens/main/widgets/filter_state.dart

const Map<String, List<String>> kRegions = {
  '🔥 Trending': ['🇩🇿 Algeria','🇺🇸 USA','🇧🇷 Brazil','🇯🇵 Japan','🇫🇷 France','🇸🇦 Saudi Arabia'],
  '🌍 Africa': ['🇩🇿 Algeria','🇹🇳 Tunisia','🇪🇬 Egypt','🇲🇦 Morocco','🇳🇬 Nigeria','🇰🇪 Kenya','🇿🇦 South Africa','🇬🇭 Ghana','🇸🇳 Senegal','🇪🇹 Ethiopia','🇹🇿 Tanzania','🇺🇬 Uganda','🇨🇲 Cameroon','🇨🇮 Ivory Coast','🇱🇾 Libya','🇸🇩 Sudan','🇲🇿 Mozambique','🇦🇴 Angola'],
  '🇪🇺 Europe': ['🇫🇷 France','🇩🇪 Germany','🇬🇧 UK','🇮🇹 Italy','🇪🇸 Spain','🇳🇱 Netherlands','🇵🇹 Portugal','🇷🇺 Russia','🇧🇪 Belgium','🇨🇭 Switzerland','🇸🇪 Sweden','🇳🇴 Norway','🇩🇰 Denmark','🇵🇱 Poland','🇺🇦 Ukraine','🇬🇷 Greece','🇦🇹 Austria','🇨🇿 Czech Republic','🇷🇴 Romania','🇭🇺 Hungary','🇫🇮 Finland'],
  '🌎 Americas': ['🇺🇸 USA','🇧🇷 Brazil','🇲🇽 Mexico','🇨🇦 Canada','🇦🇷 Argentina','🇨🇴 Colombia','🇨🇱 Chile','🇵🇪 Peru','🇻🇪 Venezuela','🇨🇺 Cuba','🇩🇴 Dominican Republic','🇵🇦 Panama','🇪🇨 Ecuador','🇧🇴 Bolivia','🇺🇾 Uruguay','🇵🇾 Paraguay','🇬🇹 Guatemala','🇭🇳 Honduras'],
  '🌏 Asia': ['🇸🇦 Saudi Arabia','🇦🇪 UAE','🇯🇵 Japan','🇰🇷 South Korea','🇨🇳 China','🇮🇳 India','🇹🇷 Turkey','🇮🇩 Indonesia','🇵🇰 Pakistan','🇧🇩 Bangladesh','🇹🇭 Thailand','🇻🇳 Vietnam','🇲🇾 Malaysia','🇵🇭 Philippines','🇮🇶 Iraq','🇸🇾 Syria','🇱🇧 Lebanon','🇯🇴 Jordan','🇮🇷 Iran','🇰🇼 Kuwait','🇶🇦 Qatar','🇧🇭 Bahrain','🇴🇲 Oman','🇾🇪 Yemen','🇦🇫 Afghanistan','🇰🇿 Kazakhstan','🇺🇿 Uzbekistan'],
  '🌊 Oceania': ['🇦🇺 Australia','🇳🇿 New Zealand','🇫🇯 Fiji','🇵🇬 Papua New Guinea','🇸🇧 Solomon Islands','🇼🇸 Samoa'],
};

const List<String> kCategories = ['💻 Technology','🏛️ Politics','🎬 Movies','🎵 Music','📖 Stories','💰 Business','🎓 Education','😂 Comedy','🍳 Cooking','🎭 Adventure','❤️ Dating','🛍️ Shop','🔴 Live','🌿 Nature','✈️ Travel','🎨 Art'];
const List<String> kSports     = ['⚽ Football','🏀 Basketball','🎾 Tennis','🏋️ Fitness','🥊 Boxing','🏊 Swimming','🏃 Running','🚴 Cycling','🎯 E-Sports','🏈 American Football','🏐 Volleyball','⚾ Baseball','🏒 Hockey','🎱 Billiards','🥋 Martial Arts'];
const List<String> kMoods      = ['😴 Chill','😤 Hyped','😞 Sad','🧘 Focus','💪 Motivated'];

class FilterState {
  static String? mood, category, sport, region, country;
  static void reset() => mood = category = sport = region = country = null;
}
