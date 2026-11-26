import 'package:flutter/foundation.dart';
import '../../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/firebase_service.dart';

class TribalFestival {
  final int id;
  final String docId;
  final String tribe;
  final String festivalName;
  final String localAsset;
  final String networkUrl;
  final String description;

  const TribalFestival({
    required this.id,
    this.docId = '',
    required this.tribe,
    required this.festivalName,
    required this.localAsset,
    required this.networkUrl,
    required this.description,
  });

  String get uniqueKey => docId.isNotEmpty ? docId : '${id}_$festivalName';

  factory TribalFestival.fromMap(Map<String, dynamic> map, [int fallbackId = 999]) {
    final rawSerial = map['serialno'] ?? map['serialNo'] ?? map['serial_no'] ?? map['id'];
    int parsedId;
    if (rawSerial is num) {
      parsedId = rawSerial.toInt();
    } else {
      parsedId = int.tryParse(rawSerial?.toString() ?? '') ?? fallbackId;
    }

    final tribe = (map['tribeName'] ?? map['tribe_name'] ?? map['tribe'] ?? '').toString();
    final festivalName = (map['festivalName'] ?? map['festival_name'] ?? map['name'] ?? map['title'] ?? '').toString();
    final description = (map['description'] ?? map['desc'] ?? map['details'] ?? '').toString();
    final imageUrl = (map['image'] ?? map['photo'] ?? map['networkUrl'] ?? map['url'] ?? '').toString();
    final docId = (map['docId'] ?? map['id'] ?? '').toString();

    final localAsset = _resolveLocalAsset(parsedId, tribe);

    return TribalFestival(
      id: parsedId,
      docId: docId,
      tribe: tribe,
      festivalName: festivalName,
      localAsset: localAsset,
      networkUrl: imageUrl,
      description: description,
    );
  }

  static String _resolveLocalAsset(int id, String tribeName) {
    final cleanTribe = tribeName.toLowerCase().trim();
    if (cleanTribe.contains('angami')) return 'assets/images/tribes/1_angami.webp';
    if (cleanTribe.contains('ao')) return 'assets/images/tribes/2_ao.webp';
    if (cleanTribe.contains('chakhesang')) return 'assets/images/tribes/3_chakhesang.webp';
    if (cleanTribe.contains('chang')) return 'assets/images/tribes/4_chang.webp';
    if (cleanTribe.contains('garo')) return 'assets/images/tribes/5_garo.webp';
    if (cleanTribe.contains('kachari')) return 'assets/images/tribes/6_kachari.webp';
    if (cleanTribe.contains('khiamniungan')) return 'assets/images/tribes/7_khiamniungan.webp';
    if (cleanTribe.contains('konyak')) return 'assets/images/tribes/8_konyak.webp';
    if (cleanTribe.contains('kuki')) return 'assets/images/tribes/9_kuki.webp';
    if (cleanTribe.contains('lotha')) return 'assets/images/tribes/10_lotha.webp';
    if (cleanTribe.contains('phom')) return 'assets/images/tribes/11_phom.webp';
    if (cleanTribe.contains('pochury')) return 'assets/images/tribes/12_pochury.webp';
    if (cleanTribe.contains('rengma')) return 'assets/images/tribes/13_rengma.webp';
    if (cleanTribe.contains('sangtam')) return 'assets/images/tribes/14_sangtam.webp';
    if (cleanTribe.contains('sumi')) return 'assets/images/tribes/15_sumi.webp';
    if (cleanTribe.contains('tikhir')) return 'assets/images/tribes/16_tikhir.webp';
    if (cleanTribe.contains('yimkhiung')) return 'assets/images/tribes/17_yimkhiung.webp';
    if (cleanTribe.contains('zeliang')) return 'assets/images/tribes/18_zeliang.webp';
    if (id >= 1 && id <= 18) {
      const tribeNames = [
        'angami', 'ao', 'chakhesang', 'chang', 'garo', 'kachari',
        'khiamniungan', 'konyak', 'kuki', 'lotha', 'phom', 'pochury',
        'rengma', 'sangtam', 'sumi', 'tikhir', 'yimkhiung', 'zeliang'
      ];
      return 'assets/images/tribes/${id}_${tribeNames[id - 1]}.webp';
    }
    return 'assets/images/festivals_top_hero.png';
  }
}

class FestivalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const FestivalsScreen({super.key, this.onBack});

  @override
  State<FestivalsScreen> createState() => _FestivalsScreenState();
}

class _FestivalsScreenState extends State<FestivalsScreen> {
  // Currently expanded festival key (unique docId/key so only 1 item ever expands).
  String? _expandedKey;
  bool _didInitExpansion = false;

  static const List<TribalFestival> _defaultFestivals = [
    TribalFestival(
      id: 1,
      tribe: 'Angami',
      festivalName: 'Sekrenyi Festival',
      localAsset: 'assets/images/tribes/1_angami.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FAngami.png?alt=media&token=f125e913-19c8-4ed3-b44e-af54921313a2',
      description:
          'Sekrenyi (or Phousanyi) is the main festival of the Angami Naga community, celebrated in December by Southern Angamis and in February by Western and Northern Angamis, with a common date of February 25th. It marks the beginning of the lunar year and is a time for prayer, purification, and renewal of body and soul.\n\nTraditionally, it celebrates the transition from boyhood to adulthood, especially for young men. The festival includes feasting, singing, and cultural displays, with key rituals like Kizie, Zumho, and Dzuseva for purification. Participants wear new shawls, and activities like hunting, gate-pulling, and inter-village ceremonies occur later in the festival, with villagers abstaining from agricultural work.',
    ),
    TribalFestival(
      id: 2,
      tribe: 'Ao',
      festivalName: 'Moatsü Festival',
      localAsset: 'assets/images/tribes/2_ao.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FAo.png?alt=media&token=3add0a8c-e73b-47fd-a320-986298faf51b',
      description:
          'Moatsü is an annual festival celebrated by the Ao Naga tribes of Nagaland in the first week of May. It marks the end of the sowing season and hopes for a bountiful harvest. The festival features communal feasts, traditional sports, cultural performances, and bonfires. Rituals include repairs and construction of houses by elders of the Putu Menden (Village Council), ploughing of old and new Jhum Kheti, and cleaning the Tzübu (water wells). Moatsü fosters community bonding and provides an opportunity for villagers to come together and celebrate their cultural identity.',
    ),
    TribalFestival(
      id: 3,
      tribe: 'Chakhesang',
      festivalName: 'Thuni Festival',
      localAsset: 'assets/images/tribes/3_chakhesang.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FChakesang.png?alt=media&token=e9c9aaff-85b1-45f3-aef0-ef20b1ab4930',
      description:
          'Thuni is the primary festival of the Poumai Chakhesang people from the Razeba area, celebrated on January 5th each year. The name "Thuni" combines "Thu" (new) and "ni" (festival), symbolizing new beginnings. Rituals include pushing down a large pile of firewood (Sükho) and using traditional fire-making methods (Mila) to create a bonfire, reflecting values of peace, purity, and equality.\n\nDuring the festival, couples participate in the Feast of Merit, expressing gratitude for their prosperity. They are honored with prestigious shawls like the “Hapidasa” and “Saparadu” and decorate homes with traditional items such as “kike” and “hapiteh”.',
    ),
    TribalFestival(
      id: 4,
      tribe: 'Chang',
      festivalName: 'Naknyulüm Festival',
      localAsset: 'assets/images/tribes/4_chang.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FChang.png?alt=media&token=b97dd2a9-6b4e-4857-812a-fa73016cbaa8',
      description:
          'Naknyu, meaning "Mother of Darkness," is a festival celebrated by the Chang people to mark the victory of light over darkness. It takes place during "Daomao," when the moon is fully concealed, symbolizing six days and nights of darkness. The festival, celebrated with joy and enthusiasm, lasts for three days, each with its own significance.\n\nOn the first day, called "Wenshi," women grind pearl millet into flour and make steamed biscuits, while men collect a scented plant, "Ngounam," to ward off evil.\n\nThe second day, "Youjem," involves sharing cooked meat and steamed biscuits, playing games like top spinning for men and box bean display for women. Women also play the bamboo flute "Kongkin," and there\'s a meat-eating competition.\n\nThe third day, "Nakseeng," concludes with clearing pavements and paths around the village, and men gather to clear the paths to the fields.',
    ),
    TribalFestival(
      id: 5,
      tribe: 'Garo',
      festivalName: 'Wangala Festival',
      localAsset: 'assets/images/tribes/5_garo.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FGaro.png?alt=media&token=e0353772-d8da-4f2d-a786-85fdedaf1aa5',
      description:
          'Wangala is a post-harvest festival celebrated by the Garo tribe of Nagaland on November 21st to honor Misi Saljong, the sun god of fertility, for a bountiful harvest. The festival lasts 2-3 days and features sports, food, and cultural performances, preserving the Garo heritage and connecting younger generations to their roots.\n\nParticipants wear colorful garments and feathered headgear while dancing to the rhythm of long drums. The Garo people first offer thanks to Misi Saljong before consuming their crops. The festival includes traditional dances like Wangala and Rugala, as well as indigenous games such as tug-of-war, stone lifting, wrestling, and bamboo pole pushing.\n\nOn the first day, rituals like pouring rice beer (Rugala) and incense burning (Sa\'sat So\'a) are performed by the priest, followed by dancing, gongs, and celebrations.',
    ),
    TribalFestival(
      id: 6,
      tribe: 'Kachari',
      festivalName: 'Bishu Dima Festival',
      localAsset: 'assets/images/tribes/6_kachari.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKachari.png?alt=media&token=6ba5d4bb-4e3f-42e5-aeb1-0fb853386ec9',
      description:
          'The Bishu Festival of the Dimasa Kachari is a post-harvest celebration, marking the end of the harvest season when food grains are thrashed and stored for the year. The festival is celebrated in three forms:\n\n1. Hangseu Bishu, a seven-day celebration\n2. Suren Bishu, a three-day celebration\n3. Jitab, a one-day festival\n\nDuring these festivities, traditional dances, flute playing (Muri), singing, and games are held, celebrating the community\'s harvest and cultural heritage.',
    ),
    TribalFestival(
      id: 7,
      tribe: 'Khiamniungan',
      festivalName: 'Tsokum Festival',
      localAsset: 'assets/images/tribes/7_khiamniungan.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKhiamniungan.png?alt=media&token=ff4c67ad-aeb9-4ee7-99df-cb2db92d8e40',
      description:
          'Tsokum, celebrated by the Khiamniungan Naga in October during the full moon, is the "festival of festivals" marking the harvest of new Jhum fields. The eight-day festival plays a key role in the community\'s socio-religious life. Harvesting is prohibited until the festival ends, ensuring prayers for prosperity, good health, and communal wellbeing are effective. Wealthy families slaughter buffalo or mithun for a feast of merit. Rituals are performed in the fields, followed by communal meals with pork, beef, and rice beer shared among relatives and neighbors. Tsokum symbolizes unity, cultural heritage, and agricultural prosperity, while invoking blessings for both people and livestock. After the festival, eligible young men may seek a bride.',
    ),
    TribalFestival(
      id: 8,
      tribe: 'Konyak',
      festivalName: 'Aoleang Festival',
      localAsset: 'assets/images/tribes/8_konyak.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKonyak.png?alt=media&token=8e932375-d8cf-4876-b9b4-3a7ee2ec8fa6',
      description:
          'The Aoleang Festival, celebrated by the Konyak Nagas of Nagaland in April, marks the end of the old year and the arrival of spring, with prayers for a bountiful harvest. The six-day festival has distinct events:\n\n1. Hoi Lai Yah Nyih (Preparation Day): The community prepares by gathering firewood, food, and rice beer. The head of the family sacrifices a chicken for blessings.\n2. Yin Mok Pho Nyih (Animal Tethering Day): Domestic animals are captured for sacrifice, and young boys participate in symbolic "head-hunting" rituals.\n3. Yin Mok Shek Nyih (Animal Sacrifice Day): The festival begins with the hoisting of a bamboo flag, followed by animal sacrifices and feasts.\n4. Lingnyu Nyih (Feasting and Dancing Day): People wear traditional clothes, feast, dance, and sing, while men teach young boys head-hunting skills.\n5. Lingha Nyih (Honoring Day): Young people honor the elderly, visit ancestors\' graves, and exchange food with family and friends.\n6. Lingshan Nyih (Cleaning Day): The final day is spent cleaning homes and the village, concluding the festival.\n\nThrough Aoleang, the Konyak Nagas celebrate their culture and seek blessings for prosperity in the coming year.',
    ),
    TribalFestival(
      id: 9,
      tribe: 'Kuki',
      festivalName: 'Mim Kut & Chavang Kut',
      localAsset: 'assets/images/tribes/9_kuki.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKuki.png?alt=media&token=e754f8ae-491d-4ff7-9164-a4e639d03084',
      description:
          'The Kukis have a rich cultural heritage, with life itself. They celebrate two major festivals: Mim Kut and Chavang Kut. Kuki folk songs vividly tell the tales of their warriors, heroines, and epic events, embodying eternal romance and cultural pride.\n\nMim Kut, celebrated on January 17th, is a post-harvest festival marking the final crop harvest of "MIM" (Job\'s Tears). The Thempu (priest) performs rituals, sacrifices fowls, and thanks Chung Pathen (the supernatural god) for the bountiful harvest.\n\nChavang Kut, observed on November 1st, marks the end of the harvest season. The Thempu offers prayers to the deities for a good harvest, distributes JU (rice beer), and the community celebrates with dancing, singing folklores, traditional games, and feasting.',
    ),
    TribalFestival(
      id: 10,
      tribe: 'Lotha',
      festivalName: 'Tokhü Emong',
      localAsset: 'assets/images/tribes/10_lotha.webp',
      networkUrl:
          'https://www.morungexpress.com/uploads/2023/11/46784418_1699114793_DSCF4089.webp',
      description:
          'The Lotha Tokhü Emong is a traditional post-harvest festival of thanksgiving, reconciliation, unity, and forecasting. The village chief (Pvüti) invites the leaders of the dormitories (Chümpho-ramo e) and their members to gather. The chief announces the festival dates and rituals, which are then observed by all in the village.\n\nThe main purposes of Tokhü Emong are to give thanks for the blessings of the past year, foster reconciliation and unity within the community, and forecast the coming year. This forecasting is done through rituals that include halting outdoor work, restricting outsiders, refraining from indulgence in desires, and prayer. The theme of Tokhü Emong, "SENJÜMTA", means "Reconciliation and Unity."',
    ),
    TribalFestival(
      id: 11,
      tribe: 'Phom',
      festivalName: 'Monyu Festival',
      localAsset: 'assets/images/tribes/11_phom.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FPhom.png?alt=media&token=a4a1e7a5-3fc5-4a3a-90ca-766f5a51db26',
      description:
          'The Phom Monyu festival, celebrated from April 1st to 6th, marks the end of winter and the start of the monsoon season. It is a time to pray for a bountiful harvest after sowing rice. The festival also involves socializing with family and friends, exchanging gifts, rice beer, meat, and food, and showcasing social status through traditional attire, especially by the wealthy and warriors.',
    ),
    TribalFestival(
      id: 12,
      tribe: 'Pochury',
      festivalName: 'Yemshe Festival',
      localAsset: 'assets/images/tribes/12_pochury.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FPochury.png?alt=media&token=36f3b794-ea1d-4c0f-8a84-f591c8af9296',
      description:
          'Yemshe is the festival for blessing the upcoming harvest. All the Pochuries celebrate this festival with great pomp and gaiety anticipating a good harvest. Yemshe is observed on October 5th in tune with the traditional days of the event, with sanctification rituals, merrymaking, and gift sharing.\n\nThe arrival of the festival is announced by the village elder, after which cleaning of village roads, footpaths, wells, and fields begins. Elaborate feasts are hosted, youth engage in indigenous sporting contests, and traditional songs and dances fill the morungs as blessings are invoked on both the community and crops.',
    ),
    TribalFestival(
      id: 13,
      tribe: 'Rengma',
      festivalName: 'Ngada Festival',
      localAsset: 'assets/images/tribes/13_rengma.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FRengma.png?alt=media&token=682a4c5b-b325-4c80-8db8-959e4ea052d4',
      description:
          'The Ngada festival, celebrated by the Rengmas for eight days after the harvest, is a thanksgiving and rejoicing event marking the end of the agricultural year. The village high priest (Phensengu) announces the start of the festival with a loud proclamation, signaling the villagers to prepare for the celebrations.\n\nDuring Ngada, each day holds special ritual significance: preparing rice beer and food, visiting graves of departed ancestors, performing purification rites, holding traditional feasts, and singing warrior and folk songs. The festival concludes with reconciliation, blessing of seeds, and wishing peace for all households.',
    ),
    TribalFestival(
      id: 14,
      tribe: 'Sangtam',
      festivalName: 'Mungmung Festival',
      localAsset: 'assets/images/tribes/14_sangtam.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FSangtam.png?alt=media&token=43cfb955-7a5e-4109-814a-4d4221420461',
      description:
          '"Mungmung" is one of the most important festivals of the Sangtam tribe, centered around the worship of the house deity and the three cooking stones in the fireplace. It is connected to food production, blessings, and prosperity, celebrated across six days of ritual sanctification.\n\nThe festival features unique customs including the sacrifice of animals for communal feasts, brewing of special ginger wine and rice beer, visits to in-laws and exchange of fire from the sacred morung hearth, and vibrant warrior dances that honor the brave history and unity of the Sangtam people.',
    ),
    TribalFestival(
      id: 15,
      tribe: 'Sumi',
      festivalName: 'Tuluni & Ahuna',
      localAsset: 'assets/images/tribes/15_sumi.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FSumi.png?alt=media&token=15b59c43-6183-417b-afbf-433c2166f209',
      description:
          'The Tuluni Festival is a major celebration of the Sumi Nagas in July, marking the arrival of new crops and seeking blessings for a bountiful harvest. Tulu means "grand feast" and Ni means "celebration". Spanning seven days with rituals including Asuzani, Aghizani, Ashigheni, Anighini, Mucholani, Tupulani, and Tughakhani, the festival celebrates unity, gratitude, and cultural traditions.\n\nAhuna is the premier post-harvest festival of the Sumis celebrated on November 14th, marking the successful completion of the agricultural season. Newly harvested rice is cooked inside freshly cut bamboo tubes (Ahuna), accompanied by grand warrior dances, traditional games like kick-fighting (Aki Kiti), and thanksgiving ceremonies.',
    ),
    TribalFestival(
      id: 16,
      tribe: 'Tikhir',
      festivalName: 'Tsonglak-Nyi Festival',
      localAsset: 'assets/images/tribes/16_tikhir.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FTikhir.webp?alt=media&token=b7b3f429-e6b9-4ab2-b734-bc1a1850a331',
      description:
          'Tsonglaknyi, celebrated annually from October 9–12 by the Tikhir tribe, signifies the "Sanctification of Shield." Once a festival for men during the headhunting era, it now marks preparation for the harvest and is celebrated by all with traditional rites, storytelling, and warrior dances.\n\nThe festival reinforces communal solidarity, purification of weapons and farming tools, and offering prayers for bountiful harvests and the protection of the village.',
    ),
    TribalFestival(
      id: 17,
      tribe: 'Yimkhiung',
      festivalName: 'Metümnyo Festival',
      localAsset: 'assets/images/tribes/17_yimkhiung.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FYimkhiung.png?alt=media&token=ef9d94f4-8dba-4f20-abbb-7b8d64e1b7d4',
      description:
          'Metümnyo, which translates to "Me" (Soul), "Tüm" (Ritualistic Respect) and "Nyo" (Festival), is celebrated in August by the Yimkhiung tribe. It is a solemn festival invoking blessings for a bountiful harvest and honoring the souls of newborns, departed loved ones, and ancestors.\n\nThe five-day festival is marked by cleaning the village pathways, sanctifying agricultural implements, hosting feasts of merit, arranging engagements and betrothals, and participating in rich communal dances in full warrior regalia.',
    ),
    TribalFestival(
      id: 18,
      tribe: 'Zeliang',
      festivalName: 'Chaga Gadi & Hega',
      localAsset: 'assets/images/tribes/18_zeliang.webp',
      networkUrl:
          'https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FZeliang.png?alt=media&token=8f8fbea2-6a6b-4a0e-86c8-56cba93bead3',
      description:
          'Chaga Gadi is the blessed festival of thanksgiving celebrated by the Liangmai Zeliang community in October, following the harvest. It is a season of sanctification, honoring women for their dedication to the family, seeking spiritual purification, and sharing lavish feasts.\n\nHega and Lamsimngyi are also celebrated to kindle unity, rekindle bonds between parents, married daughters, and siblings with traditional games, tug-of-war, and ceremonial folk dances invoking blessings for future prosperity.',
    ),
  ];

