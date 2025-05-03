enum SortOption {
  idAsc,
  idDesc,
  nameAsc,
  nameDesc,
  speciesAsc,
  speciesDesc,
  statusAsc,
  statusDesc,
}

extension SortOptionLabal on SortOption {
  String get label {
    switch (this) {
      case SortOption.idAsc:
        return 'ID ↓';
      case SortOption.idDesc:
        return 'ID ↑';
      case SortOption.nameAsc:
        return 'Имя ↓';
      case SortOption.nameDesc:
        return 'Имя ↑';
      case SortOption.speciesAsc:
        return 'Вид ↓';
      case SortOption.speciesDesc:
        return 'Вид ↑';
      case SortOption.statusAsc:
        return 'Статус ↓';
      case SortOption.statusDesc:
        return 'Статус ↑';
    }
  }
}
