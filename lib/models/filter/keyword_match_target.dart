enum KeywordMatchTarget {
  titleOrBody('제목+본문'),
  titleOnly('제목만'),
  bodyOnly('본문만');

  final String label;
  const KeywordMatchTarget(this.label);
}