class Avatar {
  final String id;
  final String asset;

  const Avatar({
    required this.id,
    required this.asset,
  });
}

const avatars = [
  Avatar(
    id: '0',
    asset: 'assets/avatars/avatar1.jpg',
  ),
  Avatar(
    id: '1',
    asset: 'assets/avatars/avatar2.jpg',
  ),
  Avatar(
    id: '2',
    asset: 'assets/avatars/avatar3.jpg',
  ),
  Avatar(
    id: '3',
    asset: 'assets/avatars/avatar4.jpg',
  ),
];

Avatar getAvatar(String id) {
  return avatars.firstWhere(
    (avatar) => avatar.id == id,
    orElse: () => avatars.first,
  );
}