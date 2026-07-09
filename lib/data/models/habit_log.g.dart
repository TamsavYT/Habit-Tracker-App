// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitLogCollection on Isar {
  IsarCollection<HabitLog> get habitLogs => this.collection();
}

const HabitLogSchema = CollectionSchema(
  name: r'HabitLog',
  id: -4172717797988407309,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'habitId': PropertySchema(
      id: 2,
      name: r'habitId',
      type: IsarType.long,
    )
  },
  estimateSize: _habitLogEstimateSize,
  serialize: _habitLogSerialize,
  deserialize: _habitLogDeserialize,
  deserializeProp: _habitLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'habitId_date': IndexSchema(
      id: -8738549928736890525,
      name: r'habitId_date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'habitId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _habitLogGetId,
  getLinks: _habitLogGetLinks,
  attach: _habitLogAttach,
  version: '3.1.0+1',
);

int _habitLogEstimateSize(
  HabitLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _habitLogSerialize(
  HabitLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.habitId);
}

HabitLog _habitLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitLog();
  object.completed = reader.readBool(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.habitId = reader.readLong(offsets[2]);
  object.id = id;
  return object;
}

P _habitLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitLogGetId(HabitLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitLogGetLinks(HabitLog object) {
  return [];
}

void _habitLogAttach(IsarCollection<dynamic> col, Id id, HabitLog object) {
  object.id = id;
}

extension HabitLogByIndex on IsarCollection<HabitLog> {
  Future<HabitLog?> getByHabitIdDate(int habitId, DateTime date) {
    return getByIndex(r'habitId_date', [habitId, date]);
  }

  HabitLog? getByHabitIdDateSync(int habitId, DateTime date) {
    return getByIndexSync(r'habitId_date', [habitId, date]);
  }

  Future<bool> deleteByHabitIdDate(int habitId, DateTime date) {
    return deleteByIndex(r'habitId_date', [habitId, date]);
  }

  bool deleteByHabitIdDateSync(int habitId, DateTime date) {
    return deleteByIndexSync(r'habitId_date', [habitId, date]);
  }

  Future<List<HabitLog?>> getAllByHabitIdDate(
      List<int> habitIdValues, List<DateTime> dateValues) {
    final len = habitIdValues.length;
    assert(
        dateValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([habitIdValues[i], dateValues[i]]);
    }

    return getAllByIndex(r'habitId_date', values);
  }

  List<HabitLog?> getAllByHabitIdDateSync(
      List<int> habitIdValues, List<DateTime> dateValues) {
    final len = habitIdValues.length;
    assert(
        dateValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([habitIdValues[i], dateValues[i]]);
    }

    return getAllByIndexSync(r'habitId_date', values);
  }

  Future<int> deleteAllByHabitIdDate(
      List<int> habitIdValues, List<DateTime> dateValues) {
    final len = habitIdValues.length;
    assert(
        dateValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([habitIdValues[i], dateValues[i]]);
    }

    return deleteAllByIndex(r'habitId_date', values);
  }

  int deleteAllByHabitIdDateSync(
      List<int> habitIdValues, List<DateTime> dateValues) {
    final len = habitIdValues.length;
    assert(
        dateValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([habitIdValues[i], dateValues[i]]);
    }

    return deleteAllByIndexSync(r'habitId_date', values);
  }

  Future<Id> putByHabitIdDate(HabitLog object) {
    return putByIndex(r'habitId_date', object);
  }

  Id putByHabitIdDateSync(HabitLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'habitId_date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHabitIdDate(List<HabitLog> objects) {
    return putAllByIndex(r'habitId_date', objects);
  }

  List<Id> putAllByHabitIdDateSync(List<HabitLog> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'habitId_date', objects, saveLinks: saveLinks);
  }
}

extension HabitLogQueryWhereSort on QueryBuilder<HabitLog, HabitLog, QWhere> {
  QueryBuilder<HabitLog, HabitLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhere> anyHabitIdDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'habitId_date'),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension HabitLogQueryWhere on QueryBuilder<HabitLog, HabitLog, QWhereClause> {
  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdEqualToAnyDate(
      int habitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'habitId_date',
        value: [habitId],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdNotEqualToAnyDate(
      int habitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdGreaterThanAnyDate(
    int habitId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [habitId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdLessThanAnyDate(
    int habitId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [],
        upper: [habitId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdBetweenAnyDate(
    int lowerHabitId,
    int upperHabitId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [lowerHabitId],
        includeLower: includeLower,
        upper: [upperHabitId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdDateEqualTo(
      int habitId, DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'habitId_date',
        value: [habitId, date],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause>
      habitIdEqualToDateNotEqualTo(int habitId, DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId],
              upper: [habitId, date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId, date],
              includeLower: false,
              upper: [habitId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId, date],
              includeLower: false,
              upper: [habitId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId_date',
              lower: [habitId],
              upper: [habitId, date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause>
      habitIdEqualToDateGreaterThan(
    int habitId,
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [habitId, date],
        includeLower: include,
        upper: [habitId],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause>
      habitIdEqualToDateLessThan(
    int habitId,
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [habitId],
        upper: [habitId, date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> habitIdEqualToDateBetween(
    int habitId,
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'habitId_date',
        lower: [habitId, lowerDate],
        includeLower: includeLower,
        upper: [habitId, upperDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HabitLogQueryFilter
    on QueryBuilder<HabitLog, HabitLog, QFilterCondition> {
  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> habitIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HabitLogQueryObject
    on QueryBuilder<HabitLog, HabitLog, QFilterCondition> {}

extension HabitLogQueryLinks
    on QueryBuilder<HabitLog, HabitLog, QFilterCondition> {}

extension HabitLogQuerySortBy on QueryBuilder<HabitLog, HabitLog, QSortBy> {
  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }
}

extension HabitLogQuerySortThenBy
    on QueryBuilder<HabitLog, HabitLog, QSortThenBy> {
  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitLog, HabitLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension HabitLogQueryWhereDistinct
    on QueryBuilder<HabitLog, HabitLog, QDistinct> {
  QueryBuilder<HabitLog, HabitLog, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<HabitLog, HabitLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<HabitLog, HabitLog, QDistinct> distinctByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId');
    });
  }
}

extension HabitLogQueryProperty
    on QueryBuilder<HabitLog, HabitLog, QQueryProperty> {
  QueryBuilder<HabitLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitLog, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<HabitLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<HabitLog, int, QQueryOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }
}
