class Sight {
  String _name;
  double _lan, _lon;
  String _url;
  String _details;
  String _type;

  get name => _name;
  get lan => _lan;
  get lon => _lon;
  get url => _url;
  get details => _details;
  get type => _type;

  Sight(
      {String name,
      double lan,
      double lon,
      String url,
      String details,
      String type}) {
    this._name = name;
    this._lan = lan;
    this._lon = lon;
    this._url = url;
    this._details = details;
    this._type = type;
  }
}
