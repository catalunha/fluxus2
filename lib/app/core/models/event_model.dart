import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'attendance_model.dart';
import 'room_model.dart';
import 'status_model.dart';

class EventModel {
  final String? id;
  final List<AttendanceModel>? attendances;
  final RoomModel? room;
  final StatusModel? status;
  final DateTime? start;
  final DateTime? end;
  final String? history;
  int duration() {
    Duration diff = end!.difference(start!);
    return diff.inMinutes;
  }

  EventModel({
    this.id,
    this.attendances,
    this.room,
    this.start,
    this.end,
    this.status,
    this.history,
  });

  EventModel copyWith({
    String? id,
    List<AttendanceModel>? attendances,
    RoomModel? room,
    DateTime? start,
    DateTime? end,
    StatusModel? status,
    String? history,
  }) {
    return EventModel(
      id: id ?? this.id,
      attendances: attendances ?? this.attendances,
      room: room ?? this.room,
      start: start ?? this.start,
      end: end ?? this.end,
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (attendances != null) {
      result
          .addAll({'attendances': attendances!.map((x) => x.toMap()).toList()});
    }
    if (room != null) {
      result.addAll({'room': room!.toMap()});
    }
    if (start != null) {
      result.addAll({'start': start!.millisecondsSinceEpoch});
    }
    if (end != null) {
      result.addAll({'end': end!.millisecondsSinceEpoch});
    }
    if (status != null) {
      result.addAll({'status': status!.toMap()});
    }
    if (history != null) {
      result.addAll({'history': history});
    }

    return result;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      attendances: map['attendances'] != null
          ? List<AttendanceModel>.from(
              map['attendances']?.map((x) => AttendanceModel.fromMap(x)))
          : null,
      room: map['room'] != null ? RoomModel.fromMap(map['room']) : null,
      start: map['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start'])
          : null,
      end: map['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end'])
          : null,
      status: map['status'] != null ? StatusModel.fromMap(map['status']) : null,
      history: map['history'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id, attendances: $attendances, room: $room, start: $start, end: $end, status: $status, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.id == id &&
        listEquals(other.attendances, attendances) &&
        other.room == room &&
        other.start == start &&
        other.end == end &&
        other.status == status &&
        other.history == history;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        attendances.hashCode ^
        room.hashCode ^
        start.hashCode ^
        end.hashCode ^
        status.hashCode ^
        history.hashCode;
  }
}
