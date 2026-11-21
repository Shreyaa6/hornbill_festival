import '../models/festival.dart';
import '../models/tribe.dart';
import '../models/landmark.dart';
import '../models/stall.dart';
import '../models/event.dart';
import '../models/hotel.dart';
import '../models/taxi.dart';

class AppData {
  // Banners
  static const List<String> homeBanners = [
    "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/carousel%2F1%2Fthumbnail_1.jpg?alt=media&token=ebb7ba82-640c-4550-bf30-e2787f2dc16b",
    "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/carousel%2F2%2Fthumbnail_2.jpg?alt=media&token=6be8f3ab-4605-483b-ab40-d44e50176ec9",
  ];

  static const List<String> hornbillBanners = [
    "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/carousel%2F2%2Fthumbnail_2.jpg?alt=media&token=6be8f3ab-4605-483b-ab40-d44e50176ec9",
    "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/carousel%2F1%2Fthumbnail_1.jpg?alt=media&token=ebb7ba82-640c-4550-bf30-e2787f2dc16b",
  ];

  // 18 Festivals
  static final List<Festival> festivals = [
    Festival(
      id: 1,
      tribe: "Angami",
      name: "Sekrenyi Festival",
      dates: "February 25th",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FAngami.png?alt=media&token=f125e913-19c8-4ed3-b44e-af54921313a2",
      description: "Sekrenyi (or Phousanyi) is the main festival of the Angami Naga community, celebrated in December by Southern Angamis and in February by Western and Northern Angamis, with a common date of February 25th. It marks the beginning of the lunar year and is a time for prayer, purification, and renewal of body and soul.\n\nTraditionally, it celebrates the transition from boyhood to adulthood, especially for young men. The festival includes feasting, singing, and cultural displays, with key rituals like Kizie, Zumho, and Dzuseva for purification. Participants wear new shawls, and activities like hunting, gate-pulling, and inter-village ceremonies occur later in the festival, with villagers abstaining from agricultural work.",
    ),
    Festival(
      id: 2,
      tribe: "Ao",
      name: "Moats\u00fc Festival",
      dates: "First week of May",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FAo.png?alt=media&token=3add0a8c-e73b-47fd-a320-986298faf51b",
      description: "Moats\u00fc is an annual festival celebrated by the Ao Naga tribes of Nagaland in the first week of May. It marks the end of the sowing season and hopes for a bountiful harvest. The festival features communal feasts, traditional sports, cultural performances, and bonfires. Rituals include repairs and construction of houses by elders of the Putu Menden (Village Council), ploughing of old and new Jhum Kheti, and cleaning the Tz\u00fcbu (water wells). Moats\u00fc fosters community bonding and provides an opportunity for villagers to come together and celebrate their cultural identity.",
    ),
    Festival(
      id: 3,
      tribe: "Chakhesang",
      name: "Thuni Festival",
      dates: "January 5th",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FChakesang.png?alt=media&token=e9c9aaff-85b1-45f3-aef0-ef20b1ab4930",
      description: "Thuni is the primary festival of the Poumai Chakhesang people from the Razeba area, celebrated on January 5th each year. The name \"Thuni\" combines \"Thu\" (new) and \"ni\" (festival), symbolizing new beginnings. Rituals include pushing down a large pile of firewood (S\u00fckho) and using traditional fire-making methods (Mila) to create a bonfire, reflecting values of peace, purity, and equality.\n\nDuring the festival, couples participate in the Feast of Merit, expressing gratitude for their prosperity. They are honored with prestigious shawls like the \u201cHapidasa\u201d and \u201cSaparadu\u201d and decorate homes with traditional items such as \u201ckike\u201d and \u201chapiteh\u201d.",
    ),
    Festival(
      id: 4,
      tribe: "Chang",
      name: "Naknyul\u00fcm Festival",
      dates: "July / August",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FChang.png?alt=media&token=b97dd2a9-6b4e-4857-812a-fa73016cbaa8",
      description: "Naknyu, meaning \"Mother of Darkness,\" is a festival celebrated by the Chang people to mark the victory of light over darkness. It takes place during \"Daomao,\" when the moon is fully concealed, symbolizing six days and nights of darkness. The festival, celebrated with joy and enthusiasm, lasts for three days, each with its own significance.\n\nOn the first day, called \"Wenshi,\" women grind pearl millet into flour and make steamed biscuits, while men collect a scented plant, \"Ngounam,\" to ward off evil.\n\nThe second day, \"Youjem,\" involves sharing cooked meat and steamed biscuits, playing games like top spinning for men and box bean display for women. Women also play the bamboo flute \"Kongkin,\" and there's a meat-eating competition.\n\nThe third day, \"Nakseeng,\" concludes with clearing pavements and paths around the village, and men gather to clear the paths to the fields.",
    ),
    Festival(
      id: 5,
      tribe: "Garo",
      name: "Wangala Festival",
      dates: "Post-Harvest (November)",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FGaro.png?alt=media&token=e0353772-d8da-4f2d-a786-85fdedaf1aa5",
      description: "Wangala is a post-harvest festival celebrated by the Garo tribe of Nagaland. In this festival, they give thanks to \"Misi Saljong\", the Sun God of Fertility, for blessing the people with a rich harvest. Competitions such as Budu Sala (Tug of War), Reong Dea (stone lifting), Makal Pala (Wrestling), and Wapong Sika (Bamboo pole pushing) are also organized.\n\nParticipants wear colorful garments and feathered headgear while dancing to the rhythm of long drums (Dama).",
    ),
    Festival(
      id: 6,
      tribe: "Kachari",
      name: "Bishu Dima Festival",
      dates: "January",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKachari.png?alt=media&token=6ba5d4bb-4e3f-42e5-aeb1-0fb853386ec9",
      description: "The Bushu (or Bushu Jiba) is a post harvest festival which usually falls in the month of January after the paddy is harvested, threshed and stored. Although the exact date is not fixed, people generally celebrate it around a full moon night in January because it is believed to be auspicious.\n\nFestivities include traditional folk dances, singing, community feasts, and competitions showcasing cultural vitality and gratitude for agricultural bounty.",
    ),
    Festival(
      id: 7,
      tribe: "Khiamniungan",
      name: "Tsokum Festival",
      dates: "October",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKhiamniungan.png?alt=media&token=ff4c67ad-aeb9-4ee7-99df-cb2db92d8e40",
      description: "Tsokum is an important pre-harvest festival celebrated by the Khiamniungan tribe in October. It invokes blessings for a bountiful harvest, community prosperity, and unity among village clans through traditional rituals, folk dances, and celebratory feasts.",
    ),
    Festival(
      id: 8,
      tribe: "Konyak",
      name: "Aoleang Festival",
      dates: "April 1–6",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKonyak.png?alt=media&token=8e932375-d8cf-4876-b9b4-3a7ee2ec8fa6",
      description: "Aoleang Monyü, the ancient spring festival of the Konyak tribe, is celebrated in the first week of April to mark the end of the old year and welcome the new one. It symbolizes the arrival of spring and involves prayers for a bountiful harvest. The Konyaks, who believe they crossed a mythical gate called Alemkaphan (the gate of the sun), honor their roots and offer prayers to God for prosperity in the coming year.",
    ),
    Festival(
      id: 9,
      tribe: "Kuki",
      name: "Mim Kut & Chavang Kut",
      dates: "January / November",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FKuki.png?alt=media&token=e754f8ae-491d-4ff7-9164-a4e639d03084",
      description: "\"Mimkut\" and \"Chavang Kut\" are harvest festivals celebrated by the Kukis, featuring traditional rituals performed by village elders, vibrant bamboo folk dances (Suhta Lam), community feasts, and songs commemorating ancestral traditions.",
    ),
    Festival(
      id: 10,
      tribe: "Lotha",
      name: "Tokhü Emong",
      dates: "November 7",
      image: "https://www.morungexpress.com/uploads/2023/11/46784418_1699114793_DSCF4089.webp",
      description: "Tokhü Emong is the harvest festival of the Lothas and the entire village participates in the celebrations. Every household prepares food & drink for friends, families, neighbours that are invited to each other's house and this continues for days. The main features of the feast are community songs, dances, feast, fun and frolic.",
    ),
    Festival(
      id: 11,
      tribe: "Phom",
      name: "Monyu Festival",
      dates: "April",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FPhom.png?alt=media&token=a4a1e7a5-3fc5-4a3a-90ca-766f5a51db26",
      description: "A new-year festival, the arrival of Monyu is announced by the beating of log drums with a distinct tune traditionally called Lan Nyangshem. A feature of this festival is the men folk showing respect to their married daughters or sisters by offering them specially prepared food and rice beer - this custom reflects the high status of women in a Phom household.",
    ),
    Festival(
      id: 12,
      tribe: "Pochury",
      name: "Yemshe Festival",
      dates: "October 5",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FPochury.png?alt=media&token=36f3b794-ea1d-4c0f-8a84-f591c8af9296",
      description: "Yemshe is the festival for blessing the upcoming harvest. All the Pochuries celebrate this festival with great pomp and gaiety anticipating a good harvest. Yemshe is observed on October 05 in tune with the traditional days of the event, with sanctification rituals, merrymaking, and gift sharing.",
    ),
    Festival(
      id: 13,
      tribe: "Rengma",
      name: "Ngada Festival",
      dates: "Late November",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FRengma.png?alt=media&token=682a4c5b-b325-4c80-8db8-959e4ea052d4",
      description: "The Ngada festival, celebrated by the Rengmas for eight days after the harvest, is a thanksgiving and rejoicing event marking the end of the agricultural year. The village high priest (Phensengu) announces the start of the festival with a loud proclamation, signaling the villagers to prepare for the celebrations.",
    ),
    Festival(
      id: 14,
      tribe: "Sangtam",
      name: "Mungmung Festival",
      dates: "September",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FSangtam.png?alt=media&token=43cfb955-7a5e-4109-814a-4d4221420461",
      description: "\"Mungmung\" is one of the most important festivals of the Sangtam tribe, centered around the worship of the house deity and the three cooking stones in the fireplace. It is connected to food production, blessings, and prosperity, celebrated across six days of ritual sanctification.",
    ),
    Festival(
      id: 15,
      tribe: "Sumi",
      name: "Tuluni Festival",
      dates: "July 8",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FSumi.png?alt=media&token=15b59c43-6183-417b-afbf-433c2166f209",
      description: "The Tuluni Festival is a major celebration of the Sumi Nagas in July, marking the arrival of new crops and seeking blessings for a bountiful harvest. Tulu means \"grand fest\" and Ni means \"celebration\". Spanning seven days with rituals including Asuzani, Aghizani, Ashigheni, Anighini, Mucholani, Tupulani, and Tughakhani, the festival celebrates unity, gratitude, and cultural traditions.",
    ),
    Festival(
      id: 16,
      tribe: "Tikhir",
      name: "Tsonglaknyi Festival",
      dates: "October 9\u201312",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FTikhir.webp?alt=media&token=b7b3f429-e6b9-4ab2-b734-bc1a1850a331",
      description: "Tsonglaknyi, celebrated annually from October 9\u201312 by the Tikhir tribe, signifies the \"Sanctification of Shield.\" Once a festival for men during the headhunting era, it now marks preparation for the harvest and is celebrated by all with traditional rites, storytelling, and warrior dances.",
    ),
    Festival(
      id: 17,
      tribe: "Yimkhiung",
      name: "Met\u00fcmnyo Festival",
      dates: "August 8",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FYimkhiung.png?alt=media&token=ef9d94f4-8dba-4f20-abbb-7b8d64e1b7d4",
      description: "Met\u00fcmnyo, translates as \u201cMe\u201d - Soul, \u201cT\u00fcm\u201d - Ritualistic Respect and \u201cNyo\u201d - Festival is celebrated on August 8 by the Yimkhiungr\u00fcs, is a solemn festival invoking blessings for a bountiful harvest. It honors the souls of newborns, departed loved ones, and those expected to pass with games, feasts, reconciliation, and betrothal ceremonies.",
    ),
    Festival(
      id: 18,
      tribe: "Zeliang",
      name: "Chaga Gadi & Lamsimngyi",
      dates: "October / November",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/festivals%2FZeliang.png?alt=media&token=8f8fbea2-6a6b-4a0e-86c8-56cba93bead3",
      description: "Chaga Gadi is the Blessed Festival of Thanksgiving of the Liangmai tribe, celebrated for five days after harvest to honor women and seek purification. Lamsimngyi, celebrated by the Zeliang tribe in late October or early November, rekindles bonds between parents, married daughters, and siblings with sports, dances, and feasting.",
    ),
  ];

