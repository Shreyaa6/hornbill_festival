import 'package:flutter/material.dart';
import 'nagaland_data.dart';

class TouristMapDestination {
  final String id;
  final String name;
  final String district;
  final String category;
  final String address;
  final double lat;
  final double lng;
  final String description;
  final String imageAsset;
  final String? imageUrl;
  final String? mapUrl;
  final String? timing;
  final List<String> tags;
  final Color pinColor;

  const TouristMapDestination({
    required this.id,
    required this.name,
    required this.district,
    required this.category,
    required this.address,
    required this.lat,
    required this.lng,
    required this.description,
    required this.imageAsset,
    this.imageUrl,
    this.mapUrl,
    this.timing,
    required this.tags,
    required this.pinColor,
  });

  String get latDms {
    final deg = lat.toStringAsFixed(6);
    return "$deg° N";
  }

  String get lngDms {
    final deg = lng.toStringAsFixed(6);
    return "$deg° E";
  }
}

class TouristMapData {
  static const List<TouristMapDestination> destinations = [
    // ----------------- DIMAPUR (4) -----------------
    TouristMapDestination(
      id: 'green_park',
      name: 'Green Park',
      district: 'Dimapur',
      category: 'Parks & Recreation',
      address: 'Green Park, 5th Mile, Dimapur, Nagaland 797115',
      lat: 25.860613,
      lng: 93.762070,
      description:
          'Green Park Dimapur is a fantastic recreational destination located just 5 km from the main city. The park offers a variety of exciting activities, including zip lining, rock climbing, a shooting range, boating, and an ATV track. Whether you\'re seeking adventure or a relaxing day outdoors, Green Park provides something for everyone to enjoy in a beautiful natural setting.',
      imageAsset: 'assets/images/spots/dimapur_green_park.jpg',
      tags: ['Recreation Park', 'Boating & Lake', 'Zip Lining', 'Rock Climbing'],
      pinColor: Color(0xFF0D9488),
    ),
    TouristMapDestination(
      id: 'nezcc',
      name: 'North East Zone Cultural Centre (NEZCC)',
      district: 'Dimapur',
      category: 'Culture & Museum',
      address: 'NEZCC Complex, Dimapur, Nagaland 797112',
      lat: 25.875833,
      lng: 93.774444,
      description:
          'The Cultural heritage of India\'s northeast is preserved here in the form of a museum. Visit the Museum and take a stroll at the Stone garden nearby.',
      imageAsset: 'assets/images/spots/dimapur_nezcc.jpg',
      tags: ['Northeast Heritage Museum', 'Stone Garden', 'Cultural Artifacts', 'Tribal Exhibits'],
      pinColor: Color(0xFF0284C7),
    ),
    TouristMapDestination(
      id: 'kachari_ruins',
      name: 'Kachari Ruins',
      district: 'Dimapur',
      category: 'Heritage & History',
      address: 'Rajbari Park, Walford Road, Dimapur, Nagaland 797112',
      lat: 25.903762,
      lng: 93.739653,
      description:
          'Nestled within the vibrant town of Dimapur, the Kachari ruins are believed to date back to the 10th century and serves as a testament to the once-thriving Kachari civilization. This site features a series of mushroom-domed pillars, showcasing the unique architectural style of the time.',
      imageAsset: 'assets/images/spots/dimapur_kachari.jpg',
      tags: ['10th Century Civilization', 'Mushroom Pillars', 'Ancient Kingdom', 'Rajbari Park'],
      pinColor: Color(0xFF8B5CF6),
    ),
    TouristMapDestination(
      id: 'heirloom_naga',
      name: 'Heirloom Naga Centre',
      district: 'Dimapur',
      category: 'Culture & Handloom',
      address: 'Sovima Village, Dimapur, Nagaland 797112',
      lat: 25.848437,
      lng: 93.732062,
      description:
          'The Heirloom Naga Centre is a dynamic hub dedicated to nurturing and revitalizing Naga cultural traditions. Its gallery celebrates Naga culture through traditional practices and exquisite craftsmanship. Each piece tells a story, reflecting the unique heritage of diverse Naga tribes, showcasing intricately woven textiles and beautifully carved woodwork made from indigenous materials and distinctive patterns passed down through generations.',
      imageAsset: 'assets/images/spots/dimapur_weaving.jpg',
      tags: ['Traditional Weaving', 'Indigenous Textiles', 'Woodwork', 'Craft Traditions'],
      pinColor: Color(0xFFE11D48),
    ),

    // ----------------- CHÜMOUKEDIMA (4) -----------------
    TouristMapDestination(
      id: 'diezephe',
      name: 'Diezephe Craft Village',
      district: 'Chümoukedima',
      category: 'Art & Craft Village',
      address: 'Diezephe Village, Chümoukedima, Nagaland 797115',
      lat: 25.845000,
      lng: 93.745000,
      description:
          'Supported by the Nagaland Handloom and Handicrafts Development Corporation Limited, the village has become a significant player in craft exports to other states. Diezephe Craft Village is celebrated for its exceptional craftsmanship, including woodcarving, bamboo and cane work, and various handloom products.',
      imageAsset: 'assets/images/spots/chumoukedima_craft.jpg',
      tags: ['Woodcarving & Cane Work', 'Handloom & Handicrafts', 'Artisans', 'Export Craft'],
      pinColor: Color(0xFFD97706),
    ),
    TouristMapDestination(
      id: 'merryland_park',
      name: 'Merryland Park',
      district: 'Chümoukedima',
      category: 'Theme Park & Recreation',
      address: 'Padum Pukhuri, Chümoukedima, Nagaland 797103',
      lat: 25.808952,
      lng: 93.755347,
      description:
          'The first water park in Nagaland, Merry Land Park, offers variety of attractions like Kids play with Hobbit, Carousel, Gaming arcade, Rental block, Changing room, Morung, Rock garden, Food court, Skating rink, Paddle pool, Bumper cars, Niagara falls, Funnel slide, Wave pool, Rain dance and Photo booth.',
      imageAsset: 'assets/images/spots/chumoukedima_merryland.jpg',
      tags: ['First Water Park in Nagaland', 'Water Slides & Pools', 'Amusement Rides', 'Rock Garden'],
      pinColor: Color(0xFF0284C7),
    ),
    TouristMapDestination(
      id: 'nagaland_zoo',
      name: 'Nagaland Zoological Park',
      district: 'Chümoukedima',
      category: 'Nature & Wildlife',
      address: 'Nagaland Zoological Park, Chümoukedima, Nagaland 797103',
      lat: 25.853069,
      lng: 93.721541,
      description:
          'Located in Chümoukedima district, Nagaland Zoological Park spans about 176 hectares and officially opened in August 2008. It highlights the region\'s commitment to wildlife conservation and biodiversity, showcasing a diverse range of animal species. Beyond wildlife observation, the park focuses on nature education and conservation, promoting awareness and appreciation for the environment.',
      imageAsset: 'assets/images/spots/chumoukedima_zoo.jpg',
      tags: ['Wildlife Sanctuary', 'Fauna Conservation', 'Biodiversity', 'Nature Education'],
      pinColor: Color(0xFF059669),
    ),
    TouristMapDestination(
      id: 'triple_falls',
      name: 'Triple Falls',
      district: 'Chümoukedima',
      category: 'Nature & Waterfalls',
      address: 'Seithekima Village, Chümoukedima, Nagaland 797103',
      lat: 25.795000,
      lng: 93.811500,
      description:
          'Situated in Seithekima Village, Chümoukedima, the stunning Triple Falls showcases three beautiful streams plunging 280 feet into a natural pool, offering a spectacular sight. These enchanting waterfalls are ideal not only for sightseeing but also for trekking adventures.',
      imageAsset: 'assets/images/spots/chumoukedima_triple_falls.jpg',
      tags: ['Three Cascade Streams', 'Trekking Adventures', '280ft Waterfall', 'Natural Pools'],
      pinColor: Color(0xFF2563EB),
    ),

    // ----------------- KOHIMA (10) -----------------
    TouristMapDestination(
      id: 'kohima_war_cemetery',
      name: 'Kohima War Cemetery',
      district: 'Kohima',
      category: 'Heritage & History',
      address: 'Midland Colony, Kohima, Nagaland 797001',
      lat: 25.666900,
      lng: 94.103700,
      description:
          'The Kohima War Cemetery in Nagaland, India, is a solemn memorial dedicated to soldiers who fought in World War II during the decisive Battle of Kohima in 1944. The cemetery is particularly moving for its dedication plaque with the famous words: "When You Go Home, Tell Them Of Us And Say, For Your Tomorrow, We Gave Our Today."',
      imageAsset: 'assets/images/spots/kohima_cemetery.jpg',
      tags: ['WWII Memorial', 'Battle of Kohima', 'Commonwealth Graves', 'Historic Landmark'],
      pinColor: Color(0xFFE11D48),
    ),
    TouristMapDestination(
      id: 'kohima_cathedral',
      name: 'Mary Help of Christians Cathedral',
      district: 'Kohima',
      category: 'Religious & Landmarks',
      address: 'Aradurah Hill, Kohima, Nagaland 797005',
      lat: 25.658200,
      lng: 94.113000,
      description:
          'Mary Help of Christians Cathedral, standing tall with its unique semi-circular architecture, serves as a prominent landmark in Kohima. Built during the British colonial era, its vibrant design and peaceful ambiance make it an architectural and historical marvel of the region.',
      imageAsset: 'assets/images/spots/kohima_cathedral.jpg',
      tags: ['Landmark Cathedral', 'Semi-Circular Architecture', 'Spiritual Center', 'Scenic Hilltop'],
      pinColor: Color(0xFF7C3AED),
    ),
    TouristMapDestination(
      id: 'state_museum',
      name: 'Nagaland State Museum',
      district: 'Kohima',
      category: 'Culture & Museum',
      address: 'Bayavü Hill, Kohima, Nagaland 797001',
      lat: 25.679100,
      lng: 94.106500,
      description:
          'The Nagaland State Museum is a treasure trove of artefacts, representing Nagaland\'s rich history. Its collection showcases artifacts from the traditional life of the Naga tribes. Visitors receive an insightful look into the lifestyle, customs, art, and traditions of Nagaland.',
      imageAsset: 'assets/images/spots/kohima_museum.jpg',
      tags: ['Tribal Artifacts', 'Musical Instruments', 'Morung Replicas', 'Naga History'],
      pinColor: Color(0xFF0284C7),
    ),
    TouristMapDestination(
      id: 'kisama_village',
      name: 'Kisama Heritage Village',
      district: 'Kohima',
      category: 'Culture & Villages',
      address: 'NH 2, Kisama, Kohima, Nagaland 797005',
      lat: 25.618600,
      lng: 94.116700,
      description:
          'Kisama Heritage Village is located on the scenic slopes between Kigwema and Phesama villages. Established to protect and highlight the vibrant cultural legacy of the Naga tribes, it serves as a living museum where all the recognized 17 major tribes have traditional morungs built to celebrate the annual Hornbill Festival.',
      imageAsset: 'assets/images/spots/kohima_kisama.jpg',
      tags: ['Hornbill Festival Venue', '17 Tribal Morungs', 'Living Heritage Museum', 'Cultural Amphitheatre'],
      pinColor: Color(0xFFD97706),
    ),
    TouristMapDestination(
      id: 'puliebadze',
      name: 'Puliebadze Wildlife Sanctuary',
      district: 'Kohima',
      category: 'Nature & Wildlife',
      address: 'Jotsoma, Kohima, Nagaland 797002',
      lat: 25.636000,
      lng: 94.072000,
      description:
          'Puliebadze Wildlife Sanctuary in Kohima district covers 9.23 square km. It is a vital catchment area for Kohima town. The sanctuary includes scenic forest and hiking trails, and is home to species like tragopan, barking deer, and common leopard.',
      imageAsset: 'assets/images/spots/kohima_puliebadze.jpg',
      tags: ['Forest Sanctuary', 'Trekking Ridge', 'Tragopan Habitat', 'Catchment Area'],
      pinColor: Color(0xFF059669),
    ),
    TouristMapDestination(
      id: 'dzukou_valley',
      name: 'Dzukou Valley',
      district: 'Kohima',
      category: 'Nature & Treks',
      address: 'Viswema / Jakhama Trek Base, Kohima, Nagaland 797005',
      lat: 25.553900,
      lng: 94.075300,
      description:
          'Located at an elevation of 2,452 meters above sea level, Dzukou Valley sits on the border between Nagaland and Manipur. Celebrated for its rolling bamboo hillocks, serpentine stream, pristine flora, and serene valleys. Often referred to as the \'Valley of Flowers of the North East\'.',
      imageAsset: 'assets/images/spots/kohima_dzukou.jpg',
      tags: ['Valley of Flowers', 'Rolling Bamboo Hills', 'Trekking Paradise', 'Serpentine Streams'],
      pinColor: Color(0xFF0D9488),
    ),
    TouristMapDestination(
      id: 'mount_japfu',
      name: 'Mount Japfu',
      district: 'Kohima',
      category: 'Mountain Peaks',
      address: 'Kigwema, Kohima, Nagaland 797005',
      lat: 25.580000,
      lng: 94.090000,
      description:
          'Japfu Peak is the second highest peak in Nagaland, standing at an elevation of 3,048 metres. It is renowned for its lush vegetation, including the tallest rhododendron tree in the world (listed in the Guinness Book of Records at 109 feet tall).',
      imageAsset: 'assets/images/spots/kohima_japfu.jpg',
      tags: ['3048m Peak', 'Guinness Rhododendron', 'Panoramic Views', 'Alpine Trek'],
      pinColor: Color(0xFFEA580C),
    ),
    TouristMapDestination(
      id: 'khonoma_village',
      name: 'Khonoma Green Village',
      district: 'Kohima',
      category: 'Culture & Villages',
      address: 'Khonoma, Kohima, Nagaland 797002',
      lat: 25.651400,
      lng: 94.019400,
      description:
          'Known as Asia\'s first Green Village for its community-led conservation efforts in forestry and wildlife. Located about 20 km from Kohima, this historic Angami village is renowned for its brave warrior heritage, rich folklore, and successful model of eco-tourism.',
      imageAsset: 'assets/images/spots/kohima_khonoma.jpg',
      tags: ['Asia\'s 1st Green Village', 'Brave Warrior Forts', 'Alder Jhum Farming', 'Eco Conservation'],
      pinColor: Color(0xFF16A34A),
    ),
    TouristMapDestination(
      id: 'touphema_village',
      name: 'Touphema Tourist Village',
      district: 'Kohima',
      category: 'Culture & Villages',
      address: 'Touphema, Kohima, Nagaland 797105',
      lat: 25.850000,
      lng: 94.150000,
      description:
          'Touphema Tourist Village is situated on a scenic hill ridge that was set up as a traditional Angami Naga village. Visitors can stay in traditional huts that reflect authentic Naga heritage, with bedrooms, detached kitchens, and museum.',
      imageAsset: 'assets/images/spots/kohima_touphema.jpg',
      tags: ['Community Tourism', 'Traditional Angami Huts', 'Cultural Museum', 'Local Delicacies'],
      pinColor: Color(0xFF0891B2),
    ),
    TouristMapDestination(
      id: 'dzuleke',
      name: 'Dzuleke',
      district: 'Kohima',
      category: 'Nature & Treks',
      address: 'Dzuleke Village, Kohima, Nagaland 797002',
      lat: 25.620000,
      lng: 93.950000,
      description:
          'Dzuleke village is nestled about 40 km from Kohima in Nagaland. It is renowned for its exemplary model of eco-tourism and community conservation. The village thrives on sustainable eco-homestays, organic farming, and trout fish preservation.',
      imageAsset: 'assets/images/spots/kohima_dzuleke.jpg',
      tags: ['Eco Homestays', 'Trout Conservation', 'Organic Farming', 'Crystal Streams'],
      pinColor: Color(0xFF059669),
    ),

    // ----------------- WOKHA (3) -----------------
    TouristMapDestination(
      id: 'mount_tiyi',
      name: 'Mount Tiyi',
      district: 'Wokha',
      category: 'Mountain Peaks',
      address: 'Mount Tiyi Ridge, Wokha, Nagaland 797111',
      lat: 26.100000,
      lng: 94.260000,
      description:
          'Known as the "Mountain of Life", Mount Tiyi stands at approximately 1,969 meters and is considered a sacred site believed to be the abode of departed souls. It offers stunning 360-degree vistas across Assam plains and Doyang valley.',
      imageAsset: 'assets/images/spots/wokha_town_tiyi.jpg',
      tags: ['Mountain of Life', '1969m Sacred Peak', 'Lotha Legends', 'Rhododendron Trails'],
      pinColor: Color(0xFFF97316),
    ),
    TouristMapDestination(
      id: 'totsu_cliff',
      name: 'Totsu Cliff',
      district: 'Wokha',
      category: 'Viewpoints',
      address: 'Totsu Village, Wokha District, Nagaland 797111',
      lat: 26.160000,
      lng: 94.280000,
      description:
          'This picturesque cliff provides breathtaking panoramic views of the surrounding valleys and is a favored spot for photography and sightseeing.',
      imageAsset: 'assets/images/clean_districts/wokha.jpg',
      tags: ['Panoramic Valley View', 'Cliffside Photography', 'Rock Formations', 'Lotha Hills'],
      pinColor: Color(0xFFD97706),
    ),
    TouristMapDestination(
      id: 'doyang_river',
      name: 'Doyang Reservoir & Pangti',
      district: 'Wokha',
      category: 'Nature & Treks',
      address: 'Doyang Hydro Project, Pangti, Wokha, Nagaland 797111',
      lat: 26.152400,
      lng: 94.279400,
      description:
          'One of the largest rivers in the region, the Doyang River is known for its scenic beauty and is ideal for activities such as camping, boating and fishing. Pangti village is the world-famous falcon capital hosting hundreds of thousands of migratory Amur Falcons.',
      imageAsset: 'assets/images/spots/wokha_doyang.jpg',
      tags: ['Amur Falcon Capital', 'Doyang Hydro Project', 'Boating & Fishing', 'Scenic Reservoir'],
      pinColor: Color(0xFF0284C7),
    ),

    // ----------------- KIPHIRE (3) -----------------
    TouristMapDestination(
      id: 'mount_saramati',
      name: 'Mount Saramati',
      district: 'Kiphire',
      category: 'Mountain Peaks',
      address: 'Thanamir Village, Kiphire, Nagaland 798611',
      lat: 25.742400,
      lng: 95.031200,
      description:
          'Revered as the "Crown of Nagaland", Mount Saramati standing at 3,826 meters, is the highest peak in Nagaland. Located on the border between the Indian state of Nagaland and Myanmar, it offers breathtaking panoramic views and snow-capped peaks in winter.',
      imageAsset: 'assets/images/spots/kiphire_hills.jpg',
      tags: ['Highest Peak 3826m', 'Snow-capped in Winter', 'India-Myanmar Border', 'Apple Village Thanamir'],
      pinColor: Color(0xFFEA580C),
    ),
    TouristMapDestination(
      id: 'caves_of_mimi',
      name: 'Caves of Mimi',
      district: 'Kiphire',
      category: 'Heritage & History',
      address: 'Mimi Village, Kiphire, Nagaland 798611',
      lat: 25.680000,
      lng: 94.950000,
      description:
          'These enchanting caves are situated in Mimi village. The Caves of Mimi nestle at an altitude of 300-400 feet above the valley floor. There are four wonderful natural limestone caves that have offered shelter to wild animals and bats.',
      imageAsset: 'assets/images/clean_districts/kiphire.jpg',
      tags: ['Limestone Caves', 'Underground Chambers', 'Ancient Shelter', 'Mimi Wildlife'],
      pinColor: Color(0xFF8B5CF6),
    ),
    TouristMapDestination(
      id: 'fakhim_sanctuary',
      name: 'Fakhim Wildlife Sanctuary',
      district: 'Kiphire',
      category: 'Nature & Wildlife',
      address: 'Fakhim Village, Kiphire, Nagaland 798611',
      lat: 25.850000,
      lng: 95.050000,
      description:
          'Spread over 642 hectares, this pristine sanctuary is home to diverse flora and fauna, including rare species such as Wild Buffaloes, Mithun, Hoolock Gibbons, Blyth\'s Tragopan, and majestic hornbills.',
      imageAsset: 'assets/images/spots/kiphire_hills.jpg',
      tags: ['642 Hectare Sanctuary', 'Blyth\'s Tragopan', 'Hoolock Gibbons', 'Virgin Forests'],
      pinColor: Color(0xFF059669),
    ),

    // ----------------- ZÜNHEBOTO (6) -----------------
    TouristMapDestination(
      id: 'ghosu_bird_sanctuary',
      name: 'Ghosu Bird Sanctuary',
      district: 'Zünheboto',
      category: 'Nature & Wildlife',
      address: 'Ghosu Village, Zünheboto, Nagaland 798620',
      lat: 25.980000,
      lng: 94.520000,
      description:
          'This sanctuary attracts numerous migratory birds, making it a paradise for ornithologists and birdwatchers, especially between June and September.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['Birdwatching Haven', 'Over 20 Bird Species', 'Community Protected', 'Lush Forest'],
      pinColor: Color(0xFF0D9488),
    ),
    TouristMapDestination(
      id: 'satoi_range',
      name: 'Satoi Range',
      district: 'Zünheboto',
      category: 'Nature & Treks',
      address: 'Satoi, Zünheboto, Nagaland 798620',
      lat: 25.920000,
      lng: 94.600000,
      description:
          'Satoi Range is a pristine natural heritage known for its biodiversity and stunning landscapes. It is a habitat of the Blyth\'s Tragopan. Popular for trekking, the range is embellished by wild rhododendrons during the months of April and May.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['Rhododendron Bloom', 'Tragopan Habitat', 'Pristine Mountain Ridge', 'Trekking'],
      pinColor: Color(0xFF16A34A),
    ),
    TouristMapDestination(
      id: 'lake_aizuto',
      name: 'Lake Aizuto',
      district: 'Zünheboto',
      category: 'Viewpoints',
      address: 'Aizuto, Zünheboto, Nagaland 798620',
      lat: 26.010000,
      lng: 94.490000,
      description:
          'A picturesque lake spot ideal for picnics, boating, and peaceful relaxation amidst serene green surroundings.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['Alpine Lake', 'Picnic Spot', 'Peaceful Scenery', 'Freshwater'],
      pinColor: Color(0xFF0284C7),
    ),
    TouristMapDestination(
      id: 'tizu_valley',
      name: 'Tizu Valley',
      district: 'Zünheboto',
      category: 'Nature & Treks',
      address: 'Tizu River Basin, Zünheboto, Nagaland 798620',
      lat: 25.960000,
      lng: 94.550000,
      description:
          'Renowned for its mist-covered hills and rushing river waters, Tizu Valley is perfect for photography and enjoying the tranquil environment.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['River Basin', 'Mist-covered Valleys', 'Serene Landscapes', 'Angling'],
      pinColor: Color(0xFF0891B2),
    ),
    TouristMapDestination(
      id: 'vishepu_village',
      name: 'Vishepu Village',
      district: 'Zünheboto',
      category: 'Culture & Villages',
      address: 'Vishepu Village, Zünheboto, Nagaland 798620',
      lat: 26.040000,
      lng: 94.520000,
      description:
          'This village showcases traditional Sumi culture and is known for its vibrant festivals, including the significant Tuluni festival celebrated in July.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['Sumi Cultural Village', 'Tuluni Festival', 'Traditional Folk Dances', 'Warm Hospitality'],
      pinColor: Color(0xFFD97706),
    ),
    TouristMapDestination(
      id: 'sumi_baptist_church',
      name: 'Sumi Baptist Church',
      district: 'Zünheboto',
      category: 'Religious & Landmarks',
      address: 'Centre Church Hill, Zünheboto, Nagaland 798620',
      lat: 25.972000,
      lng: 94.518000,
      description:
          'One of the largest churches in Asia, situated at an elevation of 1,868 meters on a hill top. The church has a seating capacity of 8,500 people and is an iconic landmark of Nagaland.',
      imageAsset: 'assets/images/clean_districts/zunheboto.jpg',
      tags: ['Largest Church in Asia', '8500 Seating Capacity', '1868m Hilltop', 'Iconic Architecture'],
      pinColor: Color(0xFF7C3AED),
    ),
  ];

