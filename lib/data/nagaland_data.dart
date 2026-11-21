class TouristSpot {
  final String name;
  final String? timing;
  final String? imageAsset;
  final String? imageUrl;
  final String description;

  const TouristSpot({
    required this.name,
    this.timing,
    this.imageAsset,
    this.imageUrl,
    required this.description,
  });
}

class DistrictInfo {
  final String id;
  final String name;
  final String displayName;
  final String spotsCountText;
  final String heroAsset;
  final String? cardAsset;
  final String? thumbAsset;
  final String distanceInfo;
  final String transportInfo;
  final String stayInfo;
  final List<TouristSpot> spots;

  const DistrictInfo({
    required this.id,
    required this.name,
    required this.displayName,
    required this.spotsCountText,
    required this.heroAsset,
    this.cardAsset,
    this.thumbAsset,
    required this.distanceInfo,
    required this.transportInfo,
    required this.stayInfo,
    required this.spots,
  });
}

class NagalandData {
  static final List<DistrictInfo> districts = [
    // 1. CHÜMOUKEDIMA
    DistrictInfo(
      id: "chumoukedima",
      name: "Chümoukedima",
      displayName: "CHÜMOUKEDIMA",
      spotsCountText: "4 Spots (you must visit)",
      heroAsset: "assets/images/chumoukedima_hero.png",
      cardAsset: "assets/images/district_card_chumoukedima.png",
      thumbAsset: "assets/images/district_card_chumoukedima.png",
      distanceInfo: "20 Mins\nfrom Dimapur",
      transportInfo: "Flight and\nTrain Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Nagaland Zoological Park",
          timing: "9AM to 5PM (Monday Closed)",
          imageAsset: "assets/images/spot_zoological_park.png",
          description:
              "Located in Chümoukedima district, Nagaland Zoological Park spans about 176 hectares and officially opened in August 2008. It highlights the region's commitment to wildlife conservation and biodiversity, showcasing a diverse range of animal species. Beyond wildlife observation, the park focuses on nature education and conservation, promoting awareness and appreciation for the environment.",
        ),
        TouristSpot(
          name: "Merryland Park",
          timing: "10AM to 6PM",
          imageAsset: "assets/images/chumoukedima_hero.png",
          description:
              "The first water park in Nagaland, Merry Land Park, offers variety of attractions like Kids play with Hobbit, Carousel, Gaming arcade, Rental block, Changing room, Morung, Rock garden, Food court, Skating rink, Paddle pool, Bumper cars, Niagara falls, Funnel slide, Wave pool, Rain dance and Photo booth.",
        ),
        TouristSpot(
          name: "Triple Falls",
          imageAsset: "assets/images/wokha_hero.png",
          description:
              "Situated in Seithekima Village, Chümoukedima, the stunning Triple Falls showcases three beautiful streams plunging 280 feet into a natural pool, offering a spectacular sight. These enchanting waterfalls are ideal not only for sightseeing but also for trekking adventures.",
        ),
        TouristSpot(
          name: "Diezephe Craft Village",
          imageAsset: "assets/images/tribe_angami.png",
          description:
              "Supported by the Nagaland Handloom and Handicrafts Development Corporation Limited, the village has become a significant player in craft exports to other states. Diezephe Craft Village is celebrated for its exceptional craftsmanship, including woodcarving, bamboo and cane work, and various handloom products.",
        ),
      ],
    ),

    // 2. WOKHA
    DistrictInfo(
      id: "wokha",
      name: "Wokha",
      displayName: "Wokha",
      spotsCountText: "3 Spots (you must visit)",
      heroAsset: "assets/images/wokha_hero.png",
      cardAsset: "assets/images/district_thumb_wokha.png",
      thumbAsset: "assets/images/district_thumb_wokha.png",
      distanceInfo: "2 Hrs\nfrom Kohima",
      transportInfo: "Bus and\nTaxi Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Mount Tiyi",
          imageAsset: "assets/images/spot_mount_tiyi.png",
          description:
              "Known as the \"Mountain of Life\", Mount Tiyi stands at approximately 1,969 meters and is considered a sacred site believed to be the abode of departed souls. It offers stunning views and is popular for trekking.",
        ),
        TouristSpot(
          name: "Totsu Cliff",
          imageAsset: "assets/images/spot_totsu_cliff.png",
          description:
              "This picturesque cliff provides breathtaking panoramic views of the surrounding valleys and is a favored spot for photography and sightseeing.",
        ),
        TouristSpot(
          name: "Doyang River & Hydro Project",
          imageAsset: "assets/images/wokha_hero.png",
          description:
              "One of the largest rivers in the region, the Doyang River is known for its scenic beauty and is ideal for activities such as camping, boating and fishing.",
        ),
      ],
    ),

    // 3. KIPHIRE
    DistrictInfo(
      id: "kiphire",
      name: "Kiphire",
      displayName: "Kiphire",
      spotsCountText: "3 Spots (you must visit)",
      heroAsset: "assets/images/kiphire_hero.png",
      cardAsset: "assets/images/district_card_kiphire.png",
      thumbAsset: "assets/images/district_card_kiphire.png",
      distanceInfo: "8 Hrs\nfrom Kohima",
      transportInfo: "Bus and\nTaxi Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Mount Saramati",
          imageAsset: "assets/images/district_card_kiphire.png",
          description:
              "Revered as the \"Crown of Nagaland\", Mount Saramati standing at 3,826 meters, is the highest peak in Nagaland. Located on the border between the Indian state of Nagaland and Myanmar, it offers breathtaking panoramic views of the surrounding landscapes. The peak is particularly captivating during the winter months when it is blanketed in snow.",
        ),
        TouristSpot(
          name: "Caves of Mimi",
          imageAsset: "assets/images/spot_totsu_cliff.png",
          description:
              "These enchanting caves is situated in the Mimi village. The Caves of Mimi nestled at the height of 300-400 feet above the sea level. There are four wonderful caves, and they offered shelter to wild animals and bats.",
        ),
        TouristSpot(
          name: "Fakhim Wildlife Sanctuary",
          imageAsset: "assets/images/spot_zoological_park.png",
          description:
              "The wildlife sanctuary, spread over the 642 hectares, is home to diverse flora and fauna, including rare species. Fakhim Wildlife Sanctuary includes several animals such as Wild Buffaloes, Mithun, Hoolock Gibbons, Blyth's Tragopan and hornbills.",
        ),
      ],
    ),

    // 4. KOHIMA
    DistrictInfo(
      id: "kohima",
      name: "Kohima",
      displayName: "Kohima",
      spotsCountText: "10 Spots (you must visit)",
      heroAsset: "assets/images/kohima_hero.png",
      cardAsset: "assets/images/district_thumb_kohima.png",
      thumbAsset: "assets/images/district_thumb_kohima.png",
      distanceInfo: "2 Hrs\nfrom Dimapur",
      transportInfo: "Bus and\nTaxi Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Kohima War Cemetery",
          timing: "9AM to 4PM (daily)",
          imageAsset: "assets/images/tourist_map/thumb_cemetery.png",
          description:
              "The Kohima War Cemetery in Nagaland, India, is a solemn memorial dedicated to soldiers who fought in World War II during the decisive Battle of Kohima in 1944. The cemetery is particularly moving for its dedication plaque with the famous words: 'When You Go Home, Tell Them Of Us And Say, For Your Tomorrow, We Gave Our Today.' It serves as an enduring tribute to the bravery and resilience of those who perished.",
        ),
        TouristSpot(
          name: "Mary Help of Christians Cathedral",
          imageAsset: "assets/images/kohima_hero.png",
          description:
              "Mary Help of Christians Cathedral, standing tall with its unique semi-circular architecture, serves as a prominent landmark in Kohima. Built during the British colonial era, its vibrant design and peaceful ambiance make it an architectural and historical marvel of the region. The cathedral serves not only as a place of worship but also as a symbol of faith and cultural heritage.",
        ),
        TouristSpot(
          name: "Nagaland State Museum",
          timing: "9:30AM to 3PM (Sunday Closed)",
          imageAsset: "assets/images/spot_zoological_park.png",
          description:
              "The Nagaland State Museum is a treasure trove of artefacts, representing Nagaland's rich history. Its collection showcases artifacts from the traditional life of the Naga tribes. Visitors receive an insightful look into the lifestyle, customs, art, and traditions of Nagaland.",
        ),
        TouristSpot(
          name: "Kisama Heritage Village",
          imageAsset: "assets/images/tourist_map/thumb_kisama.png",
          description:
              "Kisama Heritage Village is located on the scenic slopes between Kigwema and Phesama villages. Established to protect and highlight the vibrant cultural legacy of the Naga tribes, it serves as a living museum where all the recognized 17 major tribes have traditional morungs built to celebrate the annual Hornbill Festival.",
        ),
        TouristSpot(
          name: "Puliebadze Wildlife Sanctuary",
          imageAsset: "assets/images/chumoukedima_hero.png",
          description:
              "Puliebadze Wildlife Sanctuary in Kohima district covers 9.23 square km. It is a vital catchment area for Kohima town. The sanctuary includes scenic forest and hiking trails, and is home to species like tragopan, barking deer, and common leopard. An altitude of 2,296 meters serves as the highest point of the Puliebadze Wildlife Sanctuary.",
        ),
        TouristSpot(
          name: "Dzukou Valley",
          imageAsset: "assets/images/tourist_map/thumb_dzukou.png",
          description:
              "Located at an elevation of 2,452 meters above sea level, Dzukou Valley sits on the border between Nagaland and Manipur. Celebrated for its rolling bamboo hillocks, serpentine stream, pristine flora, and serene valleys. Often referred to as the 'Valley of Flowers of the North East'.",
        ),
        TouristSpot(
          name: "Mount Japfu",
          imageAsset: "assets/images/spot_totsu_cliff.png",
          description:
              "Japfu Peak is the second highest peak in Nagaland, standing at an elevation of 3,048 metres. It is renowned for its lush vegetation, including the tallest rhododendron tree in the world (listed in the Guinness Book of Records at 109 feet tall). It is a top destination for nature and adventure enthusiasts, offering panoramic views of Dzukou Valley.",
        ),
        TouristSpot(
          name: "Khonoma Village",
          imageAsset: "assets/images/trip_nagaland.png",
          description:
              "Known as Asia's first Green Village for its community-led conservation efforts in forestry and wildlife. Located about 20 km from Kohima, this historic Angami village is renowned for its brave warrior heritage, rich folklore, and successful model of eco-tourism and alder-based jhum cultivation.",
        ),
        TouristSpot(
          name: "Touphema Tourist Village",
          timing: "February (best month to visit)",
          imageAsset: "assets/images/morung_angami.png",
          description:
              "Touphema Tourist Village is situated on a scenic hill ridge that was set up as a traditional Angami Naga village. Visitors can stay in traditional huts that reflect authentic Naga heritage, with bedrooms, detached kitchens, and museum. A stay allows visitors to interact with locals, savor traditional cuisine, and learn about the Naga tribal way of life.",
        ),
        TouristSpot(
          name: "Dzuleke",
          imageAsset: "assets/images/banner_2.png",
          description:
              "Dzuleke village is nestled about 40 km from Kohima in Nagaland. It is renowned for its exemplary model of eco-tourism and community conservation. The village thrives on sustainable eco-homestays, organic farming, and trout fish preservation. The crystal streams flowing through picturesque valley provide a serene backdrop for hiking, picnicking, and nature retreats.",
        ),
      ],
    ),

    // 5. DIMAPUR
    DistrictInfo(
      id: "dimapur",
      name: "Dimapur",
      displayName: "Dimapur",
      spotsCountText: "4 Spots (you must visit)",
      heroAsset: "assets/images/chumoukedima_hero.png",
      cardAsset: null,
      thumbAsset: null,
      distanceInfo: "5 Hrs\nfrom Guwahati",
      transportInfo: "Flight and\nTrain Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Kachari Ruins",
          timing: "9AM to 5PM (daily)",
          imageAsset: "assets/images/tourist_map/card_kachari.png",
          description:
              "Nestled within the vibrant town of Dimapur, the Kachari ruins are believed to date back to the 10th century and serves as a testament to the once-thriving Kachari civilization. This site features a series of mushroom-domed pillars, showcasing the unique architectural style of the time.",
        ),
        TouristSpot(
          name: "North East Zone Cultural Centre (NEZCC)",
          imageAsset: "assets/images/spot_zoological_park.png",
          description:
              "The Cultural heritage of India's northeast is preserved here in the form of a museum. Visit the Museum and take a stroll at the Stone garden nearby.",
        ),
        TouristSpot(
          name: "Heirloom Naga Centre",
          timing: "9:30AM to 6:30PM (Mon-Sat)",
          imageAsset: "assets/images/tribe_angami.png",
          description:
              "The Heirloom Naga Centre is a dynamic hub dedicated to nurturing and revitalizing Naga cultural traditions. Its gallery celebrates Naga culture through traditional practices and exquisite craftsmanship. Each piece tells a story, reflecting the unique heritage of diverse Naga tribes, showcasing intricately woven textiles and beautifully carved woodwork made from indigenous materials and distinctive patterns passed down through generations.",
        ),
        TouristSpot(
          name: "Green Park",
          timing: "9AM to 5PM",
          imageAsset: "assets/images/wokha_hero.png",
          description:
              "Green Park Dimapur is a fantastic recreational destination located just 5 km from the main city. The park offers a variety of exciting activities, including ziplining, rock climbing, a shooting range, boating, and an ATV track. Whether you're seeking adventure or a relaxing day outdoors, Green Park provides something for everyone to enjoy in a beautiful natural setting.",
        ),
      ],
    ),

    // 6. ZUNHEBOTO
    DistrictInfo(
      id: "zunheboto",
      name: "Zunheboto",
      displayName: "Zunheboto",
      spotsCountText: "6 Spots (you must visit)",
      heroAsset: "assets/images/zunheboto_hero.png",
      cardAsset: "assets/images/district_thumb_zunheboto.png",
      thumbAsset: "assets/images/district_thumb_zunheboto.png",
      distanceInfo: "3.5 Hrs\nfrom Kohima",
      transportInfo: "Bus and\nTaxi Available",
      stayInfo: "Homestays\nAvailable",
      spots: [
        TouristSpot(
          name: "Ghosu Bird Sanctuary",
          imageAsset: "assets/images/hornbill.png",
          description:
              "This sanctuary attracts numerous migratory birds, making it a paradise for ornithologists and birdwatchers, especially between June and September.",
        ),
        TouristSpot(
          name: "Satoi Range",
          imageAsset: "assets/images/spot_mount_tiyi.png",
          description:
              "Satoi Range is a pristine natural heritage known for its biodiversity and stunning landscapes. It is a habitat of the Blyth's Tragopan. Popular for trekking, the range is also embellished by rhododendrons during the month of April and May.",
        ),
        TouristSpot(
          name: "Lake Aizuto",
          imageAsset: "assets/images/wokha_hero.png",
          description:
              "A picturesque spot ideal for picnics, boating, and relaxation amidst serene surroundings.",
        ),
        TouristSpot(
          name: "Tizu Valley",
          imageAsset: "assets/images/trip_dzukou.png",
          description:
              "Renowned for its mist-covered hills, Tizu Valley is perfect for photography and enjoying the tranquil environment.",
        ),
        TouristSpot(
          name: "Vishepu Village",
          imageAsset: "assets/images/morung_chakhesang.png",
          description:
              "This village showcases traditional Sumi culture and is known for its vibrant festivals, including the significant Tuluni festival celebrated in July.",
        ),
        TouristSpot(
          name: "Sumi Baptist Church",
          imageAsset: "assets/images/zunheboto_hero.png",
          description:
              "It is one of the largest churches in Asia, situated at an elevation of 1,868 meters on a hill top. The church is not only a place of worship but also a cultural landmark, hosting significant events like the Tuluni Festival, which celebrates the harvest season and showcases traditional Sumi dances and rituals.",
        ),
      ],
    ),
  ];

  static DistrictInfo getDistrictById(String id) {
    return districts.firstWhere(
      (d) => d.id.toLowerCase() == id.toLowerCase(),
      orElse: () => districts[0],
    );
  }
}