  // 18 Tribes
  static final List<Tribe> tribes = [
    Tribe(
      id: 1,
      name: "Angami",
      district: "Kohima / Chumoukedima",
      festival: "Sekrenyi",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Angami-11-26-2024.png?alt=media&token=c81eeeb7-40c2-487b-bb66-70e28f3224b1",
      description: "Angami Tribe is based on Kohima district. The Sekrenyi festival of the Angamis falls on the 25th day of the Angami month of Kezei. It is a celebration of purification accompanied with feasting and singing. A highlight of Sekrenyi is the Thekra Hie, when the village youths gather and croon traditional songs throughout the day.",
    ),
    Tribe(
      id: 2,
      name: "Ao",
      district: "Mokokchung",
      festival: "Moatsü & Tsüngremong",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Ao-11-26-2024.png?alt=media&token=7c77c62b-6895-4672-8822-6b9948c26f00",
      description: "Ao Tribe is based on Mokokchung district. Moatsu Mong is a bonding festival celebrated by the Ao people after the sowing season. It features vibrant singing, dancing, and the preparation of rice beer, pigs, and cows for slaughter. Women wear traditional attire and partner men in composing warrior songs, eulogizing lovers and the village. Elders encourage the youth to be bold and heroic, a tradition rooted in the community's head-hunting past.",
    ),
    Tribe(
      id: 3,
      name: "Chakhesang",
      district: "Phek",
      festival: "Sukrenye & Tsukhenyie",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Chakhesang-11-26-2024.png?alt=media&token=818b2cba-fa69-4e02-9864-16b11030995c",
      description: "Chakhesang Tribe is based on Phek district. Sukhrunye, the most important Chakhesang festival, marks the start of a new year with fasting. It lasts for eleven days, ending with the Tsupra-kuku festival. On the first morning, the village priest says Rees the first rooster, and men bathe in a sacred well, invoking blessings for strength, long life, and a good harvest. Boys and girls undergo consecration through religious rituals during the festival.",
    ),
    Tribe(
      id: 4,
      name: "Chang",
      district: "Tuensang",
      festival: "Naknyulüm",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Chang-11-13-2024.png?alt=media&token=2f631798-62a8-4ad1-bc15-0ec7012c04dc",
      description: "Chang Tribe is based on Tuensang district. Naknyulem is a bonding festival celebrated by the Chang and neighboring Naga tribes. It involves exchanging gifts, delicacies like meat, wine, and bread, and a bevy of festivities. Activities include top spinning, tug of war, high and long jumps, climbing oiled poles, and grabbling meat from bamboo ropes. Women masquerade with the kensgsem instrument.",
    ),
    Tribe(
      id: 5,
      name: "Garo",
      district: "Dimapur",
      festival: "Wangala",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Garo-11-26-2024.png?alt=media&token=9891c361-b4ef-4933-90d2-97063d891c1d",
      description: "Garo Tribe is based on Dimapur district. Wangala is a post-harvest festival celebrated by the Garo tribe of Nagaland. In this post-harvest festival, they give thanks to 'Misi Saljong', the Sun God of Fertility, for blessing the people with a rich harvest. Competitions such as Gando-Biding or Wa'a-Rong-Si-ka (Bamboo-biting), Matchu-Rong-Sika (Wrestling), Wapong-Sika (Bamboo pole-pushing) are also organized.",
    ),
    Tribe(
      id: 6,
      name: "Kachari",
      district: "Dimapur",
      festival: "Bushu Dima",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Kachari-11-26-2024.png?alt=media&token=f0147eb6-4171-419b-ab00-84c483a992e1",
      description: "Kachari Tribe is based on Dimapur district. The Bushu or Bushu Jiba is a post-harvest festival which usually falls in the month of January after the paddy is harvested, threshed and stored. Although the exact date is not fixed, people generally celebrate it around a full moon night in January because it is believed to be auspicious.",
    ),
    Tribe(
      id: 7,
      name: "Khiamniungan",
      district: "Noklak",
      festival: "Miu & Tsokum",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Khiamniungan-11-26-2024.png?alt=media&token=7c1b181b-877f-4424-9b30-b1d5e3ecde53",
      description: "Khiamniungan Tribe is based on Noklak district. A bonding festival, the main purpose of Miu is to build and reinforce relations between a maternal uncle and his nephews and nieces. The maternal uncle offers special prayers to deities for granting prosperity and power over enemies to his nephews and nieces.",
    ),
    Tribe(
      id: 8,
      name: "Konyak",
      district: "Mon",
      festival: "Aoleang Monyü",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Konyak-11-26-2024.png?alt=media&token=d1f11a88-a734-4a47-a97e-128a1ba48c5e",
      description: "Konyak Tribe is based on Mon district. Aoleang Monyu, the ancient spring festival of the Konyak tribe, is celebrated in the first week of April to mark the end of the old year and welcome the new one. It symbolizes the arrival of spring and involves prayers for a bountiful harvest. The Konyaks, who believe they are descendants of Noah and crossed a mythical gate called Alamkaphan (the gate of the sun), honor their roots and offer prayers to God for prosperity in the coming year.",
    ),
    Tribe(
      id: 9,
      name: "Kuki",
      district: "Peren",
      festival: "Mimkut",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Kuki-11-26-2024.png?alt=media&token=928dff76-844c-4608-bdc1-c4e3497a8033",
      description: "Kuki Tribe is based on Peren district. 'Mimkut' is a harvest festival celebrated by the Kukis for a week, starting on the 17th day of the Kuki month of Tolbol. The festival, which aims to appease Thilha, the demon, involves sacrifices and rituals performed by the village medicine-man (Thempu) to propitiate the spirit of the demon-god. The Kukis, who migrated from Manipur and later to Meluri near the Indo-Myanmar border, observe this festival as part of their cultural tradition.",
    ),
    Tribe(
      id: 10,
      name: "Lotha",
      district: "Wokha",
      festival: "Tokhü Emong",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Lotha-11-26-2024.png?alt=media&token=99b151d5-1057-4ffb-806b-ef60732e8aee",
      description: "Lotha Tribe is based on Wokha district. Tokhu Emong is the harvest festival of the Lothas and the entire village participates in the celebrations. Every household prepares food & drink for friends, families, neighbours that are invited to each other's house and this continues for days. The main features of the feast are community songs, dances, feast, fun and frolic.",
    ),
    Tribe(
      id: 11,
      name: "Phom",
      district: "Longleng",
      festival: "Monyü",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Phom-11-26-2024.png?alt=media&token=58d09fc1-892a-4b8d-9c62-a473575da155",
      description: "Phom Tribe is based on Longleng district. A new year festival, the arrival of Monyu is announced by the beating of log drums with a distinct tune traditionally called Lan-Nyangshem. A feature of this festival is the men folk showing respect to their married daughters or sisters by offering them specially prepared food and rice beer - this custom reflects the high status of women in a Phom household.",
    ),
    Tribe(
      id: 12,
      name: "Pochury",
      district: "Phek (Meluri)",
      festival: "Yemshe",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Pochury-11-26-2024.png?alt=media&token=52d73e69-e5a7-46d7-bad6-350fc3826cde",
      description: "Pochury Tribe is based on Phek district. Yemshe is the festival for blessing the upcoming harvest. All the Pochuries celebrate this festival with great pomp and gaiety, anticipating a good harvest. Yemshe is observed only on October 05 in tune with the traditional days of the event.",
    ),
    Tribe(
      id: 13,
      name: "Rengma",
      district: "Tseminyu",
      festival: "Ngada",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Rengma-11-26-2024.png?alt=media&token=dd49dc9c-fd42-4556-a2e9-0ff57766fd31",
      description: "Rengma Tribe is based on Tseminyu district. The Ngada festival, celebrated by the Rengmas for eight days after the harvest, is a thanksgiving and rejoicing event marking the end of the agricultural year. The village high priest (Phensengu) announces the start of the festival with a loud proclamation, signaling the villagers to prepare for the celebrations.",
    ),
    Tribe(
      id: 14,
      name: "Sangtam",
      district: "Tuensang / Kiphire",
      festival: "Mungmung",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Sangtam-11-26-2024.png?alt=media&token=725f66fc-f0a2-4c80-8928-19387bcd1e2f",
      description: "Sangtam Tribe is based on Tuensang / Kiphire district. \"Mungmung\" is one of the most important festivals of the Sangtam tribe, centered around the worship of the house deity and the three cooking stones in the fireplace. It is one of several festivals the Sangtams observe throughout the year, all connected to food production, blessings, and prosperity.",
    ),
    Tribe(
      id: 15,
      name: "Sumi",
      district: "Zunheboto",
      festival: "Tuluni & Ahuna",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Sumi-11-26-2024.png?alt=media&token=24090ea0-3f40-410a-8bf7-ba5d4eb5f159",
      description: "Sumi Tribe is based on Zunheboto district. Tuluni is a festival of great significance for the Sumi Nagas celebrated with feasts, prayers, and cultural dances.",
    ),
    Tribe(
      id: 16,
      name: "Tikhir",
      district: "Shamatore / Kiphire",
      festival: "Tsonglaknyi",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Tikhir-11-26-2024.png?alt=media&token=b7b3f429-e6b9-4ab2-b734-bc1a1850a331",
      description: "Tikhir Tribe is based on Shamator district. Tsonglaknyi is a festival of peace and friendship celebrated by the Tikhir tribe with great joy and community harmony.",
    ),
    Tribe(
      id: 17,
      name: "Yimkhiung",
      district: "Shamator",
      festival: "Metümnyo",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Yimkhiung-11-26-2024.png?alt=media&token=cfa09fe3-ce31-4122-8c1d-1959b3ec709f",
      description: "Yimkhiung Tribe is based on Shamator district. Metümneo is a festival celebrated after the harvest of millet, focused on mourning departed souls and praying for life, prosperity, and peace.",
    ),
    Tribe(
      id: 18,
      name: "Zeliang",
      district: "Peren",
      festival: "Hega & Lamsimngyi",
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/tribes%2FThe-Zeliang-11-26-2024.png?alt=media&token=8f8fbea2-6a6b-4a0e-86c8-56cba93bead3",
      description: "Zeliang Tribe is based on Peren district. Hega is the festival of the Zeliang people celebrated to invoke blessings for prosperity and happiness in the new year.",
    ),
  ];

