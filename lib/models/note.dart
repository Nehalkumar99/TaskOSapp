class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  String _deadline;
  String _duration;

  Note(this._title, this._date, this._priority,
      [this._deadline, this._description, this._duration]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._deadline, this._description, this._duration]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;

  String get date => _date;

  String get deadline => _deadline;

  String get duration => _duration;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set deadline(String newDeadline) {
    this._deadline = newDeadline;
  }

  set duration(String newDuration) {
    this._duration = newDuration;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    map['deadline'] = _deadline;
    map['duration'] = _duration;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._deadline = map['deadline'];
    this._duration = map['duration'];
  }
}
