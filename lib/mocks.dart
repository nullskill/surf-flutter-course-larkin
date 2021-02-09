import 'package:places/domain/sight.dart';

/// Список интересных мест
final mocks = <Sight>[
  Sight(
    name: "Центр современного искусства «Винзавод»",
    lat: 55.75569,
    lng: 37.66458,
    url:
        "https://kudago.com/media/thumbs/xl/images/place/04/bf/04bf605cb52a1ad2bf1502ff864736fd.jpg",
    details:
        "Комплекс старинных павильонов постройки начала XIX века состоит из галерей, "
        "двух десятков магазинов, образовательных мастерских и необычных кафе.",
    type: SightType.particular_place,
  ),
  Sight(
    name: "Центр творческих индустрий «Фабрика»",
    lat: 55.77908,
    lng: 37.68887,
    url:
        "https://kudago.com/media/thumbs/xl/images/place/0d/1c/0d1cd06407b0e88b865a5e45ba7aec0b.jpg",
    details: "В центре «Фабрика», объединяющем выставочные пространства, "
        "театральные подмостки, мастерские кино и музыки, "
        "регулярно и практически без перерыва проходят "
        "бесплатные выставки современных художников.",
    type: SightType.particular_place,
  ),
  Sight(
    name: "Смотровая площадка PANORAMA360",
    lat: 55.74985,
    lng: 37.53772,
    url:
        "https://kudago.com/media/thumbs/xl/images/place/12/af/12afdd8bc989a84bdd0f6373b15f7c5f.jpg",
    details: "Здесь можно полюбоваться невероятными видами Москвы, "
        "посетить фабрику мороженого или шоколада, "
        "а также заглянуть в другие развлекательные зоны.",
    type: SightType.particular_place,
  ),
  Sight(
    name: "Музеи Московского Кремля",
    lat: 55.7520233,
    lng: 37.6174994,
    url: "https://img.localway.ru/scaled/guide/611/686555/820x0.jpg",
    details:
        "История музейного дела на территории Московского Кремля началась в 1806 году, "
        "когда по указу императора Александра I статус музея получила Оружейная палата.",
    type: SightType.museum,
  ),
  Sight(
    name: "Александровский сад",
    lat: 55.7506648,
    lng: 37.612579,
    url: "https://img.localway.ru/scaled/guide/611/686560/820x0.jpg",
    details:
        "От Красной площади до Кремлевской набережной вдоль западной стены Московского Кремля "
        "протянулся парк, история которого насчитывает почти два столетия.",
    type: SightType.park,
  ),
  Sight(
    name: "Ритц-Карлтон Москва",
    lat: 55.7575378,
    lng: 37.6138343,
    url: "https://cf.bstatic.com/images/hotel/max1280x900/140/140256156.jpg",
    details: "Отель Ritz-Carlton расположен возле Красной площади и Кремля. "
        "К услугам гостей просторные и стильные номера, оформленные в роскошном стиле "
        "и оснащенные современными удобствами.",
    type: SightType.hotel,
  ),
];

/// Список, желаемых к посещению мест
final favoriteMocks = <FavoriteSight>[
  FavoriteSight.fromSight(
    sight: mocks.first,
    plannedDate: DateTime.now(),
    openHour: DateTime.tryParse("1970-01-01 09:00:00"),
  ),
  FavoriteSight.fromSight(
    sight: mocks[1],
    plannedDate: DateTime.now(),
    openHour: DateTime.tryParse("1970-01-01 09:00:00"),
  ),
  FavoriteSight.fromSight(
    sight: mocks.last,
    plannedDate: DateTime.now(),
    openHour: DateTime.tryParse("1970-01-01 09:00:00"),
  ),
];

/// Список посещенных мест
final visitedMocks = <VisitedSight>[];

/// Список посещенных мест
final filteredMocks = <Sight>[];

/// Функция возвращает [filteredMocks], если не пустой, иначе [mocks]
List<Sight> getFilteredMocks() {
  return filteredMocks.isEmpty ? mocks : filteredMocks;
}

/// Список категорий интересных мест
final categories = <Category>[
  for (var type in SightType.values)
    Category.fromType(
      type: type,
    ),
];
