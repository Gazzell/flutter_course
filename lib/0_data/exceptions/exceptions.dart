class CacheException implements Exception {}

class CollectionNotFoundException implements CacheException {
  final String collectionId;
  CollectionNotFoundException({required this.collectionId});
}

class EntryNotFoundException implements CacheException {
  final String collectionId;
  final String entryId;
  EntryNotFoundException({
    required this.entryId,
    required this.collectionId,
  });
}
