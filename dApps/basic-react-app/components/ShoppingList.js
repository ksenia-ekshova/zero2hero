function ShoppingList() {
  const items = ["Backback", "Clothes", "Shoes", "Pen"];

  return (
    <>
      <h1>Shopping List</h1>
      <ul>
        {items.map((item, index) => (
          <li key={index}>{item}</li>
        ))}
      </ul>
    </>
  );
}

export default ShoppingList;
