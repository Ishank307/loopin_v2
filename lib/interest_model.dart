// A simple class to represent an interest.
// The imageName is the unique identifier and the base for the asset file names.
class Interest {
  final String imageName;

  const Interest({required this.imageName});
}

// This is the single source of truth for all interests in the app.
// To add or remove an interest, you only need to change this list.
const List<Interest> allInterests = [
  Interest(imageName: 'party'),
  Interest(imageName: 'house_party'),
  Interest(imageName: 'picnic'),
  Interest(imageName: 'music'),
  Interest(imageName: 'activities'),
  Interest(imageName: 'liquor_tasting'),
  Interest(imageName: 'cook_fest'),
  Interest(imageName: 'lit_meet'),
];
