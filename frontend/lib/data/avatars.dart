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
    id: 'skin_1',
    asset: 'assets/avatars/avatar1.jpg',
  ),
  Avatar(
    id: 'skin_2',
    asset: 'assets/avatars/avatar2.jpg',
  ),
  Avatar(
    id: 'skin_3',
    asset: 'assets/avatars/avatar3.jpg',
  ),
  Avatar(
    id: 'skin_4',
    asset: 'assets/avatars/avatar4.jpg',
  ),
];