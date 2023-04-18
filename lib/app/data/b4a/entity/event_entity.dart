import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/attendance_model.dart';
import '../../../core/models/event_model.dart';
import 'attendance_entity.dart';
import 'room_entity.dart';
import 'status_entity.dart';

class EventEntity {
  static const String className = 'Event';
  static const String id = 'objectId';
  static const String attendances = 'attendances';
  static const String room = 'room';
  static const String start = 'start';
  static const String end = 'end';
  static const String status = 'status';
  static const String history = 'history';
  static const String description = 'description';

  Future<EventModel> toModel(ParseObject parseObject) async {
    //+++ get attendance
    List<AttendanceModel> attendanceList = [];
    {
      QueryBuilder<ParseObject> queryAttendanceType =
          QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
      queryAttendanceType.whereRelatedTo(EventEntity.attendances,
          EventEntity.className, parseObject.objectId!);
      final ParseResponse parseResponse = await queryAttendanceType.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          attendanceList
              .add(await AttendanceEntity().toModel(e as ParseObject));
        }
      }
    }
    //--- get healthPlan
    EventModel model = EventModel(
      id: parseObject.objectId!,
      attendances: attendanceList,
      room: parseObject.get(EventEntity.room) != null
          ? RoomEntity().toModel(parseObject.get(EventEntity.room))
          : null,
      start: parseObject.get<DateTime>(EventEntity.start)?.toLocal(),
      end: parseObject.get<DateTime>(EventEntity.end)?.toLocal(),
      status: parseObject.get(EventEntity.status) != null
          ? StatusEntity().toModel(parseObject.get(EventEntity.status))
          : null,
      history: parseObject.get(EventEntity.history),
    );
    return model;
  }

  Future<ParseObject> toParse(EventModel model) async {
    final parseObject = ParseObject(EventEntity.className);
    parseObject.objectId = model.id;
    if (model.room != null) {
      parseObject.set(
          EventEntity.room,
          (ParseObject(RoomEntity.className)..objectId = model.room!.id)
              .toPointer());
    }
    if (model.start != null) {
      parseObject.set<DateTime?>(EventEntity.start, model.start);
    }
    if (model.end != null) {
      parseObject.set<DateTime?>(EventEntity.end, model.end);
    }
    if (model.status != null) {
      parseObject.set(
          EventEntity.status,
          (ParseObject(StatusEntity.className)..objectId = model.status!.id)
              .toPointer());
    }
    if (model.history != null) {
      parseObject.set(EventEntity.history, model.history);
    }
    return parseObject;
  }

  ParseObject? toParseRelationAttendances({
    required String objectId,
    required List<String> ids,
    required bool add,
  }) {
    final parseObject = ParseObject(EventEntity.className);
    parseObject.objectId = objectId;
    if (ids.isEmpty) {
      parseObject.unset(EventEntity.attendances);
      return parseObject;
    }
    if (add) {
      parseObject.addRelation(
        EventEntity.attendances,
        ids
            .map(
              (element) =>
                  ParseObject(AttendanceEntity.className)..objectId = element,
            )
            .toList(),
      );
    } else {
      parseObject.removeRelation(
          EventEntity.attendances,
          ids
              .map((element) =>
                  ParseObject(AttendanceEntity.className)..objectId = element)
              .toList());
    }
    return parseObject;
  }
}
