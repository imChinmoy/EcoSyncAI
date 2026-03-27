/// Shared dark map style (matches citizen [MapPlaceholder]).
const String kDarkBlueMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0f1724"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8fa5c4"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#0b1220"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#2b3a50"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#6f86a5"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1a2740"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#111c30"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#88a1c0"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#1a2a44"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0a2238"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#5f83ad"}]}
]
''';
