const words = [
    "Apple",
    "Banana",
    "Car",
    "House",
    "Tree",
    "Sun",
    "Moon",
    "Star",
    "Fish",
    "Cat",
    "Dog",
    "Bird",
    "Flower",
    "Cloud",
    "Ball",
    "Book",
    "Chair",
    "Table",
    "Cup",
    "Pizza",
    "Rocket",
    "Castle",
    "Robot",
    "Pirate",
    "Dinosaur",
    "Volcano",
    "Rainbow",
    "Guitar",
    "Bicycle",
    "Airplane",
    "Telescope",
    "Treasure",
    "Lighthouse",
    "Firefighter",
    "Superhero",
    "Mermaid",
    "Dragon",
    "Ghost",
    "Monster",
    "Wizard",
  ];


export const getWord = () => {
  let word = '';
  const randomIndex = Math.floor(Math.random() * words.length);
  word = words[randomIndex];
  return word;
};
