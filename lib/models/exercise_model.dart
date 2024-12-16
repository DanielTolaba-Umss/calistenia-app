// lib/models/exercise_model.dart

class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String difficulty;
  final String category;
  final List<String> images;
  final List<String> musclesInvolved;
  final int repetitions;
  final int restTime;
  final int sets;
  final String createdBy;
  final bool isFavorite;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.difficulty,
    required this.category,
    this.images = const [],
    this.musclesInvolved = const [],
    this.repetitions = 0,
    this.restTime = 0,
    this.sets = 0,
    this.createdBy = '',
    this.isFavorite = false,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map, String docId) {
    return ExerciseModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      iconName: map['iconName'] ?? 'fitness_center',
      difficulty: map['difficulty'] ?? '',
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      musclesInvolved: List<String>.from(map['musclesInvolved'] ?? []),
      repetitions: map['repetitions'] ?? 0,
      restTime: map['restTime'] ?? 0,
      sets: map['sets'] ?? 0,
      createdBy: map['createdBy'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'iconName': iconName,
      'difficulty': difficulty,
      'category': category,
      'images': images,
      'musclesInvolved': musclesInvolved,
      'repetitions': repetitions,
      'restTime': restTime,
      'sets': sets,
      'createdBy': createdBy,
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? difficulty,
    String? category,
    List<String>? images,
    List<String>? musclesInvolved,
    int? repetitions,
    int? restTime,
    int? sets,
    String? createdBy,
    bool? isFavorite,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      images: images ?? this.images,
      musclesInvolved: musclesInvolved ?? this.musclesInvolved,
      repetitions: repetitions ?? this.repetitions,
      restTime: restTime ?? this.restTime,
      sets: sets ?? this.sets,
      createdBy: createdBy ?? this.createdBy,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}