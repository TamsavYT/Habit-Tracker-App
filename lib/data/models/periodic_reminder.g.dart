// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periodic_reminder.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPeriodicReminderCollection on Isar {
  IsarCollection<PeriodicReminder> get periodicReminders => this.collection();
}

const PeriodicReminderSchema = CollectionSchema(
  name: r'PeriodicReminder',
  id: 6011463084454585933,
  properties: {
    r'enabled': PropertySchema(
      id: 0,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'endMinutes': PropertySchema(
      id: 1,
      name: r'endMinutes',
      type: IsarType.long,
    ),
    r'intervalMinutes': PropertySchema(
      id: 2,
      name: r'intervalMinutes',
      type: IsarType.long,
    ),
    r'label': PropertySchema(
      id: 3,
      name: r'label',
      type: IsarType.string,
    ),
    r'startMinutes': PropertySchema(
      id: 4,
      name: r'startMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _periodicReminderEstimateSize,
  serialize: _periodicReminderSerialize,
  deserialize: _periodicReminderDeserialize,
  deserializeProp: _periodicReminderDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _periodicReminderGetId,
  getLinks: _periodicReminderGetLinks,
  attach: _periodicReminderAttach,
  version: '3.1.0+1',
);

int _periodicReminderEstimateSize(
  PeriodicReminder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.label.length * 3;
  return bytesCount;
}

void _periodicReminderSerialize(
  PeriodicReminder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeLong(offsets[1], object.endMinutes);
  writer.writeLong(offsets[2], object.intervalMinutes);
  writer.writeString(offsets[3], object.label);
  writer.writeLong(offsets[4], object.startMinutes);
}

PeriodicReminder _periodicReminderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeriodicReminder();
  object.enabled = reader.readBool(offsets[0]);
  object.endMinutes = reader.readLong(offsets[1]);
  object.id = id;
  object.intervalMinutes = reader.readLong(offsets[2]);
  object.label = reader.readString(offsets[3]);
  object.startMinutes = reader.readLong(offsets[4]);
  return object;
}

P _periodicReminderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _periodicReminderGetId(PeriodicReminder object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _periodicReminderGetLinks(PeriodicReminder object) {
  return [];
}

void _periodicReminderAttach(
    IsarCollection<dynamic> col, Id id, PeriodicReminder object) {
  object.id = id;
}

extension PeriodicReminderQueryWhereSort
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QWhere> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PeriodicReminderQueryWhere
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QWhereClause> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterWhereClause> idBetween(
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
}

extension PeriodicReminderQueryFilter
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QFilterCondition> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      endMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      endMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      endMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      endMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      intervalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      intervalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      intervalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      intervalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      startMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      startMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      startMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterFilterCondition>
      startMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PeriodicReminderQueryObject
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QFilterCondition> {}

extension PeriodicReminderQueryLinks
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QFilterCondition> {}

extension PeriodicReminderQuerySortBy
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QSortBy> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByEndMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByEndMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinutes', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByStartMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      sortByStartMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinutes', Sort.desc);
    });
  }
}

extension PeriodicReminderQuerySortThenBy
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QSortThenBy> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByEndMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByEndMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinutes', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByIntervalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalMinutes', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByStartMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinutes', Sort.asc);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QAfterSortBy>
      thenByStartMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinutes', Sort.desc);
    });
  }
}

extension PeriodicReminderQueryWhereDistinct
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct> {
  QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct>
      distinctByEndMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMinutes');
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct>
      distinctByIntervalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalMinutes');
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeriodicReminder, PeriodicReminder, QDistinct>
      distinctByStartMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMinutes');
    });
  }
}

extension PeriodicReminderQueryProperty
    on QueryBuilder<PeriodicReminder, PeriodicReminder, QQueryProperty> {
  QueryBuilder<PeriodicReminder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PeriodicReminder, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<PeriodicReminder, int, QQueryOperations> endMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMinutes');
    });
  }

  QueryBuilder<PeriodicReminder, int, QQueryOperations>
      intervalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalMinutes');
    });
  }

  QueryBuilder<PeriodicReminder, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<PeriodicReminder, int, QQueryOperations> startMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMinutes');
    });
  }
}