  // Kisama Landmarks
  static final List<Landmark> landmarks = [
    Landmark(
      title: "1st Gate",
      category: "Landmark",
      latitude: 25.618436,
      longitude: 94.116641,
      photo: null,
    ),
    Landmark(
      title: "2nd Gate",
      category: "Landmark",
      latitude: 25.61836,
      longitude: 94.115316,
      photo: null,
    ),
    Landmark(
      title: "Amphitheatre",
      category: "Attraction",
      latitude: 25.614839,
      longitude: 94.114319,
      photo: null,
    ),
    Landmark(
      title: "Angami Morung",
      category: "Morung",
      latitude: 25.615884,
      longitude: 94.114359,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_eH7SyxnFO4gtFGmYbizU.jpg?alt=media&token=f00aabaa-d855-4aeb-b668-fbcac350d4ce",
    ),
    Landmark(
      title: "Ao Morung",
      category: "Morung",
      latitude: 25.615797,
      longitude: 94.113751,
      photo: null,
    ),
    Landmark(
      title: "Army Tropy Tank",
      category: "Landmark",
      latitude: 25.616844,
      longitude: 94.114623,
      photo: null,
    ),
    Landmark(
      title: "Bamboo Hall",
      category: "Attraction",
      latitude: 25.615389,
      longitude: 94.114678,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_jBqiGhuMvgD9628elj29.jpg?alt=media&token=34cedbed-8461-4239-95d0-27e93c735c62",
    ),
    Landmark(
      title: "Chakhesang Morung",
      category: "Morung",
      latitude: 25.615969,
      longitude: 94.114125,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_jRjfd8QPeLPizmTkfHAo.jpg?alt=media&token=587d5065-985c-4257-bb93-42f0d443d4b9",
    ),
    Landmark(
      title: "Chang Morung",
      category: "Morung",
      latitude: 25.615944,
      longitude: 94.113719,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_CdWbOwzAdEQ9Zm2TERuz.jpg?alt=media&token=048fadc6-9135-4929-b846-0d0b366887ed",
    ),
    Landmark(
      title: "First Aid Center",
      category: "Medical",
      latitude: 25.615847,
      longitude: 94.114972,
      photo: null,
    ),
    Landmark(
      title: "Handloom & Handicraft Pavilion",
      category: "Attraction",
      latitude: 25.617004,
      longitude: 94.114313,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_eDvozVZaULCFocv3PiT8.jpg?alt=media&token=13d6e2aa-c2c5-4d03-abc9-0a01e25ae233",
    ),
    Landmark(
      title: "Hornbill Cafe",
      category: "Landmark",
      latitude: 25.617261,
      longitude: 94.114748,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_lJVGu2Fm86fGr6FrS0C0.jpg?alt=media&token=f0a92be6-5205-40e4-8921-88ea306077c5",
    ),
    Landmark(
      title: "Hortiscape",
      category: "Attraction",
      latitude: 25.617585,
      longitude: 94.115089,
      photo: null,
    ),
    Landmark(
      title: "Khiamnuingan Morung",
      category: "Morung",
      latitude: 25.616076,
      longitude: 94.113676,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_QAstsmxZ8PcJ1jPdzbPH.jpg?alt=media&token=16cc17e7-ff38-462e-804c-b544d4fa1108",
    ),
    Landmark(
      title: "Kisama Chapel",
      category: "Attraction",
      latitude: 25.615728,
      longitude: 94.114579,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_LEV7T6FlkW9x7gjyAbcD.jpg?alt=media&token=a8daa192-8e1d-4e52-b509-5bcd2c94ae28",
    ),
    Landmark(
      title: "Konyak Morung",
      category: "Morung",
      latitude: 25.615983,
      longitude: 94.113287,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_p4952tBzaahjKJDsuzlL.jpg?alt=media&token=6fcd598f-c992-46d1-a547-6368e75b9b37",
    ),
    Landmark(
      title: "Kuki Morung",
      category: "Morung",
      latitude: 25.615687,
      longitude: 94.114502,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_9j4wM8TpPgqB2j8JxcWR.jpg?alt=media&token=d48a4518-cbfe-4d05-a894-feadf5ac70d5",
    ),
    Landmark(
      title: "Legislatures Park",
      category: "Landmark",
      latitude: 25.61538,
      longitude: 94.112903,
      photo: null,
    ),
    Landmark(
      title: "Lotha Morung",
      category: "Morung",
      latitude: 25.615767,
      longitude: 94.11403,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_ERpSPs2dq0WACToM38NW.jpg?alt=media&token=75b6d023-f3c4-425e-a209-848645e31750",
    ),
    Landmark(
      title: "Nagaland Tourism Information Center",
      category: "Landmark",
      latitude: 25.615534,
      longitude: 94.113932,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_OHvLXsT78MLBIB6gyERb.jpg?alt=media&token=c6826763-f96d-4d09-9d73-06bd8f6b1560",
    ),
    Landmark(
      title: "Parking",
      category: "Landmark",
      latitude: 25.618127,
      longitude: 94.115693,
      photo: null,
    ),
    Landmark(
      title: "Phom Morung",
      category: "Morung",
      latitude: 25.615856,
      longitude: 94.113532,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_gtMMuRn6lVhCDXEbKCo0.jpg?alt=media&token=a965be47-55cc-483e-89bf-3c6474bc692d",
    ),
    Landmark(
      title: "Pochury Morung",
      category: "Morung",
      latitude: 25.616115,
      longitude: 94.113977,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_jgIOooW4FD1oqFe28ofM.jpg?alt=media&token=1f0569f0-46c8-4d01-be26-237dd9ec4e9b",
    ),
    Landmark(
      title: "Rengma Morung",
      category: "Morung",
      latitude: 25.615812,
      longitude: 94.114175,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_kArm2Y1Rcgy9JdKn3tlk.jpg?alt=media&token=b44cd2e6-9693-4b0a-ac69-fe579f8dffb5",
    ),
    Landmark(
      title: "Sangtam Morung",
      category: "Morung",
      latitude: 25.616057,
      longitude: 94.113812,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_FXcJruZfqDgk3lqZpu02.jpg?alt=media&token=93bf9aa7-a5a3-4506-8310-7bfeffed34a8",
    ),
    Landmark(
      title: "Sumi Morung",
      category: "Morung",
      latitude: 25.615921,
      longitude: 94.113968,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_StDsoUOyVSPU3pEihNFS.jpg?alt=media&token=a1136d15-b8b8-4504-8e9a-bf6ebeba45f3",
    ),
    Landmark(
      title: "TAFMA Lounge and D Caf\u00e9",
      category: "Landmark",
      latitude: 25.615489,
      longitude: 94.11483,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_YPYkMlcuqmLtUGwkgb9z.jpg?alt=media&token=fcddf0d1-fc52-45ff-aeb4-7cfcab1f8201",
    ),
    Landmark(
      title: "Tourist Information Center",
      category: "Landmark",
      latitude: 25.616851,
      longitude: 94.114876,
      photo: null,
    ),
    Landmark(
      title: "World War 2 Museum",
      category: "Attraction",
      latitude: 25.616128,
      longitude: 94.115365,
      photo: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_BJJik3mDgDodNfH5RNyi.jpg?alt=media&token=007ca3e1-6b4c-4585-89b8-3d9f4e516ee9",
    ),
  ];

