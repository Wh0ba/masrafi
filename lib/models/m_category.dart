enum MCategory {
  food('طعام', 1),
  clothes('ملابس', 2),
  health('صحة', 3),
  entertainment('ترفيه', 4),
  education('تعليم', 5),
  other('اخرى', 6),
  income('دخل', 99),
  ;

  const MCategory(this.name, this.id);
  final String name;
  final int id;
}  

// class MCategory {
//   int id;
//   String name;
//   MCategory({required this.id, required this.name});
// }
