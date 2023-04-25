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

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${EventEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    EventEntity.start,
    EventEntity.end,
    EventEntity.history,
    EventEntity.status,
    EventEntity.room,
    EventEntity.attendances,
  ].map((e) => '${EventEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    EventEntity.status,
    EventEntity.room,
  ].map((e) => '${EventEntity.className}.$e').toList();

  static final List<String> relationCols = [
    EventEntity.attendances,
  ].map((e) => '${EventEntity.className}.$e').toList();

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (EventEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${EventEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (EventEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${EventEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (EventEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${EventEntity.className}.', ''))
        .toList();
  }

  Future<EventModel> toModel(
    ParseObject parseObject, [
    List<String> cols = const [],
  ]) async {
    print('PatientEntity.toModel cols: $cols');

    //+++ get attendance
    List<AttendanceModel> attendanceList = [];
    {
      QueryBuilder<ParseObject> queryAttendanceType =
          QueryBuilder<ParseObject>(ParseObject(AttendanceEntity.className));
      queryAttendanceType.whereRelatedTo(EventEntity.attendances,
          EventEntity.className, parseObject.objectId!);
      List<String> colsRelation = cols
          .where((e) => e.startsWith('${AttendanceEntity.className}.'))
          .toList();
      queryAttendanceType.keysToReturn([
        ...AttendanceEntity.filterSingleCols(colsRelation),
      ]);
      queryAttendanceType
          .includeObject(AttendanceEntity.filterPointerCols(colsRelation));
      // queryAttendanceType.includeObject([
      //   'professional',
      //   'professional.region',
      //   'procedure',
      //   'procedure.expertise',
      //   'patient',
      //   'patient.region',
      //   'healthPlan',
      //   'healthPlan.healthPlanType',
      //   'status',
      // ]);
      final ParseResponse parseResponse = await queryAttendanceType.query();
      if (parseResponse.success && parseResponse.results != null) {
        for (var e in parseResponse.results!) {
          attendanceList
              .add(await AttendanceEntity().toModel(e as ParseObject, cols));
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