  // Kisama Stalls
  static final List<Stall> stalls = [
    Stall(
      stallName: "Lotha Cuisine",
      owner: "Lotha Cuisine",
      phone: "8132016038",
    ),
    Stall(
      stallName: "Akhrienuo's Corner",
      owner: "Akhrienuo",
      phone: "8794366251",
    ),
    Stall(
      stallName: "Tsurangkong Women Society",
      owner: "Tsurangkong Women Society",
      phone: "9612133060",
    ),
    Stall(
      stallName: "Ao Fusion",
      owner: "Ao Fusion",
      phone: "8974267179",
    ),
    Stall(
      stallName: "Naga Bazar Disabled Organization",
      owner: "Naga Bazar Disabled Organization",
      phone: "9089342340",
    ),
    Stall(
      stallName: "NH Epic Snacks And Beverages",
      owner: "NH Epic Snacks And Beverages",
      phone: "7005713894",
    ),
    Stall(
      stallName: "Heritage Bites",
      owner: "Megosatuo",
      phone: "9863325279",
    ),
    Stall(
      stallName: "Exotic Party",
      owner: "Exotic Party",
      phone: "8787733738",
    ),
    Stall(
      stallName: "ENCSU",
      owner: "Mankap Konyak",
      phone: "6009648109",
    ),
    Stall(
      stallName: "The Red Kafe",
      owner: "The Red Kafe",
      phone: "8787543287",
    ),
    Stall(
      stallName: "Luxe Resto. (New Sect. Area)",
      owner: "Phyobemo",
      phone: "8837020583",
    ),
    Stall(
      stallName: "Creative Concept SHG",
      owner: "Creative Concept SHG",
      phone: "8837246700",
    ),
    Stall(
      stallName: "Variety Food",
      owner: "Variety Food",
      phone: "8119022360",
    ),
    Stall(
      stallName: "Vivoto Kulnu",
      owner: "Vivoto Kulnu",
      phone: "8787328417",
    ),
    Stall(
      stallName: "Variety Food",
      owner: "Variety Food",
      phone: "8119022360",
    ),
    Stall(
      stallName: "Nchumpthung. P. Kikon",
      owner: "Nchumpthung. P. Kikon",
      phone: "9366375050",
    ),
    Stall(
      stallName: "Molung Ajem SHG",
      owner: "Molung Ajem SHG",
      phone: "9089262252",
    ),
    Stall(
      stallName: "Nana\u2019s Kitchen",
      owner: "Nana Kitchen",
      phone: "8730894235",
    ),
    Stall(
      stallName: "Angami Thutse",
      owner: "Angami Thutse",
      phone: "8730084980",
    ),
    Stall(
      stallName: "The Morung Kitchen",
      owner: "The Morung Kitchen",
      phone: "8119011720",
    ),
    Stall(
      stallName: "Chale\u2019s Stall",
      owner: "Seyiekhrilielie Chale",
      phone: "9862030362",
    ),
    Stall(
      stallName: "Longmatra Delicacy",
      owner: "T. Litingse Sangtam",
      phone: "7005638053",
    ),
    Stall(
      stallName: "The Naga Den",
      owner: "Team Edible Adventure",
      phone: "8729938272",
    ),
    Stall(
      stallName: "Luva Ba",
      owner: "Mughaka Yeptho / Eunoia",
      phone: "9402879186",
    ),
    Stall(
      stallName: "Anuka Aye",
      owner: "Anuka Aye",
      phone: "9856882454",
    ),
    Stall(
      stallName: "Naga Indian Stall",
      owner: "Naga Indian Stall",
      phone: "8974343289",
    ),
    Stall(
      stallName: "Viphrezonuo Solo",
      owner: "Viphrezonuo Solo",
      phone: "9856278191",
    ),
  ];