  void _toggleExpansion(String key) {
    setState(() {
      if (_expandedKey == key) {
        _expandedKey = null;
      } else {
        _expandedKey = key;
      }
    });
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom > 0
        ? MediaQuery.of(context).padding.bottom
        : MediaQuery.of(context).viewPadding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: AppTheme.needsBottomSafeArea(context),
        child: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Banner Image matching Festivals section tile
                SizedBox(
                  height: 250 + topInset,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/tile_festivals.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.0, -0.2),
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/festivals_top_hero.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),

                // White Rounded Body Sheet Overlapping the Banner
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, 22, 16, 120 + bottomInset),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: FirebaseService().getFestivals(),
                      builder: (context, snapshot) {
                        List<TribalFestival> festivals;
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          festivals = snapshot.data!
                              .map((doc) => TribalFestival.fromMap(doc))
                              .toList();
                          festivals.sort((a, b) => a.id.compareTo(b.id));
                        } else {
                          festivals = _defaultFestivals;
                        }
                        if (!_didInitExpansion && festivals.isNotEmpty) {
                          _expandedKey = festivals.first.uniqueKey;
                          _didInitExpansion = true;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              'Festivals of Nagaland',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Subtitle
                            Text(
                              '${festivals.length} Tribal Festivals',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Divider
                            const Divider(
                              color: Color(0xFFE2E8F0),
                              thickness: 1,
                              height: 1,
                            ),
                            const SizedBox(height: 18),

                            // Section Heading
                            const Text(
                              'Details',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Tribal Accordion Cards (Dynamic from Firestore)
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: festivals.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final festival = festivals[index];
                                final isExpanded =
                                    _expandedKey == festival.uniqueKey;
                                return _buildFestivalAccordionCard(
                                  festival: festival,
                                  isExpanded: isExpanded,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Circular Back Button
          Positioned(
            top: topInset > 0 ? topInset + 10 : 20,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleBack,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF0F172A),
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildFestivalAccordionCard({
    required TribalFestival festival,
    required bool isExpanded,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Always visible & tappable)
          InkWell(
            onTap: () => _toggleExpansion(festival.uniqueKey),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Green Numbered Badge (1..18)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF20B08D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${festival.id}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Tribe Name & Festival Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          festival.tribe,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          festival.festivalName,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Double Arrow Chevron Indicator
                  Icon(
                    isExpanded
                        ? Icons.keyboard_double_arrow_up_rounded
                        : Icons.keyboard_double_arrow_down_rounded,
                    color: const Color(0xFF475569),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content (Photo & Detailed Text)
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Festival Photo (fixed 16:10 frame prevents layout jump while loading)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: _buildFestivalPhoto(festival),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Paragraph Description
                  Text(
                    festival.description,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFestivalPhoto(TribalFestival festival) {
    final photoUrl = festival.networkUrl.trim();
    final hasRemotePhoto = photoUrl.isNotEmpty &&
        (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'));

    if (hasRemotePhoto) {
      final safeUrl = kIsWeb
          ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(photoUrl)}'
          : photoUrl;

      return CachedNetworkImage(
        imageUrl: safeUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        memCacheWidth: 800,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (_, __, ___) => _buildImageFallback(),
      );
    }

    return _buildImageFallback();
  }

  /// Production-grade greyish lazy loader skeleton (no circular spinner)
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF1F5F9),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 34,
        color: Color(0xFFCBD5E1),
      ),
    );
  }

  /// Graceful fallback when image is unavailable
  Widget _buildImageFallback() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF1F5F9),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 34,
        color: Color(0xFFCBD5E1),
      ),
    );
  }
}
