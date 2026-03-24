class AppConstants {
  // Wards
  static const List<String> wards = [
    'All Wards',
    'Ward 1',
    'Ward 2',
    'Ward 3',
    'Ward 4',
    'Ward 5',
    'Ward 6',
  ];

  // Categories
  static const List<String> categories = [
    'All',
    'Mixed Waste',
    'Recyclable',
    'Organic Waste',
    'Plastic',
    'Hazardous',
    'E-Waste',
  ];

  // Statuses
  static const List<String> statuses = [
    'All',
    'Empty',
    'Filling',
    'Full',
  ];

  // AI classification labels (mock)
  static const List<String> aiLabels = [
    'Classified as: Plastic',
    'Classified as: Organic',
    'Classified as: Recyclable',
    'Classified as: Mixed Waste',
    'Classified as: Hazardous',
    'Classified as: E-Waste',
  ];

  // Dummy addresses per ward
  static const Map<int, List<String>> wardAddresses = {
    1: [
      'Green Park Avenue, Sector 12',
      'Main Street Plaza, Block A',
      'Community Garden, Lane 4',
    ],
    2: [
      'MG Road, Near Bus Stop',
      'Old Market Square, Gate 2',
      'Nehru Nagar, Phase 3',
    ],
    3: [
      'Rajiv Gandhi Colony, Plot 8',
      'Laxmi Bai Chowk, Near Park',
      'Sadashiv Peth, Near Temple',
    ],
    4: [
      'Shivaji Nagar, Lane 7',
      'Tilak Road, Corner Shop',
      'Gandhi Bazaar, Near School',
    ],
  };
}