  // Hornbill Festival 10-Day Timeline Schedule
  static final List<FestivalDay> hornbillDays = [
    FestivalDay(
      day: 1,
      date: "Dec 1, 2024",
      title: "Inaugural Day - The Festival of Festivals",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day1.pdf",
      events: [
        TimelineEvent(time: "09:30 AM", title: "Arrival of Dignitaries & Tribal Elders", description: "Grand traditional welcome and gathering at the Main Arena, Kisama Heritage Village.", icon: "flag"),
        TimelineEvent(time: "10:00 AM", title: "Inaugural Ceremony & Lighting of Traditional Fire", description: "Blessing invocation by Naga tribal priest and lighting of the sacred fire at the main hearth.", icon: "fire"),
        TimelineEvent(time: "11:30 AM", title: "Colours of Nagaland: Grand Cultural Symphony", description: "Simultaneous rhythmic cultural presentation by all 18 recognized indigenous tribes of Nagaland.", icon: "music"),
        TimelineEvent(time: "01:00 PM", title: "Opening of Morungs & Tribal Kitchens", description: "Traditional feasting and community interaction across all tribal morungs.", icon: "food"),
        TimelineEvent(time: "05:00 PM", title: "Hornbill Music Festival Opening Act", description: "Rock and folk fusion performances at the Main Amphitheatre.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 2,
      date: "Dec 2, 2024",
      title: "Cultural Extravaganza & Warrior Dances",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day2.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Morning Cultural Performances", description: "Traditional war dances, harvest celebrations and victory songs by Southern tribes.", icon: "music"),
        TimelineEvent(time: "12:00 PM", title: "Indigenous Crafts & Handloom Exhibition", description: "Demonstrations by master wood-carvers, weavers, and spear-makers at Bamboo Hall.", icon: "craft"),
        TimelineEvent(time: "02:00 PM", title: "Afternoon Cultural Troupe Exchange", description: "Folk theater and storytelling around tribal history and folklore.", icon: "music"),
        TimelineEvent(time: "06:00 PM", title: "Kohima Night Bazaar Inauguration", description: "Food stalls, live music, and festive shopping along the historic Kohima town stretch.", icon: "food"),
      ],
    ),
    FestivalDay(
      day: 3,
      date: "Dec 3, 2024",
      title: "Indigenous Sports & Naga Wrestling",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day3.pdf",
      events: [
        TimelineEvent(time: "09:30 AM", title: "Traditional Naga Wrestling Championship", description: "Thrilling belt wrestling competition featuring top wrestlers from across the state.", icon: "trophy"),
        TimelineEvent(time: "11:30 AM", title: "Greased Bamboo Pole Climbing", description: "Exciting physical challenge of endurance and technique on a 30-foot oiled bamboo pole.", icon: "trophy"),
        TimelineEvent(time: "02:00 PM", title: "Traditional Archery & Catapult Contest", description: "Ancient archery skills using bamboo bows and targeted shooting competitions.", icon: "target"),
        TimelineEvent(time: "05:30 PM", title: "Acoustic Sunset Concert", description: "Unplugged traditional folk and gospel music at the Amphitheatre.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 4,
      date: "Dec 4, 2024",
      title: "Hornbill Chef & Chilli Eating Championship",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day4.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Master Chef Nagaland: Indigenous Cuisines", description: "Cooking competition featuring smoked meats, bamboo shoot, fermented beans and fresh herbs.", icon: "food"),
        TimelineEvent(time: "01:00 PM", title: "Naga King Chilli Eating Competition", description: "World-famous competition testing brave contestants with the fiery Bhut Jolokia (Raja Mircha).", icon: "fire"),
        TimelineEvent(time: "02:30 PM", title: "Pork Fat Eating Challenge", description: "Traditional culinary endurance contest celebrated with good humor and cheers.", icon: "food"),
        TimelineEvent(time: "06:00 PM", title: "Tribal Night Concert", description: "High-energy performances by celebrated regional bands and artists.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 5,
      date: "Dec 5, 2024",
      title: "Horticulture, Floriculture & Honey Festival",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day5.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Nagaland Honey & Organic Produce Fair", description: "Showcasing rare stingless bee honey, wild forest produce, and fresh agricultural bounties.", icon: "flower"),
        TimelineEvent(time: "11:30 AM", title: "Hortiscape Floral Show & Bonsai Display", description: "Exotic orchids and native wildflowers exhibition at the Hortiscape pavilion.", icon: "flower"),
        TimelineEvent(time: "02:00 PM", title: "Cultural Songs & Log Drum Demonstration", description: "Deep resonant rhythmic log drumming by Eastern Naga tribes at their morungs.", icon: "music"),
        TimelineEvent(time: "06:00 PM", title: "Hornbill International Rock Contest: Semi-Finals", description: "Bands from across the world compete in one of Asia’s biggest rock contests.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 6,
      date: "Dec 6, 2024",
      title: "Tribal Unity & Youth Cultural Exchange",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day6.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Inter-Tribal Folk Dance Exchange", description: "Collaborative performances between neighbouring tribes celebrating peace and fellowship.", icon: "music"),
        TimelineEvent(time: "01:00 PM", title: "Traditional Fire Making Contest", description: "Ancient fire making using bamboo thongs and wood friction techniques.", icon: "fire"),
        TimelineEvent(time: "03:00 PM", title: "Cultural Attire & Heritage Fashion Show", description: "Authentic traditional shawls, warrior ornaments, and woven textiles showcase.", icon: "cloth"),
        TimelineEvent(time: "06:30 PM", title: "Night Music Extravaganza", description: "EDM and contemporary indie fusion at the Amphitheatre.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 7,
      date: "Dec 7, 2024",
      title: "Heritage Crafts & World War II Commemoration",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day7.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "WWII Memorial Peace Rally & Exhibition", description: "Historic military vehicles display and memorial walk honoring the Battle of Kohima.", icon: "shield"),
        TimelineEvent(time: "11:30 AM", title: "Master Weavers of Nagaland Live Demo", description: "Back-strap loom weaving and natural dyeing workshops.", icon: "craft"),
        TimelineEvent(time: "02:00 PM", title: "Stone Lifting & Shot Put (Traditional)", description: "Heavy boulder lifting test of raw strength in the arena.", icon: "trophy"),
        TimelineEvent(time: "06:00 PM", title: "Voice of Hornbill Solo Singing Finals", description: "Top vocalists perform gospel, folk, and classical pieces.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 8,
      date: "Dec 8, 2024",
      title: "Eco-Tourism & Adventure Trail Day",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day8.pdf",
      events: [
        TimelineEvent(time: "08:00 AM", title: "Hornbill Mountain Biking & Trail Run", description: "Cross-country adventure race through the forested hills surrounding Kisama and Kigwema.", icon: "bike"),
        TimelineEvent(time: "10:30 AM", title: "Indigenous Board Games & Top Spinning", description: "Traditional childhood games played with hardwood tops and bamboo strings.", icon: "play"),
        TimelineEvent(time: "01:30 PM", title: "Tribal Choral Festival", description: "Four-part harmony church choirs delivering breathtaking acoustic anthems.", icon: "music"),
        TimelineEvent(time: "06:00 PM", title: "Hornbill Rock Championship: Grand Finale", description: "Top 5 rock bands battle for the ultimate crown and championship trophy.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 9,
      date: "Dec 9, 2024",
      title: "Statehood Celebration & Folk Music Fusion",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day9.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Ceremonial Parade & Folk Dance Medley", description: "Special presentations marking the spirit of Nagaland Statehood.", icon: "flag"),
        TimelineEvent(time: "12:00 PM", title: "Naga Master Storytellers Circle", description: "Folk tales, ancestor chronicles, and moral stories recounted by village council chiefs.", icon: "book"),
        TimelineEvent(time: "02:30 PM", title: "Praise & Thanksgiving Cultural Service", description: "Blessing songs and community thanksgiving in each Morung.", icon: "music"),
        TimelineEvent(time: "06:00 PM", title: "Gala Night of Naga Musical Legends", description: "Honoring veteran Naga folk musicians and contemporary recording stars.", icon: "music"),
      ],
    ),
    FestivalDay(
      day: 10,
      date: "Dec 10, 2024",
      title: "Grand Finale - Unity Dance Around the Bonfire",
      pdfUrl: "https://docs.google.com/gview?embedded=true&url=https://hornbill-nagaland.appspot.com/day10.pdf",
      events: [
        TimelineEvent(time: "10:00 AM", title: "Final Cultural Showcase: Best of the Hornbill", description: "Encore performances by the most celebrated tribal troupes of the festival.", icon: "trophy"),
        TimelineEvent(time: "02:00 PM", title: "Photo Contest & Handicraft Awards Ceremony", description: "Honoring prize winners of the Hornbill Photo Contest 2025 and artisan guilds.", icon: "trophy"),
        TimelineEvent(time: "04:30 PM", title: "Closing Ceremony & Valedictory Addresses", description: "Official addresses by state dignitaries, guests of honor, and tribal council leaders.", icon: "flag"),
        TimelineEvent(time: "06:00 PM", title: "The Great Hornbill Bonfire & Unity Dance", description: "Thousands of participants and visitors join hands for the grand unity dance around the roaring bonfire.", icon: "fire"),
        TimelineEvent(time: "08:00 PM", title: "Grand Fireworks Spectacular & Farewell", description: "Breathtaking fireworks light up the Kisama night sky to close the 26th Hornbill Festival.", icon: "star"),
      ],
    ),
  ];

  // Emergency Services
  static const List<Map<String, dynamic>> policeStations = [
    {
      "district": "Kohima",
      "stations": [
        {"name": "North Police Station", "officer": "Chumdemo Odyuo", "phone": "03702222911"},
        {"name": "South Police Station", "officer": "Mulekhoyi C.", "phone": "03702222111"},
        {"name": "Women Police Station", "officer": "Dziesengunuo Bio", "phone": "03702244222"},
        {"name": "Police Control Room", "officer": "On-duty Officer", "phone": "100"},
      ]
    },
    {
      "district": "Dimapur",
      "stations": [
        {"name": "East Police Station", "officer": "Bendangwati", "phone": "03862227633"},
        {"name": "West Police Station", "officer": "L. Yanthithung", "phone": "03862232840"},
        {"name": "Women Police Station", "officer": "Tingbem Thomsong", "phone": "03862228800"},
        {"name": "Police Control Room", "officer": "On-duty Officer", "phone": "112"},
      ]
    }
  ];

  static const List<Map<String, String>> hospitals = [
    {"name": "Naga Hospital Authority (NHAK)", "address": "Hospital Colony, Kohima", "phone": "03702222464"},
    {"name": "Oking Hospital", "address": "Phulbari, Opp. to Bandhan Bank, Kohima", "phone": "03702243341"},
    {"name": "Kohimas Hospital", "address": "Naga Bazaar, Kohima", "phone": "03702222888"},
    {"name": "Faith Hospital", "address": "Old Sewak Road, Dhobinullah, Dimapur", "phone": "03862224155"},
    {"name": "Nikos Hospital", "address": "Midland, Dimapur", "phone": "03862248555"},
    {"name": "Eden Medical Centre", "address": "Near Sub Jail, Oriental Colony, Dimapur", "phone": "03862244100"},
    {"name": "Zion Hospital", "address": "Purana Bazar, Dimapur", "phone": "03862231864"},
  ];

  static const List<Map<String, String>> touristPolice = [
    {"name": "Tourist Police Central Helpline", "location": "Kisama Heritage Village & Kohima HQ", "phone": "112"},
    {"name": "Tourist Assistance Booth - Kisama Gate 1", "location": "Kisama Heritage Village Entrance", "phone": "+918730999112"},
    {"name": "Tourist Police Dimapur Desk", "location": "Dimapur Railway Station & Airport", "phone": "+918730999113"},
  ];

  // Hotels and Homestays
  static final List<Hotel> hotels = [
    Hotel(
      id: "h1",
      name: "Niathu Resort",
      type: "Resort",
      district: "Chumoukedima",
      address: "7th Mile, Chumoukedima, Nagaland",
      rating: 4.8,
      price: 6500,
      strikethroughPrice: 8500,
      image: "https://lh3.googleusercontent.com/p/AF1QipMncVGb9YoyZyNKUDgld3nKA043vuAQeMF46Zh5=s1360-w1360-h1020",
      phone: "+913862240999",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "Pool", "AC Rooms", "24x7 Power", "Parking", "Fridge"],
    ),
    Hotel(
      id: "h2",
      name: "Hotel Vivor",
      type: "Hotel",
      district: "Kohima",
      address: "Near High Court Junction, Kohima",
      rating: 4.6,
      price: 4500,
      strikethroughPrice: 5800,
      image: "https://lh3.googleusercontent.com/p/AF1QipO2bv-5Ta8S3DFjMsXT1zRQJYGJ24Ine_qMRmFB=s1360-w1360-h1020-rw",
      phone: "+913702806588",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "AC Rooms", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "h3",
      name: "Dzuleke Eco Homestay",
      type: "Homestay",
      district: "Kohima",
      address: "Dzuleke Village, 40 km from Kohima",
      rating: 4.9,
      price: 2200,
      strikethroughPrice: 2800,
      image: "https://s7ap1.scene7.com/is/image/incredibleindia/dzukou-valley-kohima-nagaland-attr-hero-1?qlt=82&ts=1726671043746",
      phone: "+919862998877",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "h4",
      name: "Hotel Japfu",
      type: "Hotel",
      district: "Kohima",
      address: "PR Hill, Kohima, Nagaland",
      rating: 4.2,
      price: 3200,
      strikethroughPrice: 4000,
      image: "https://img.traveltriangle.com/blog/wp-content/uploads/2019/12/cover-places-to-visit-in-kohima.jpg",
      phone: "+913702240211",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "h5",
      name: "Kisama Green Homestay",
      type: "Homestay",
      district: "Kohima",
      address: "Near Kisama Heritage Gate, Kigwema",
      rating: 4.7,
      price: 2500,
      strikethroughPrice: 3500,
      image: "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_eH7SyxnFO4gtFGmYbizU.jpg?alt=media&token=f00aabaa-d855-4aeb-b668-fbcac350d4ce",
      phone: "+918730991122",
      isFeatured: true,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "24x7 Power", "Parking"],
    ),
    Hotel(
      id: "h6",
      name: "Dimapur Grand Guest House",
      type: "Guest House",
      district: "Dimapur",
      address: "Circular Road, Dimapur",
      rating: 4.3,
      price: 1800,
      strikethroughPrice: 2400,
      image: "https://im.hunt.in/cg/Dimapur/City-Guide/ruins.jpg",
      phone: "+913862224411",
      isFeatured: false,
      roomsAvailable: true,
      facilities: ["Free Wifi", "Fooding", "AC Rooms", "Parking"],
    ),
  ];

  // Taxis
  static final List<Taxi> taxis = [
    Taxi(
      id: "t1",
      driverName: "Kevichusa Angami",
      vehicleName: "Toyota Innova Crysta",
      vehicleType: "SUV / 7 Seater",
      district: "Kohima",
      phone: "+919862112233",
      rating: 4.9,
      price: "₹3,500 / day",
      servingDistricts: ["Kohima", "Dimapur / Chümoukedima", "Wokha", "Phek"],
    ),
    Taxi(
      id: "t2",
      driverName: "Imtisunep Ao",
      vehicleName: "Mahindra Scorpio 4x4",
      vehicleType: "SUV / 4WD",
      district: "Dimapur",
      phone: "+919436123456",
      rating: 4.8,
      price: "₹3,800 / day",
      servingDistricts: ["Dimapur / Chümoukedima", "Kohima", "Mokokchung", "Wokha", "Mon"],
    ),
    Taxi(
      id: "t3",
      driverName: "Vituolie Solo",
      vehicleName: "Maruti Suzuki Swift Dzire",
      vehicleType: "Sedan / AC",
      district: "Kohima",
      phone: "+918730889900",
      rating: 4.7,
      price: "₹2,400 / day",
      servingDistricts: ["Kohima", "Dimapur / Chümoukedima"],
    ),
    Taxi(
      id: "t4",
      driverName: "Renbomo Lotha",
      vehicleName: "Mahindra Bolero",
      vehicleType: "SUV / Rugged Terrain",
      district: "Wokha",
      phone: "+919862776655",
      rating: 4.6,
      price: "₹2,800 / day",
      servingDistricts: ["Wokha", "Kohima", "Mokokchung", "Zünheboto"],
    ),
  ];

  // Cafes & Food
  static final List<Map<String, dynamic>> cafes = [
    {
      "name": "The Morung Kitchen",
      "district": "Kohima",
      "location": "Near Kisama Village Entrance",
      "isNagaDishes": true,
      "rating": 4.8,
      "phone": "+918119011720",
      "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_YPYkMlcuqmLtUGwkgb9z.jpg?alt=media&token=fcddf0d1-fc52-45ff-aeb4-7cfcab1f8201",
      "description": "Authentic smoked pork with fermented bamboo shoot, Axone rice, spicy chutneys, and wild herb soups.",
    },
    {
      "name": "TAFMA Lounge & D Café",
      "district": "Kohima",
      "location": "Kisama Heritage Complex",
      "isNagaDishes": false,
      "rating": 4.7,
      "phone": "+918730084980",
      "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_jBqiGhuMvgD9628elj29.jpg?alt=media&token=34cedbed-8461-4239-95d0-27e93c735c62",
      "description": "Artisan roasted coffees, Naga cinnamon lattes, baked goods, pizzas, and live acoustic music sessions.",
    },
    {
      "name": "Heritage Bites",
      "district": "Kohima",
      "location": "Main Arena, Kisama",
      "isNagaDishes": true,
      "rating": 4.6,
      "phone": "+919863325279",
      "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_FXcJruZfqDgk3lqZpu02.jpg?alt=media&token=93bf9aa7-a5a3-4506-8310-7bfeffed34a8",
      "description": "Traditional roasted delicacies, local rice beer (Zutho), wild apple candies, and spicy momos.",
    },
  ];

  // Tour Operators & Tour Guides
  static final List<Map<String, dynamic>> tourGuides = [
    {
      "name": "Thepfuvilie Seyie",
      "district": "Kohima",
      "phone": "+919862001122",
      "languages": "English, Nagamese, Angami",
      "experience": "8 Years",
      "rating": 4.9,
      "specialty": "Dzukou Valley Treks & Kisama Heritage",
    },
    {
      "name": "Arenla Pongen",
      "district": "Mokokchung",
      "phone": "+919436882233",
      "languages": "English, Hindi, Ao, Nagamese",
      "experience": "6 Years",
      "rating": 4.8,
      "specialty": "Tribal Villages & Weaving Tours",
    },
    {
      "name": "Hokato Sumi",
      "district": "Zunheboto",
      "phone": "+918730776611",
      "languages": "English, Nagamese, Sumi",
      "experience": "10 Years",
      "rating": 4.9,
      "specialty": "Wildlife, Mount Saramati & Birdwatching",
    },
  ];

  // Notifications
  static final List<Map<String, String>> notifications = [
    {
      "title": "Welcome to the 26th Hornbill Festival",
      "date": "Nov 25, 2024",
      "body": "The 26th edition of the Hornbill Festival commences from December 1st at Kisama Heritage Village. Please carry your valid Inner Line Permit (ILP) or digital pass for hassle-free entry.",
    },
    {
      "title": "Hornbill Photo Contest 2025 Submissions Open",
      "date": "Nov 20, 2024",
      "body": "Submit your best festival photography. Grand cash prizes and citations to be awarded on the final day. Note: AI generated and irrelevant photos will be disqualified.",
    },
    {
      "title": "Special Shuttle Bus Services Announced",
      "date": "Nov 18, 2024",
      "body": "Regular NST shuttle buses will operate every 30 minutes from Kohima Phoolbari and Dimapur Railway Station directly to Kisama Heritage Village.",
    },
  ];

  // Districts & Attractions
  static final Map<String, Map<String, dynamic>> districtDetails = {
    "Kohima": {
      "title": "Kohima - The Capital City",
      "image": "https://img.traveltriangle.com/blog/wp-content/uploads/2019/12/cover-places-to-visit-in-kohima.jpg",
      "description": "Kohima is the scenic hilltop capital of Nagaland, celebrated for its rich history, the Battle of Kohima Memorial, and as the host of the iconic Hornbill Festival.",
      "places": [
        {
          "name": "Dzukou Valley",
          "image": "https://s7ap1.scene7.com/is/image/incredibleindia/dzukou-valley-kohima-nagaland-attr-hero-1?qlt=82&ts=1726671043746",
          "description": "Located at an elevation of 2,452 meters above sea level, Dzukou Valley sits on the border between Nagaland and Manipur. Celebrated for its seasonal floral carpets and serene green landscapes."
        },
        {
          "name": "Kisama Heritage Village",
          "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/landmark%2Fphoto_eH7SyxnFO4gtFGmYbizU.jpg?alt=media&token=f00aabaa-d855-4aeb-b668-fbcac350d4ce",
          "description": "Kisama Heritage Village is located on the scenic slopes between Kigwema and Phesama villages. Established to protect and highlight the vibrant cultural legacy of the Naga tribes, it serves as the home of the annual Hornbill Festival."
        },
        {
          "name": "Kohima War Cemetery",
          "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/destinations%2FKHONOMA%201.jpg?alt=media&token=db2a9a47-cf42-4f36-9b57-6902264cb851",
          "description": "The Kohima War Cemetery in Nagaland, India, is a solemn memorial dedicated to soldiers who fought in World War II during the decisive Battle of Kohima in 1944."
        },
        {
          "name": "Khonoma Green Village",
          "image": "https://s7ap1.scene7.com/is/image/incredibleindia/dzukou-valley-kohima-nagaland-attr-hero-1?qlt=82&ts=1726671043746",
          "description": "Known as Asia’s first Green Village for its community-led conservation efforts in wildlife and ecological stewardship."
        },
      ]
    },
    "Dimapur": {
      "title": "Dimapur - The Gateway City",
      "image": "https://im.hunt.in/cg/Dimapur/City-Guide/ruins.jpg",
      "description": "The commercial hub of Nagaland, Dimapur features historical relics of the Kachari Kingdom and serves as the main transit gateway with airport and railway connectivity.",
      "places": [
        {
          "name": "Kachari Ruins",
          "image": "https://im.hunt.in/cg/Dimapur/City-Guide/ruins.jpg",
          "description": "Ancient 10th-century mushroom-domed monolith pillars and brick gate ruins of the Kachari civilization."
        },
        {
          "name": "Green Park Dimapur",
          "image": "https://im.hunt.in/cg/Dimapur/City-Guide/ruins.jpg",
          "description": "Green Park Dimapur is a fantastic recreational destination located just 5 km from the main city, offering boating, ziplining, and scenic lawns."
        },
        {
          "name": "Diezephe Craft Village",
          "image": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhAm94e4YeIpinq9htxywQ7HXwa1ELNLFh_S9suGBx2dghkKOKdCHoBR6YuY_PtrpVcKdarIRgUarx1p-2mTUD0Q2t6IYNKsJn1fCOaIr1GL6yHaDT2GSp8As5avabZfO48WhK4uG9eJ34/w1200-h630-p-k-no-nu/DSC_0058.JPG",
          "description": "A premier arts and craft enclave dedicated to traditional woodcarving, cane work, and handloom weaving."
        }
      ]
    },
    "Chumoukedima": {
      "title": "Chümoukedima - Hill & Eco Retreat",
      "image": "https://lh3.googleusercontent.com/p/AF1QipMncVGb9YoyZyNKUDgld3nKA043vuAQeMF46Zh5=s1360-w1360-h1020",
      "description": "Nestled along the foothills, Chümoukedima boasts cascading waterfalls, luxury resorts, and verdant hillside walking paths.",
      "places": [
        {
          "name": "Triple Falls",
          "image": "https://lh3.googleusercontent.com/p/AF1QipMncVGb9YoyZyNKUDgld3nKA043vuAQeMF46Zh5=s1360-w1360-h1020",
          "description": "Situated in Seithekima Village, the stunning Triple Falls showcases three beautiful streams converging into a tranquil natural basin."
        },
        {
          "name": "Chümoukedima Tourist Village",
          "image": "https://lh3.googleusercontent.com/p/AF1QipMncVGb9YoyZyNKUDgld3nKA043vuAQeMF46Zh5=s1360-w1360-h1020",
          "description": "Perched on a high ridge overlooking the Dimapur plains, offering magnificent sunsets and fresh mountain breezes."
        }
      ]
    },
    "Wokha": {
      "title": "Wokha - Land of the Amur Falcon",
      "image": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhAm94e4YeIpinq9htxywQ7HXwa1ELNLFh_S9suGBx2dghkKOKdCHoBR6YuY_PtrpVcKdarIRgUarx1p-2mTUD0Q2t6IYNKsJn1fCOaIr1GL6yHaDT2GSp8As5avabZfO48WhK4uG9eJ34/w1200-h630-p-k-no-nu/DSC_0058.JPG",
      "description": "Home of the Lotha tribe and globally renowned as the Falcon Capital of the World, where millions of Amur Falcons roost around the Doyang Reservoir.",
      "places": [
        {
          "name": "Doyang River Reservoir",
          "image": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhAm94e4YeIpinq9htxywQ7HXwa1ELNLFh_S9suGBx2dghkKOKdCHoBR6YuY_PtrpVcKdarIRgUarx1p-2mTUD0Q2t6IYNKsJn1fCOaIr1GL6yHaDT2GSp8As5avabZfO48WhK4uG9eJ34/w1200-h630-p-k-no-nu/DSC_0058.JPG",
          "description": "A breathtaking expanse of water surrounded by lush rolling hills, offering boating, birdwatching, and camping."
        },
        {
          "name": "Totsu Cliff",
          "image": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhAm94e4YeIpinq9htxywQ7HXwa1ELNLFh_S9suGBx2dghkKOKdCHoBR6YuY_PtrpVcKdarIRgUarx1p-2mTUD0Q2t6IYNKsJn1fCOaIr1GL6yHaDT2GSp8As5avabZfO48WhK4uG9eJ34/w1200-h630-p-k-no-nu/DSC_0058.JPG",
          "description": "Dramatic rocky precipice renowned in Lotha legends for its commanding panorama of the surrounding valleys."
        }
      ]
    },
    "Zunheboto": {
      "title": "Zünheboto - Land of the Martial Sumis",
      "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/destinations%2Fzunheboto.jpg?alt=media&token=6a76c9ae-2385-4494-ba2b-d7de70c7db8e",
      "description": "Perched on rolling central hills, Zünheboto is the cultural heartland of the Sumi Nagas and home to Asia's largest church building.",
      "places": [
        {
          "name": "Sumi Baptist Church (SBCZ)",
          "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/destinations%2Fzunheboto.jpg?alt=media&token=6a76c9ae-2385-4494-ba2b-d7de70c7db8e",
          "description": "One of the largest churches in Asia, situated at an elevation of 1,865 meters on a hilltop, accommodating over 8,500 people."
        },
        {
          "name": "Satoi Range",
          "image": "https://firebasestorage.googleapis.com/v0/b/hornbill-nagaland.appspot.com/o/destinations%2Fzunheboto.jpg?alt=media&token=6a76c9ae-2385-4494-ba2b-d7de70c7db8e",
          "description": "One of the last virgin forests in the district, harboring rare Blyth's tragopans and endemic rhododendron species."
        }
      ]
    },
    "Kiphire": {
      "title": "Kiphire - Land of Mount Saramati",
      "image": "https://lh3.googleusercontent.com/p/AF1QipO2bv-5Ta8S3DFjMsXT1zRQJYGJ24Ine_qMRmFB=s1360-w1360-h1020-rw",
      "description": "Dominated by the snow-capped peak of Mount Saramati on the Indo-Myanmar border, Kiphire offers pristine high-altitude nature and limestone caves.",
      "places": [
        {
          "name": "Mount Saramati",
          "image": "https://lh3.googleusercontent.com/p/AF1QipO2bv-5Ta8S3DFjMsXT1zRQJYGJ24Ine_qMRmFB=s1360-w1360-h1020-rw",
          "description": "Nagaland's highest peak at 3,841 meters, snow-covered in winter and renowned as a trekker’s paradise."
        },
        {
          "name": "Caves of Salomi & Mimi",
          "image": "https://lh3.googleusercontent.com/p/AF1QipO2bv-5Ta8S3DFjMsXT1zRQJYGJ24Ine_qMRmFB=s1360-w1360-h1020-rw",
          "description": "Subterranean limestone cave networks inhabited by large bat colonies with underground rivers."
        }
      ]
    }
  };
}
