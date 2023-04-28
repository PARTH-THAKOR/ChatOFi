/// id : "cmpl-6s5oujilPgtjnOFWcaeJnBCHTxYID"
/// object : "text_completion"
/// created : 1678350104
/// model : "text-davinci-003"
/// choices : [{"text":"\n\n1. Create a StatefulWidget class and override the createState() method.\n\n2. Inside the createState() method, return a State object.\n\n3. Inside the State class, create a Container widget.\n\n4. Set the properties of the Container widget, such as color, padding, margin, etc.\n\n5. Add the Container widget to the widget tree using the build() method.\n\n6. Return the Container widget from the build() method.","index":0,"logprobs":null,"finish_reason":"stop"}]
/// usage : {"prompt_tokens":7,"completion_tokens":102,"total_tokens":109}

class ChatBotModel {
  ChatBotModel({
    String? id,
    String? object,
    num? created,
    String? model,
    List<Choices>? choices,
    Usage? usage,
  }) {
    _id = id;
    _object = object;
    _created = created;
    _model = model;
    _choices = choices;
    _usage = usage;
  }

  ChatBotModel.fromJson(dynamic json) {
    _id = json['id'];
    _object = json['object'];
    _created = json['created'];
    _model = json['model'];
    if (json['choices'] != null) {
      _choices = [];
      json['choices'].forEach((v) {
        _choices?.add(Choices.fromJson(v));
      });
    }
    _usage = json['usage'] != null ? Usage.fromJson(json['usage']) : null;
  }

  String? _id;
  String? _object;
  num? _created;
  String? _model;
  List<Choices>? _choices;
  Usage? _usage;

  ChatBotModel copyWith({
    String? id,
    String? object,
    num? created,
    String? model,
    List<Choices>? choices,
    Usage? usage,
  }) =>
      ChatBotModel(
        id: id ?? _id,
        object: object ?? _object,
        created: created ?? _created,
        model: model ?? _model,
        choices: choices ?? _choices,
        usage: usage ?? _usage,
      );

  String? get id => _id;

  String? get object => _object;

  num? get created => _created;

  String? get model => _model;

  List<Choices>? get choices => _choices;

  Usage? get usage => _usage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['object'] = _object;
    map['created'] = _created;
    map['model'] = _model;
    if (_choices != null) {
      map['choices'] = _choices?.map((v) => v.toJson()).toList();
    }
    if (_usage != null) {
      map['usage'] = _usage?.toJson();
    }
    return map;
  }
}

/// prompt_tokens : 7
/// completion_tokens : 102
/// total_tokens : 109

class Usage {
  Usage({
    num? promptTokens,
    num? completionTokens,
    num? totalTokens,
  }) {
    _promptTokens = promptTokens;
    _completionTokens = completionTokens;
    _totalTokens = totalTokens;
  }

  Usage.fromJson(dynamic json) {
    _promptTokens = json['prompt_tokens'];
    _completionTokens = json['completion_tokens'];
    _totalTokens = json['total_tokens'];
  }

  num? _promptTokens;
  num? _completionTokens;
  num? _totalTokens;

  Usage copyWith({
    num? promptTokens,
    num? completionTokens,
    num? totalTokens,
  }) =>
      Usage(
        promptTokens: promptTokens ?? _promptTokens,
        completionTokens: completionTokens ?? _completionTokens,
        totalTokens: totalTokens ?? _totalTokens,
      );

  num? get promptTokens => _promptTokens;

  num? get completionTokens => _completionTokens;

  num? get totalTokens => _totalTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['prompt_tokens'] = _promptTokens;
    map['completion_tokens'] = _completionTokens;
    map['total_tokens'] = _totalTokens;
    return map;
  }
}

/// text : "\n\n1. Create a StatefulWidget class and override the createState() method.\n\n2. Inside the createState() method, return a State object.\n\n3. Inside the State class, create a Container widget.\n\n4. Set the properties of the Container widget, such as color, padding, margin, etc.\n\n5. Add the Container widget to the widget tree using the build() method.\n\n6. Return the Container widget from the build() method."
/// index : 0
/// logprobs : null
/// finish_reason : "stop"

class Choices {
  Choices({
    String? text,
    num? index,
    dynamic logprobs,
    String? finishReason,
  }) {
    _text = text;
    _index = index;
    _logprobs = logprobs;
    _finishReason = finishReason;
  }

  Choices.fromJson(dynamic json) {
    _text = json['text'];
    _index = json['index'];
    _logprobs = json['logprobs'];
    _finishReason = json['finish_reason'];
  }

  String? _text;
  num? _index;
  dynamic _logprobs;
  String? _finishReason;

  Choices copyWith({
    String? text,
    num? index,
    dynamic logprobs,
    String? finishReason,
  }) =>
      Choices(
        text: text ?? _text,
        index: index ?? _index,
        logprobs: logprobs ?? _logprobs,
        finishReason: finishReason ?? _finishReason,
      );

  String? get text => _text;

  num? get index => _index;

  dynamic get logprobs => _logprobs;

  String? get finishReason => _finishReason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['index'] = _index;
    map['logprobs'] = _logprobs;
    map['finish_reason'] = _finishReason;
    return map;
  }
}
