import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_type.dart';
import 'package:places/domain/visited_sight.dart';

/// Список интересных мест
final mocks = <Sight>[
  Sight(
    id: 1,
    name: 'Центр современного искусства «Винзавод»',
    lat: 55.75569,
    lng: 37.66458,
    urls: const [
      'https://kudago.com/media/thumbs/xl/images/place/04/bf/04bf605cb52a1ad2bf1502ff864736fd.jpg'
    ],
    details:
        'Комплекс старинных павильонов постройки начала XIX века состоит из галерей, '
        'двух десятков магазинов, образовательных мастерских и необычных кафе.',
    type: SightType.other,
  ),
  Sight(
    id: 2,
    name: 'Центр творческих индустрий «Фабрика»',
    lat: 55.77908,
    lng: 37.68887,
    urls: const [
      'https://kudago.com/media/thumbs/xl/images/place/0d/1c/0d1cd06407b0e88b865a5e45ba7aec0b.jpg'
    ],
    details: 'В центре «Фабрика», объединяющем выставочные пространства, '
        'театральные подмостки, мастерские кино и музыки, '
        'регулярно и практически без перерыва проходят '
        'бесплатные выставки современных художников.',
    type: SightType.other,
  ),
  Sight(
    id: 3,
    name: 'Смотровая площадка PANORAMA360',
    lat: 55.74985,
    lng: 37.53772,
    urls: const [
      'https://kudago.com/media/thumbs/xl/images/place/12/af/12afdd8bc989a84bdd0f6373b15f7c5f.jpg'
    ],
    details: 'Здесь можно полюбоваться невероятными видами Москвы, '
        'посетить фабрику мороженого или шоколада, '
        'а также заглянуть в другие развлекательные зоны.',
    type: SightType.other,
  ),
  Sight(
    id: 4,
    name: 'Музеи Московского Кремля',
    lat: 55.7520233,
    lng: 37.6174994,
    urls: const [
      'https://mos-holidays.ru/wp-content/uploads/2015/10/oruzheinaya-palata.jpg'
    ],
    details:
        'История музейного дела на территории Московского Кремля началась в 1806 году, '
        'когда по указу императора Александра I статус музея получила Оружейная палата.',
    type: SightType.museum,
  ),
  Sight(
    id: 5,
    name: 'Александровский сад',
    lat: 55.7506648,
    lng: 37.612579,
    urls: const ['https://i.msmap.ru/3/9/4/6/thumbs/700_467_fix.jpg'],
    details:
        'От Красной площади до Кремлевской набережной вдоль западной стены Московского Кремля '
        'протянулся парк, история которого насчитывает почти два столетия.',
    type: SightType.park,
  ),
  Sight(
    id: 6,
    name: 'Ритц-Карлтон Москва',
    lat: 55.7575378,
    lng: 37.6138343,
    urls: const [
      'https://cf.bstatic.com/images/hotel/max1280x900/140/140256156.jpg'
    ],
    details: 'Отель Ritz-Carlton расположен возле Красной площади и Кремля. '
        'К услугам гостей просторные и стильные номера, оформленные в роскошном стиле '
        'и оснащенные современными удобствами.',
    type: SightType.hotel,
  ),
];

/// Список, желаемых к посещению мест
final favoriteMocks = <FavoriteSight>[
  FavoriteSight.fromSight(mocks.first),
  FavoriteSight.fromSight(mocks[1]),
  FavoriteSight.fromSight(mocks.last),
];

/// Список посещенных мест
final visitedMocks = <VisitedSight>[];

/// Список отфильтрованных мест
final filteredMocks = <Sight>[];

/// Функция возвращает [filteredMocks], если не пустой, иначе [mocks]
List<Sight> getFilteredMocks() {
  return filteredMocks.isEmpty ? mocks : filteredMocks;
}

/// Новое интересное место
final newSight = Sight(
  name: 'Пицца от птицы',
  lat: 45.008986,
  lng: 41.922057,
  urls: const [
    'https://vogazeta.ru/uploads/full_size_1575545015-c59f0314cb936df655a6a19ca760f02c.jpg'
  ],
  details: 'Yum yum yum ',
  type: SightType.cafe,
);