  static List<TouristMapDestination> fromDistricts(List<DistrictInfo> districts) {
    if (districts.isEmpty) return destinations;

    final List<TouristMapDestination> result = [];

    // Helper map of static destinations for quick coordinate and tag lookup
    final Map<String, TouristMapDestination> staticByName = {};
    for (final d in destinations) {
      staticByName[_normalize(d.name)] = d;
    }

    for (final dist in districts) {
      final districtName = dist.name.trim();
      final defaultColor = _defaultColorForDistrict(districtName);

      for (int i = 0; i < dist.spots.length; i++) {
        final spot = dist.spots[i];
        final normName = _normalize(spot.name);

        // Try exact match or partial match
        TouristMapDestination? match = staticByName[normName];
        if (match == null) {
          for (final entry in staticByName.entries) {
            if (entry.key.contains(normName) || normName.contains(entry.key)) {
              match = entry.value;
              break;
            }
          }
        }

        if (match != null) {
          // Merge static coordinate data with live Firestore data
          result.add(TouristMapDestination(
            id: match.id,
            name: spot.name.isNotEmpty ? spot.name : match.name,
            district: districtName.isNotEmpty ? districtName : match.district,
            category: match.category,
            address: match.address,
            lat: match.lat,
            lng: match.lng,
            description: spot.description.trim().isNotEmpty
                ? spot.description
                : match.description,
            imageAsset: (spot.imageAsset != null && spot.imageAsset!.isNotEmpty)
                ? spot.imageAsset!
                : match.imageAsset,
            imageUrl: spot.imageUrl,
            mapUrl: spot.mapUrl,
            timing: spot.timing,
            tags: match.tags,
            pinColor: defaultColor,
          ));
        } else {
          // Dynamic spot added via Firestore
          final fallbackCoords = _defaultCoordsForDistrict(districtName, i);
          result.add(TouristMapDestination(
            id: '${_normalize(districtName)}_${_normalize(spot.name)}',
            name: spot.name,
            district: districtName,
            category: 'Tourist Destination',
            address: '${spot.name}, $districtName, Nagaland',
            lat: fallbackCoords.lat,
            lng: fallbackCoords.lng,
            description: spot.description,
            imageAsset: spot.imageAsset ?? 'assets/images/clean_districts/kohima.jpg',
            imageUrl: spot.imageUrl,
            mapUrl: spot.mapUrl,
            timing: spot.timing,
            tags: [districtName, 'Nagaland Tourism', 'Must Visit'],
            pinColor: defaultColor,
          ));
        }
      }
    }

    return result.isNotEmpty ? result : destinations;
  }

  static String _normalize(String s) {
    return s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static Color _defaultColorForDistrict(String district) {
    final lower = district.toLowerCase();
    if (lower.contains('kohi')) return const Color(0xFFE11D48);
    if (lower.contains('dima')) return const Color(0xFF0284C7);
    if (lower.contains('chum') || lower.contains('chüm')) return const Color(0xFF059669);
    if (lower.contains('wokh')) return const Color(0xFFF97316);
    if (lower.contains('kiph')) return const Color(0xFF8B5CF6);
    if (lower.contains('zunh')) return const Color(0xFF0D9488);

    // Deterministic distinct color for any newly added destination/collection
    const extraPalette = [
      Color(0xFF7C3AED), // Violet
      Color(0xFFD97706), // Amber
      Color(0xFF2563EB), // Royal Blue
      Color(0xFFDB2777), // Pink
      Color(0xFF0891B2), // Cyan
      Color(0xFF4F46E5), // Indigo
      Color(0xFF65A30D), // Olive Green
      Color(0xFFDC2626), // Crimson
    ];
    final key = _normalize(district);
    if (key.isEmpty) return const Color(0xFF0D9488);
    final hash = key.codeUnits.fold<int>(0, (acc, c) => (acc * 31 + c) & 0x7fffffff);
    return extraPalette[hash % extraPalette.length];
  }

  static ({double lat, double lng}) _defaultCoordsForDistrict(String district, int index) {
    final lower = district.toLowerCase();
    double baseLat = 25.67;
    double baseLng = 94.11;
    if (lower.contains('kohi')) {
      baseLat = 25.67;
      baseLng = 94.11;
    } else if (lower.contains('dima')) {
      baseLat = 25.90;
      baseLng = 93.73;
    } else if (lower.contains('chum') || lower.contains('chüm')) {
      baseLat = 25.82;
      baseLng = 93.76;
    } else if (lower.contains('wokh')) {
      baseLat = 26.10;
      baseLng = 94.26;
    } else if (lower.contains('kiph')) {
      baseLat = 25.75;
      baseLng = 94.98;
    } else if (lower.contains('zunh')) {
      baseLat = 25.98;
      baseLng = 94.52;
    }
    final offset = (index % 5) * 0.015;
    return (lat: baseLat + offset, lng: baseLng + offset);
  }
}
